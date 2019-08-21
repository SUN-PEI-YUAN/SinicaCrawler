pdf.list1 <- list.files(DATA_PATH, full.names = TRUE, pattern = '登記清冊.pdf$')
pdf.list2 <- list.files(DATA_PATH, full.names = TRUE, pattern = '項目清冊.pdf$')
creates <- list.files(DATA_PATH, full.names = TRUE, pattern = '.設立.+項目清冊.pdf$')
replaces <- list.files(DATA_PATH, full.names = TRUE, pattern = '.變更.+項目清冊.pdf$')
deletes <- list.files(DATA_PATH, full.names = TRUE, pattern = '.解散.+項目清冊.pdf$')


DATA_PATH <- '../data/經濟部-商業登記資料查詢pdf/'

SAVE_PATH <- '../data/經濟部-商業登記資料查詢pdf(封存)/'

OUTPUT_DATA <- './經濟部-商業登記資料查詢json/'

dir.create(SAVE_PATH)
file.copy(from = pdf.list1, to = makePath(filepath = pdf.list1, newPath = SAVE_PATH), )
file.remove(pdf.list1)


testing_file2 <- '/Users/marksun/Desktop/台中市政府108年03月商業解散登記營業項目清冊.pdf'
 aaaa= dumpText(testing_file2)


testing_file1 <- file.path(DATA_PATH,  '台中市政府108年03月商業解散登記營業項目清冊.pdf')
aaa = dumpText(testing_file1)


testing_file3 <- file.path(DATA_PATH,  '高雄市政府105年11月商業設立登記營業項目清冊.pdf')
json_dump(testing_file3)





testing_file1 <- file.path(DATA_PATH,  '台中市政府108年03月商業解散登記營業項目清冊.pdf')
dumpText(testing_file2)







for (i in creates) {
  dumpText(i)  
}

testing_file1 <- file.path(DATA_PATH,  '台中市政府108年03月商業解散登記營業項目清冊.pdf')

testing_file2 <- '/Users/marksun/Desktop/台中市政府108年03月商業解散登記營業項目清冊.pdf'




# run run run XDDDDDD

library(parallel)
cl <- makeCluster(detectCores())
clusterExport(cl, c('is.GenericNo', 'is.goverment', 'is.address', 'is.dateformat', 'is.ServicesNo', 'is.chinese', 'rm.chinese'))

starttime <- Sys.time()
creates.result <- parLapply(cl, creates, dumpText)
replaces.result <- parLapply(cl, replaces, dumpText)
deletes.result <- parLapply(cl, deletes, dumpText)
endtime <-  Sys.time() - starttime