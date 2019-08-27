# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html

from www_iyp_com_tw.crawler_setting import DATA_FNAME, SAVE_PATH
from scrapy.pipelines.images import ImagesPipeline
from scrapy.exceptions import DropItem
from scrapy import Request
from time import sleep
from os import remove
import os.path

class WwwIypComTwPipeline(object):
    def process_item(self, item, spider):
        item.setdefault('first_label', 'NULL')
        item.setdefault('second_label', 'NULL')
        item.setdefault('third_label', 'NULL')
        item.setdefault('store_name', 'NULL')
        item.setdefault('phone_num', 'NULL')
        item.setdefault('address', 'NULL')
        return item


class CsvPipeline(object):
    '''紀錄一共有幾筆pdf'''

    def __init__(self):
        self.fname = DATA_FNAME
        self.file = open(self.fname, "w", encoding='utf-8')
        self.header = 'first_label,second_label,third_label,store_name,phone_num,address\n'
        self.file.write(self.header)

    def process_item(self, item, spider):
        # 先提取數字之後放回csv資料當中
        import pytesseract
        try:
            from PIL import Image
        except ImportError:
            import Image
        
        if os.path.exists(item['img_path']):
            try:
                with Image.open(item['img_path']) as img:
                    item['phone_num'] = pytesseract.image_to_string(img)
            except:                    
                item['phone_num'] = item['img_path']
        else: 
            item['phone_num'] = 'NULL'

        row_data = f"{item['first_label']},{item['second_label']},{item['third_label']},{item['store_name']},{item['phone_num']},{item['address']}\n"
        self.file.write(row_data)
        return item

    def close_spider(self, spider):
        self.file.close()


class ImagePipeline(ImagesPipeline):

    def get_media_requests(self, item, info):
        yield Request(item['phone_num'])

    def item_completed(self, results, item, info):
        image_paths = [x['path'] for ok, x in results if ok]
        if not image_paths:
            raise DropItem("Item contains no images")
        item['phone_num'] = os.path.join(SAVE_PATH, image_paths[0])
        return item