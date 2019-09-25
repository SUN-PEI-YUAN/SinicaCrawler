DATA_PATH <- '../data/經濟部-商業登記資料查詢pdf/'

SAVE_PATH <- '../data/經濟部-商業登記資料查詢pdf(封存)/'

OUTPUT_DATA <- './經濟部-商業登記資料查詢json/'


. <- list.files(DATA_PATH, full.names = TRUE, pattern = '.登記清冊.pdf$')

dir.create(SAVE_PATH)

file.copy(from = ., to = makePath(filepath = ., newPath = SAVE_PATH))

file.remove(.)

library(parallel)

cl <- makeCluster(detectCores())

clusterExport(cl, c('is.GenericNo', 'is.goverment', 'is.address', 'is.dateformat', 'is.ServicesNo', 'is.chinese', 'rm.chinese', 'checkSum1', 'makePath', '.listToJson', 'dumpText'))

starttime <- Sys.time()

. <- list.files(DATA_PATH, full.names = TRUE, pattern = '^台北市')

parLapply(cl, ., json_dump)

endtime <-  Sys.time() - starttime