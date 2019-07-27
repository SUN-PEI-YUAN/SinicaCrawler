# coding: utf-8
from datetime import datetime
import os.path


# 資料儲存位置
SAVE_PATH = os.path.join(os.path.dirname(os.path.realpath(__file__)), 'data')

# log 格式設定
HTML_LOGFNAME = os.path.join(SAVE_PATH, f"CrawlerInfo{datetime.now().strftime('%Y%m%d%H%M%S')}.log")

PDF_LOGFNAME = os.path.join(SAVE_PATH, f"CrawlerPDFInfo{datetime.now().strftime('%Y%m%d%H%M%S')}.log")

LOG_INIT_FORMAT = '%(asctime)s,%(message)s'

LOG_FORMAT = '%s,%s,%s'

LOG_TIME_FORMAT = '%Y-%m-%d %I:%M:%S %p'

# 資料首頁連結
INDEX = 'https://serv.gcis.nat.gov.tw/moeadsBF/bms/report.jsp?method=first&agencyCode=allbf&showGcisLocation=false&showBusi=true&showFact=false'

# pdf 下載連結
PDF_LINK = 'https://serv.gcis.nat.gov.tw/moeadsBF/bms/'

# pdf 下載儲存的資料夾
PDF_SAVE_LINK = os.path.join(SAVE_PATH, '經濟部-商業登記資料查詢pdf')

# 抓取政府名稱
GOV_NAME_SELECTOR = "//select[1]/option[@selected]/text()"

# pdf 檔案名稱
URL_TEXT_SELECTOR = '//a/font[1]/text()'

# pdf 連結
PDF_LINK_SELECTOR = "//td[@class='normal' and 2]/a/@href"

# 已經下載過的清單(POST data)
POST_DATA_LOG = os.path.join(SAVE_PATH, 'crawlered')
