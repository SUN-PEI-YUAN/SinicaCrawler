# -*- coding: utf-8 -*-
import scrapy

from scrapy.spidermiddlewares.httperror import HttpError
from twisted.internet.error import DNSLookupError
from twisted.internet.error import TimeoutError, TCPTimedOutError


from urllib.parse import urljoin
# data model
# from www_iyp_com_tw.items import WwwIypComTwItem


class CrawlerSpider(scrapy.Spider):
    name = 'crawler'
    # allowed_domains = ['https://ww÷w.iyp.com.tw/']

    start_urls = ['http://www.iyp.com.tw/']

    def getRequestHref(self, response):
        '''Get herf'''
        hrefs = response.xpath('//*[@id="category-list"]/li/div/ul/li/ul/li/div/a/@href').getall()
        for i in hrefs:
            yield scrapy.Request(urljoin('http://www.iyp.com.tw/', i))

    # def start(self):
        # yield scrapy.Request(start_urls)

    def parse(self, response):
        yield scrapy.Request(self.start_urls[0], encoding='utf-8', callback=self.getRequestHref)

    # def start(self):
    #     # self.start_urls = self.getPostArgs()

    #     for url in self.start_urls:
    #         yield scrapy.Request(url, callback=self.parse, errback=self.err)

    # def parse(self, response):
    #     self.logger.info(
    #         'Got successful response from {}'.format(response.url))

    # def err(self, failure):
    #     self.logger.error(repr(failure))
    #     if failure.check(HttpError):
    #         # these exceptions come from HttpError spider middleware
    #         # you can get the non-200 response
    #         response = failure.value.response
    #         self.logger.error('HttpError on %s', response.url)

    #     elif failure.check(DNSLookupError):
    #         # this is the original request
    #         request = failure.request
    #         self.logger.error('DNSLookupError on %s', request.url)

    #     elif failure.check(TimeoutError, TCPTimedOutError):
    #         request = failure.request
    #         self.logger.error('TimeoutError on %s', request.url)
