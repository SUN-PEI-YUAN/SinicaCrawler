# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html

from www_iyp_com_tw.crawler_setting import DATA_FNAME
from scrapy.exporters import CsvItemExporter


class WwwIypComTwPipeline(object):
    def process_item(self, item, spider):
        item.setdefault('first_label', 'NULL')
        item.setdefault('second_label', 'NULL')
        item.setdefault('third_label', 'NULL')
        item.setdefault('store_name', 'NULL')
        item.setdefault('phone_num', 'NULL')
        item.setdefault('address', 'NULL')
        return item


class CsvPipeline(CsvItemExporter):
    '''紀錄一共有幾筆pdf'''

    def __init__(self):
        self.fname = DATA_FNAME
        self.file = open(self.fname, "wb")
        self.exporter = CsvItemExporter(file=self.file,
                                        fields_to_export=['first_label', 'second_label', 'third_label', 'store_name', 'phone_num', 'address', ])
        self.exporter.start_exporting()

    def close_spider(self, spider):
        self.exporter.finish_exporting()
        self.file.close()

    def process_item(self, item, spider):
        self.exporter.export_item(item)
        return item
