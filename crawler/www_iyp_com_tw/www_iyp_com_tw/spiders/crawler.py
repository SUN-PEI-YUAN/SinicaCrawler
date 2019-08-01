# -*- coding: utf-8 -*-
from www_iyp_com_tw.items import WwwIypComTwItem
from scrapy.exporters import CsvItemExporter
from www_iyp_com_tw.crawler_setting import *
from www_iyp_com_tw.plugin import Log
from urllib.parse import urljoin
from os import makedirs
import os.path
import logging
import scrapy
import re


# 建立資料夾
makedirs(os.path.join(SAVE_PATH), exist_ok=True)


HTML_LOG = Log(logger_name='html', log_fname=HTML_LOGFNAME,
               init_format=LOG_INIT_FORMAT, log_format=LOG_FORMAT, datefmt=LOG_TIME_FORMAT)


class CrawlerSpider(scrapy.Spider):
    name = 'crawler'

    start_urls = [
        INDEX,
        # 'https://www.iyp.com.tw/food-catering/beer-house.html',
        # 'https://www.iyp.com.tw/food-catering/ice-shops.html',
        # 'https://www.iyp.com.tw/food-catering/cafe.html',
    ]

    def start_requests(self):
        yield scrapy.Request(self.start_urls[0], encoding='utf-8', callback=self.parse)

    def parse(self, response):
        '''Get index herf'''
        hrefs = response.xpath('//*[@id="category-list"]/li/div/ul/li/ul/li/div/a/@href').getall()
        for url in hrefs:
            yield scrapy.Request(urljoin(INDEX, url), callback=self.parsedata)

    def parsedata(self, response):
        '''爬取網頁資料'''
        item = WwwIypComTwItem()

        type_html = response.css('#breadcrumb')[0]
        data_html = response.css('#search-res:not(.storebox)')[0]

        fst = type_html.css('a:nth-of-type(2)::text').get()
        snd = type_html.css('a:nth-of-type(3)::text').get()
        trd = type_html.css('strong:nth-of-type(1)::text').get()

        store_names = data_html.xpath('//li/h3[1]/a[1]/@title').getall()
        phone_nums = data_html.xpath("//li[@class='tel' and 1]/img[@class='rollLoad' and 1]/@data-url").getall()
        phone_nums = [urljoin('https:', i) for i in phone_nums if len(i) > 0]
        addresses = [re.split('/', tag.attrib['go-map'])[-1]
                     for tag in data_html.xpath("//li/ul/li[2]/span[2]")]

        data = zip(store_names, phone_nums, addresses)
        
        # 資料流
        for store_name, phone_num, address in data:
            item['first_label'] = fst
            item['second_label'] = snd
            item['third_label'] = trd
            item['store_name'] = store_name
            item['phone_num'] = phone_num
            item['address'] = address
            yield item
        
        HTML_LOG.logger(response.url, response.status, level='info')

        # 下一頁
        next_page_href = response.xpath('//*[@id="content"]/div[4]/a[last()]/@href').get()
        next_page = urljoin('https://www.iyp.com.tw/', next_page_href)
        print('>>>>>>>>>', next_page)

        if next_page is not None:
            yield response.follow(next_page, self.parsedata)
