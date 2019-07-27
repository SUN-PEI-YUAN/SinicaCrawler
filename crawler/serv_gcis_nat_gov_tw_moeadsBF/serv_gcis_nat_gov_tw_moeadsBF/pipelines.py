# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html
from serv_gcis_nat_gov_tw_moeadsBF.spiders.crawler import PDF_LOG
from serv_gcis_nat_gov_tw_moeadsBF.crawler_setting import *
from scrapy.pipelines.files import FilesPipeline
from scrapy.exporters import CsvItemExporter
from scrapy.exceptions import DropItem
from scrapy import Request


class ServGcisNatGovTwMoeadsbfPipeline(object):
    def process_item(self, item, spider):
        return item


class PdfCsvPipeline(CsvItemExporter):
    '''紀錄一共有幾筆pdf'''

    def __init__(self):
        self.fname = os.path.join(SAVE_PATH, "pdflist.csv")
        self.file = open(self.fname, "wb")
        self.exporter = CsvItemExporter(file=self.file,
                                        fields_to_export=["files", "file_urls"])
        self.exporter.start_exporting()

    def close_spider(self, spider):
        self.exporter.finish_exporting()
        self.file.close()

    def process_item(self, item, spider):
        self.exporter.export_item(item)
        return item


class PdfFilesPipeline(FilesPipeline):
    '''Crawler下載 pdf 之模型'''

    def get_media_requests(self, item, info):
        yield Request(item['file_urls'][0], meta={'filename': item['files']})
        PDF_LOG.logger(item['files'], item['file_urls'][0], 200, level='info')

    def file_path(self, request, response=None, info=None):
        return request.meta['filename']

    def item_completed(self, results, item, info):
        file_paths = [x['path'] for ok, x in results if ok]
        if not file_paths:
            raise DropItem("Item contains no files.")
        return item
