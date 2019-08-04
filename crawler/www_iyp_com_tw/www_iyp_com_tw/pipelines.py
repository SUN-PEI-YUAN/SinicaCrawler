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
import pytesseract
import os.path
try:
    from PIL import Image
except ImportError:
    import Image


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
        self.file = open(self.fname, "w")
        self.file.write('first_label,second_label,third_label,store_name,phone_num,address,img_path\n')

    def process_item(self, item, spider):
        # 先提取數字之後放回csv資料當中
        while True:
            if os.path.exists(item['img_path']):
                try_freq = 0
                try:
                    with Image.open(item['img_path']) as img:
                        item['phone_num'] = pytesseract.image_to_string(img)
                        remove(item['img_path'])
                except:
                    try_freq += 1
                    if try_freq < 5:
                        sleep(1)  
                        continue
                    else:
                        item['phone_num'] = item['img_path']
            break
        self.file.write(f"{item['first_label']},{item['second_label']},{item['third_label']},{item['store_name']},{item['phone_num']},{item['address']},{item['img_path']}\n")
        return item

    def close_spider(self, spider):
        self.file.close()


class ImagePipeline(ImagesPipeline):

    def get_media_requests(self, item, info):
        yield Request(item['phone_url'])

    def item_completed(self, results, item, info):
        image_paths = [x['path'] for ok, x in results if ok]
        if not image_paths:
            raise DropItem("Item contains no images")
        item['img_path'] = os.path.join(SAVE_PATH, image_paths[0])
        return item