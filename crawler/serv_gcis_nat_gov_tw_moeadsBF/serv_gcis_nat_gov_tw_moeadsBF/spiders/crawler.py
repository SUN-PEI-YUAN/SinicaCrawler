# -*- coding: utf-8 -*-
from scrapy.exporters import CsvItemExporter
from serv_gcis_nat_gov_tw_moeadsBF.items import ServGcisNatGovTwMoeadsbfItem
from serv_gcis_nat_gov_tw_moeadsBF.crawler_setting import *
from serv_gcis_nat_gov_tw_moeadsBF.plugin import Log
from urllib.parse import urljoin
from os import makedirs
import os.path
import logging
import scrapy


# 建立資料夾
makedirs(os.path.join(SAVE_PATH), exist_ok=True)

makedirs(PDF_SAVE_LINK, exist_ok=True)

HTML_LOG = Log(logger_name='html', log_fname=HTML_LOGFNAME,
               init_format=LOG_INIT_FORMAT, log_format=LOG_FORMAT, datefmt=LOG_TIME_FORMAT)

PDF_LOG = Log(logger_name='pdf', log_fname=PDF_LOGFNAME,
              init_format=LOG_INIT_FORMAT, log_format=LOG_FORMAT, datefmt=LOG_TIME_FORMAT)


class CrawlerSpider(scrapy.Spider):
    '''經濟部-商業登記資料查詢爬蟲
    抓取各縣市年份商業登記pdf資料
    網址: https://serv.gcis.nat.gov.tw/moeadsBF/bms/report.jsp?method=first&agencyCode=allbf&showGcisLocation=false&showBusi=true&showFact=false
    '''
    # 爬蟲名稱
    name = 'crawler'

    # 載入pdf檔案床路徑
    from serv_gcis_nat_gov_tw_moeadsBF.crawler_setting import PDF_SAVE_LINK

    custom_settings = {
        'FILES_STORE': PDF_SAVE_LINK,
    }

    start_urls = [
        INDEX,
    ]

    def getPostArgs(self):
        '''Get POST argument'''
        from lxml import etree
        import requests as rqs
        import itertools
        with rqs.get(self.start_urls[0], timeout=360) as response:
            response.encoding = 'big5'

            # parse post_args
            dom = etree.HTML(response.text)
            countrys = dom.xpath('//select[1]/option[position()>1]/@value')
            years = dom.xpath('//select[2]/option[position()>1]/@value')

            post_args = itertools.product(countrys, years)
            return post_args

    def getFile(self, response):
        '''抓取pdf檔案連結'''
        item = ServGcisNatGovTwMoeadsbfItem()

        gov_name = response.xpath(GOV_NAME_SELECTOR).getall()[1]
        url_text = response.xpath(URL_TEXT_SELECTOR).getall()
        pdf_links = response.xpath(PDF_LINK_SELECTOR).getall()
        url_href = [urljoin(PDF_LINK, link) for link in pdf_links]
        fname = [f'{gov_name}{text}.pdf' for text in url_text]

        pdfinfo = zip(fname, url_href)

        for fname, url in pdfinfo:
            item['files'] = fname
            item['file_urls'] = [url]
            yield item

    def parse(self, response):
        '''start'''
        post_args = self.getPostArgs()

        post_list = []

        # 清除已經發送過的POST資料
        if os.path.exists(POST_DATA_LOG):
            total = set(post_args)
            with open(POST_DATA_LOG) as logfile:
                record = logfile.read()
                if len(record) == 0:
                    catched = set()
                else:
                    catched = set(eval(record))
                    post_args = list(total - catched)
        else:
            catched = set()

        # 爬網頁
        for country, year in post_args:
            formdata = {'area': country, 'YYYMM': year, }
            yield scrapy.http.FormRequest(url=INDEX, formdata=formdata, encoding='big5', callback=self.getFile)
            HTML_LOG.logger(country, year, 200, level='info')
            post_list.append((country, year,))

        # 紀錄發送過的POST資料
        with open(POST_DATA_LOG, 'w') as logfile:
            log = list(catched | set(post_list))
            log = str(log)
            logfile.write(log)
