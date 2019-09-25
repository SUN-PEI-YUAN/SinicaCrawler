#! /usr/bin/R

# ----------------------------------------------------------------------
#
# Dependence library: 'pdftools', 'jsonlite', 'readxl', 'sqldf', 'xml2'
#
# ----------------------------------------------------------------------

# ----------------------------------------------------------------------
#
# 下載營業項目說明清單
#   參考連結: https://gcis.nat.gov.tw/cod/index.jsp
# download.file(url = 'https://gcis.nat.gov.tw/cod/v7_ref_v8.xls', destfile = 'comlevel.xls')
# . <- data.frame(readxl::read_excel('comlevel.xls'))
# colnames(.) <- c('V7', 'V7_result', 'V8', 'V8_result')
# comp.levels <- unique(unlist(.[, c('V7_result', 'V8_result')]))
# comp.levels <- comp.levels[!is.na(comp.levels)]
#
# ----------------------------------------------------------------------

is.GenericNo <- function(x, ...) {
  # 檢測x向量是否為統一編號
  #
  # Args:
  #   x: 字串向量
  #
  # Returns:
  #   logical
  cond <- '[0-9]{8}'
  return(grepl(pattern = cond, x = x, ...))
}

is.goverment <- function(x, ...) {
  # 檢測x向量是否為政府名稱
  #
  # Args:
  #   x: 字串向量
  #
  # Returns:
  #   logical
  cond1 <- '[基隆|新竹|台中|雲林|台南|屏東|台東|金門|彰化|新北|台北|新竹|臺中|嘉義|臺南|宜蘭|臺東|連江|[新北|台北|新竹|臺中|嘉義|臺南|宜蘭|臺東|連江|臺北|苗栗|南投|嘉義|高雄|花蓮|澎湖|桃園][縣|市]政府'
  cond2 <- '臺北市商業處'
  # gov.name <- c(
  #   "基隆市政府", "新北市政府", "臺北縣政府", 
  #   "台北縣政府", "台北巿政府", "臺北巿政府", 
  #   "新竹縣政府", "新竹市政府", "苗栗縣政府", 
  #   "台中市政府", "臺中市政府", "南投縣政府",
  #   "雲林縣政府", "嘉義縣政府", "嘉義市政府",
  #   "台南市政府", "臺南市政府", "高雄市政府", 
  #   "屏東縣政府", "宜蘭縣政府", "花蓮縣政府", 
  #   "台東縣政府", "臺東縣政府", "澎湖縣政府", 
  #   "金門縣政府", "連江縣政府", "桃園市政府", 
  #   "彰化縣政府"
  # )
  # return(x %in% gov.name)
  return(grepl(pattern = cond1, x = x) | grepl(pattern = cond2, x = x))
}

is.address <- function(x, simpleCheck = FALSE, custom = NULL, use.place = FALSE, ...) {
  # 檢測x向量是否為地址
  #
  # Args:
  #   x: 字串向量
  #
  # Returns:
  #   logical
  .setRange <- function(s, ...)
    sprintf(s, ...)
  
  if (simpleCheck)
  {
    cond <- '[縣|市|鄉|鎮|市|區|路|街|村|里|巷|弄|號|之|樓|室]'
  }
  else if (use.place)
  {
    # cond <- c(
    #   "基隆市", "新北市", "臺北縣", 
    #   "台北縣", "台北巿", "臺北巿", 
    #   "新竹縣", "新竹市", "苗栗縣", 
    #   "台中市", "臺中市", "南投縣",
    #   "雲林縣", "嘉義縣", "嘉義市",
    #   "台南市", "臺南市", "高雄巿", 
    #   "屏東縣", "宜蘭縣", "花蓮縣", 
    #   "台東縣", "臺東縣", "澎湖縣", 
    #   "金門縣", "連江縣", "桃園市", 
    #   "彰化縣"
    # )
    cond <- '[基隆|新竹|台中|雲林|台南|屏東|台東|金門|彰化|新北|台北|新竹|臺中|嘉義|臺南|宜蘭|臺東|連江|[新北|台北|新竹|臺中|嘉義|臺南|宜蘭|臺東|連江|臺北|苗栗|南投|嘉義|高雄|花蓮|澎湖|桃園][縣|市]'
    # cond <- paste(cond, collapse = '|')
  }
  else if (!is.null(custom))
  {
    cond <- custom
  }
  else
  {
    
    
    numFrame <- '[0-9|０|１|２|３|４|５|６|７|８|９|一|二|三|四|五|六|七|八|九|壹|貳|參|肆|伍|陸|柒|捌|玖]{%s,%s}'
    addressFrame <- '[縣|市|鄉|鎮|市|區|路|街|村|里|巷|弄|號|之|樓|室]{%s,%s}'
    
    num_rule <- .setRange(numFrame, 1, 4)
    addr_rule <- .setRange(addressFrame, 1, '')
    
    rule1 <- paste0(addr_rule, num_rule)
    rule2 <- paste0(num_rule, addr_rule)
    
    return(grepl(pattern = rule1, x = x) | grepl(pattern = rule2, x = x))
    
  }
  return(grepl(pattern = cond, x = x, ...))
}

is.dateformat <- function(x, ...) {
  # 檢測x向量是否為日期
  #
  # Args:
  #   x: 字串向量
  #
  # Returns:
  #   logical
  cond <- '[0-9]{2,3}/[0-9]{2}/[0-9]{2}'
  return(grepl(pattern = cond, x = x, ...))
}

is.ServicesNo <- function(x, ...) {
  # 檢測x向量是否為營業項目
  #
  # Args:
  #   x: 字串向量
  #
  # Returns:
  #   logical
  cond <- '[A-Z+][A-Z0-9]{6}'
  return(grepl(pattern = cond, x = x, ...))
}

is.chinese <- function(x, ...) {
  # 移除x中含有的中文
  #
  # Args:
  #   x: 字串向量
  #
  # Returns:
  #   logical
  cond <- '[\u4e00-\u9fa5]{1,}'
  return(grepl(pattern = cond, x = x, ...))
}

rm.chinese <- function(x, ...) {
  # 移除x中含有的中文
  #
  # Args:
  #   x: 字串向量
  #
  # Returns:
  #   logical
  cond <- '[\u4e00-\u9fa5]{1,}'
  return(gsub(pattern = cond, replacement = '', x = x, ...))
}

makePath <- function(filepath, currentFile=NULL, ReplaceFile=NULL, newPath=NULL) {
  # 操作檔案路徑，如果只有filepath參數，則回傳檔案名稱，
  # 如果currentFile和ReplaceFile存在，則會修改檔案副名檔名(可運用在檔案輸出)，
  # newPath存在，則會合併newpath路徑和檔案名稱
  #
  # Args:
  #   filepath: 檔案位置
  #   currentFile: 要修改的副檔案
  #   ReplaceFile: 修改的副檔案
  #   newPath: 要添加的新路徑
  # Returns:
  #   character
  filename <- basename(filepath)

  if (is.null(newPath))
  {
    newPath <- '.'
  }
  
  else if (!is.null(newPath))
  {
    if (!dir.exists(newPath)) 
    {
      dir.create(newPath)
    }  
  }

  if (!is.null(currentFile) & !is.null(ReplaceFile))
  {
    filename <- gsub(currentFile, ReplaceFile, filename)
  }

  filename <- file.path(newPath, filename)
  return(filename)
}

strsplit2 <- function(x, split, type = "remove", perl = FALSE, ...) {
  # strsplit 進化版
  #
  if (type == "remove")
  {
    out <- base::strsplit(x = x, split = split, perl = perl, ...)
  }
  else if (type == "before")
  {
    # split before the delimiter and keep it
    out <- base::strsplit(x = x, split = paste0("(?<=.)(?=", split, ")"), perl = TRUE, ...)
  }
  else if (type == "after")
  {
    # split after the delimiter and keep it
    out <- base::strsplit(x = x, split = paste0("(?<=", split, ")"), perl = TRUE, ...)
  }
  else
  {
    # wrong type input
    stop("type must be remove, after or before!")
  }
  return(out)
}

checkSum1 <- function(x) {
  # 檢查是否為政府名稱，統一編號，序號
  #
  # Args:
  #   fun: 執行的程式碼
  #
  # Returns:
  #   NULL
  cond <- is.goverment(x) |    # 是否為政府名稱
    is.GenericNo(x) |          # 是否為統一編號
    grepl('^[0-9]*$', x)       # 是否為序號
  return(cond)
}

.listToJson <- function(x) {
  # 將list資料轉成json格式
  #
  # Args:
  #   x: 資料
  #
  # Returns:
  #   json 字串
  li <- list()
  li$id <- x[1]
  li$unique_label <- x[2]
  li$gov_name <- x[3]
  li$store_name <- x[4]
  li$admin <- x[5]
  li$address <- x[6]
  li$assets <- x[7]
  li$create_date <- x[8]
  if (length(x) >= 9)
  {
    li$labels <- x[9:length(x)]  
  } else {
    li$labels <- 'NULL'
  }
  return(li)
}

dumpText <- function(pdfpath, delectHeader = c(-1, -2, -3), errorLogPath='pdfError.log', ...) {
  # 將pdf檔轉換成文字
  #
  # Args:
  #   pdfpath: pdf檔案路徑
  #   delectHeader: 刪除pdf頭部，預設1:3行
  #   errorLogPath: error.log放置處，預設在R的目前位置(getwd())
  #
  # Returns:
  #   list，如果pdf輸出有失敗的部分為輸出log檔

  pdftext <- pdftools::pdf_text(pdf = pdfpath)
  pdftext <- strsplit(pdftext, split = '\n')
  pdftext <- lapply(pdftext, function(x) x[delectHeader])
  pdftext <- unlist(pdftext)

  # 確認pdf是否為空白頁或是沒資料
  if (identical(pdftext, character(0)))
  {
    return(NA)
  }
  else if (length(pdftext) == 1 & length(strsplit(pdftext, ' ')) < 2)
  {
    return(NA)
  }
  else
  {
    # 日期資料
    date_finder <- grepl(pattern = '[0-9]{2,3}/[0-9]{2}/[0-9]{2}', x = pdftext)
    mainData <- which(date_finder)

    # 其他資料
    other_data <- !grepl(pattern = '[0-9]{2,3}/[0-9]{2}/[0-9]{2}', x = pdftext) & !grepl(pattern = '[0-9]{8}', x = pdftext)
    subData <- which(other_data)

    # 切割其他資料，準備合併到主資料
    splitSubData <- split(subData, cut(subData, c(mainData, max(subData))))

    # 合併
    dt <- cbind(pdftext[mainData], splitSubData)

    dt <- apply(dt, 1, function(x) {
      x <- c(x[[1]], pdftext[x[[2]]])
      paste(x, collapse = ' ')
    })

    names(dt) <- NULL
    dt <- as.list(dt)
    # browser()
    result <- tryCatch({
      lapply(dt, function(x) {
        
        # browser()
        
        x <- unlist(strsplit(x, '\\s+'))
        x <- x[x != '']
    
        # 時間字串位置
        whichTime <- which(is.dateformat(x))
        
        # 資本額位置
        whichMoney <- whichTime - 1
        
        # 政府名稱位置
        whichGov <- which(is.goverment(x[1:whichMoney]))
        
        # 商業名稱位置
        whichName <- whichGov + 1
        
        # 統一編號位置
        whichEncode <- whichGov - 1
        
        # 序號位置
        whichNo <- whichEncode - 1
        
        # 主要地址位置，有其他未合併的地址
        addressCheck <- is.address(x = x[whichName:whichMoney], use.place = TRUE) & !checkSum1(x[whichName:whichMoney])
        whichMainAddress <- min(which(addressCheck)) + whichGov
        
        # 確認負責人名字是否完整
        adminCheck <- whichMainAddress - whichName
        
        # 合併地址
        # 處理方式為以主要地址為準，依序處理
        for (string in 1:length(x))
        {
          
          # ----------------------------------------------------------------------
          
          # 向量位置小於五之處理方式(地址以前)
          
          if (string <= whichMainAddress)
          {
            
            check <- string %in% c(whichNo, whichEncode, whichGov, whichName)
            
            if (check) 
              next
            
            else 
            {
              # 抓出負責人名稱，如果分裂則合併
              if (string < whichMainAddress)
              {
                if (adminCheck == 2 | string == whichName + 1)
                  next
                else 
                {
                  x[whichName + 1] <- paste(x[whichName + 1], x[string], collapse = '', sep = '')
                  x[string] <- ''
                  next
                }
              }
            

              # 檢查地址
              if (string == whichMainAddress)
              {
                cond_1 <- grepl( '，', x[string])

                # 檢查地址是否分裂
                if (cond_1)
                {
                  tmp <- unlist(strsplit(x[string], '，'))
                  tmp <- ifelse(is.address(tmp), tmp, NA)
                  tmp <- tmp[!is.na(tmp)]
                  x[whichMainAddress] <- paste(tmp, collapse = '', sep = '')
                  next
                }
                
                else if (string + 1 == whichMoney | x[string] == '' | string == whichMainAddress) 
                  next
                
                else 
                {
                  x[whichMainAddress] <- paste(x[whichMainAddress], x[string], collapse = '', sep = '')
                  next
                }
                
              }
              
            }
            
          }
            
          # ----------------------------------------------------------------------

          if (string > whichMainAddress)
          {
            # 如果是主要地址或是時間
            check <- string %in% c(whichMoney, whichTime)
          
            if (check) 
              next
            
            else
            {
              # 數字存在位置: 最左邊
              numLocation_1 <- grepl('^[0-9|０|１|２|３|４|５|６|７|８|９]{1,4}.', x[string])
              
              # 數字存在位置: 中間
              numLocation_2 <- grepl('.[0-9|０|１|２|３|４|５|６|７|８|９]{1,3}.', x[string])
                
              # 數字存在位置: 最右邊
              numLocation_3 <- grepl('.[0-9|０|１|２|３|４|５|６|７|８|９]{1,4}$', x[string])  


              # 遇到營業項目說明之處理機制: 組合營業項目說明
              cond_1 <- is.ServicesNo(x[string])
              
              # 是全型或半型數字
              cond_2 <- grepl('^[0-9|０|１|２|３|４|５|６|７|８|９]{1,4}', x[string])
              
              # 主要地址後面是否有之
              cond_3 <- grepl('之$', x[whichMainAddress])
              
              # 是否為地址
              cond_4 <- is.address(x[string])
              
              # 是否為數字
              cond_5 <- grepl('[0-9|０|１|２|３|４|５|６|７|８|９]{1,4}', x[string])
              
              # 簡單對字串做地址判斷
              cond_6 <- is.address(x[string], simpleCheck = T) & nchar(x[string]) <= 3
              
              # 資本額與日期
              if (cond_1) 
                next
              
              else if (numLocation_1)
              {
                # 開頭是之
                if (cond_3 | cond_4)
                {
                  x[whichMainAddress] <- paste(x[whichMainAddress], x[string], collapse = '', sep = '')
                  x[string] <- ''
                  next
                }
              }
              
              else if (numLocation_2) 
              {
                if (cond_4) {
                  x[whichMainAddress] <- paste(x[whichMainAddress], x[string], collapse = '', sep = '')
                  x[string] <- ''
                  next
                }
                
                else
                {
                  x[string] <- ''
                  next
                }
                
              }
              
              else if (numLocation_3)
              {
                if (cond_4)
                {
                  x[whichMainAddress] <-paste(x[whichMainAddress], x[string], collapse = '', sep = '')
                  x[string] <- ''
                  next
                }
              }
              
              # 其他處理方式
              else
              {
                if (cond_3 & cond_5)
                {
                  x[whichMainAddress] <- paste(x[whichMainAddress], x[string], collapse = '', sep = '')
                  x[string] <- ''
                  next
                }
                
                else if (cond_6)
                {
                  x[whichMainAddress] <- paste(x[whichMainAddress], x[string], collapse = '', sep = '')
                  x[string] <- ''
                  next
                }
                
                # 針對新北市pdf處理
                else if (x[string] == '局')
                {
                  x[whichGov] <- paste(x[whichGov], x[string], collapse = '', sep = '')
                  x[string] <- ''
                  next
                }
                
                else
                {
                  x[string] <- ''
                  next
                }
                
              }
              
            }
          
          }
          # ----------------------------------------------------------------------
        }

        x <- x[x != '']
        # print(x)
        # browser()
        
        ### 將擋案輸出至指定位置，並移除原先位置的檔案 ###
        
        o <- makePath(pdfpath, newPath = '../data/經濟部-商業登記資料查詢pdf(完成)/')
        file.copy(pdfpath, o)
        file.remove(pdfpath)
        
        return(x)        
      })

    }, error = function(e) {
      ### 輸出 error.log ###
      
      # 如果格式為登記清冊
      # result <- tryCatch()
      
      
      
      
      errorLogPath <- file(description = errorLogPath, open = 'a', encoding = 'UTF-8')
      
      errorMsg <- sprintf("[%s] PDF: %s | status: %s", Sys.time(), pdfpath, e)
      # write(errorMsg, file = errorLogPath, append = TRUE)
      writeLines(errorMsg, con = errorLogPath, useBytes = TRUE, sep = '')
      close(errorLogPath)
      ### 輸出 error.log ###
      
      ### 將擋案輸出至指定位置，並移除原先位置的檔案 ###
      
      # o <- makePath(pdfpath, newPath = '../data/經濟部-商業登記資料查詢pdf(失敗)/')
      # file.copy(pdfpath, o)
      # file.remove(pdfpath)
      
    })
    
    return(result)
    
  }
}

json_dump <- function(i, o = NULL, outdir = './經濟部-商業登記資料查詢json/') {
  # 將dumpText function回傳之內容轉換成json
  #
  # Args:
  #   i: 檔案路徑
  #   o: 輸出路徑
  #
  # Returns:
  #   logical
  if (is.null(o))
  {
    ofile <- makePath(filepath = i, currentFile = 'pdf', ReplaceFile = 'json', newPath = outdir)
  }
  else 
  {
    ofile <- o
  }
    
  dt <- dumpText(i)
  
  jsontext <- jsonlite::toJSON(lapply(dt, .listToJson), auto_unbox = TRUE)
  
  writeLines(jsontext, ofile, useBytes=TRUE)
}
