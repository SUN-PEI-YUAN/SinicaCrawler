# -*- coding: utf-8 -*-
import scrapy

from scrapy.spidermiddlewares.httperror import HttpError
from twisted.internet.error import DNSLookupError
from twisted.internet.error import TimeoutError, TCPTimedOutError


from urllib.parse import urljoin
from bs4 import BeautifulSoup as bs
from www_iyp_com_tw.items import WwwIypComTwItem

import re


class CrawlerSpider(scrapy.Spider):
    name = 'crawler'
    # allowed_domains = ['https://ww÷w.iyp.com.tw/']

    start_urls = ['http://www.iyp.com.tw/']

    def parsePage(self, response):
        '''Get page data'''
        item = WwwIypComTwItem()

        type_html = response.css('#breadcrumb')[0]
        data_html = response.css('#search-res:not(.storebox)')[0]

        fst = type_html.css('a:nth-of-type(2)::text').get()
        snd = type_html.css('a:nth-of-type(3)::text').get()
        trd = type_html.css('strong:nth-of-type(1)::text').get()

        store_names = data_html.xpath('//li/h3[1]/a[1]/@title').getall()
        phone_nums = data_html.xpath("//li[@class='tel' and 1]/img[@class='rollLoad' and 1]/@data-url").getall()
        phone_nums = [re.split('//', i)[-1] for i in phone_nums]
        addresses = [re.split('/', tag.attrib['go-map'])[-1]
                     for tag in data_html.xpath("//li/ul/li[2]/span[2]")]

        data = zip(store_names, phone_nums, addresses)

        for store_name, phone_num, address in data:
            yield {
                'first_label': fst,
                'second_label': snd,
                'third_label': trd,
                'store_name': store_name,
                'phone_num': phone_num,
                'address': address,
            }

        next_page_href = response.xpath(
            "//div[4]/a[@class='next' and last()]/@href").get()
        next_page = urljoin(self.start_urls[0], next_page_href)

        if next_page is not None:
            yield response.follow(next_page, self.parse)

    def getRequestHref(self, response):
        '''Get index herf'''
        hrefs = response.xpath(
            '//*[@id="category-list"]/li/div/ul/li/ul/li/div/a/@href').getall()
        for url in hrefs:
            yield scrapy.Request(urljoin('http://www.iyp.com.tw/', url), callback=self.parsePage)

    def parse(self, response):
        '''Index page request'''
        yield scrapy.Request(self.start_urls[0], encoding='utf-8', callback=self.getRequestHref)
