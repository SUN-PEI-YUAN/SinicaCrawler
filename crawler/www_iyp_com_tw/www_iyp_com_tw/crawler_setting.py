# coding: utf-8
from datetime import datetime
import os.path


# 資料儲存位置
SAVE_PATH = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'data')

# log 格式設定
HTML_LOGFNAME = os.path.join(SAVE_PATH, f"CrawlerInfo{datetime.now().strftime('%Y%m%d%H%M%S')}.log")

LOG_INIT_FORMAT = '%(asctime)s,%(message)s'

LOG_FORMAT = '%s,%s'

LOG_TIME_FORMAT = '%Y-%m-%d %I:%M:%S %p'

# 資料首頁連結
INDEX = 'https://www.iyp.com.tw'

# 資料名稱
DATA_FNAME = os.path.join(SAVE_PATH, f"中華黃頁_{datetime.now().strftime('%Y%m%d%H%M%S')}.csv")
