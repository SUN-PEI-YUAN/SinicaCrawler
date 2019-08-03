# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# https://docs.scrapy.org/en/latest/topics/items.html

import scrapy


class WwwIypComTwItem(scrapy.Item):
    # define the fields for your item here like:
    # name = scrapy.Field()
    first_label = scrapy.Field()
    second_label = scrapy.Field()
    third_label = scrapy.Field()
    store_name = scrapy.Field()
    phone_num = scrapy.Field()
    phone_url = scrapy.Field()
    address = scrapy.Field()
    img_path = scrapy.Field()