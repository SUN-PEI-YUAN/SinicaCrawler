#coding: utf-8
import logging

class Log(object):
    '''日誌格式'''

    def __init__(self, logger_name, log_fname, init_format, log_format, datefmt, log_level=logging.INFO):
        '''Log init setting'''
        self.logger_name = logger_name
        self.log_fname = log_fname
        self.init_format = init_format
        self.log_format = log_format
        self.datefmt = datefmt
        self.log_level = log_level
        self._log = logging.getLogger(self.logger_name)
        self.setupLogger()
        self._init()

    def _init(self) -> None:
        '''Logger header'''
        if self.logger_name == 'html':
            with open(self.log_fname, 'w') as f:
                f.write('time,goverment,year,httpstatus\n')
        if self.logger_name == 'pdf':
            with open(self.log_fname, 'w') as f:
                f.write('time,filename,url,httpstatus\n')

    def setupLogger(self) -> None:
        '''Log init setting function'''
        formatter = logging.Formatter(self.init_format, datefmt=self.datefmt)
        fileHandler = logging.FileHandler(self.log_fname, mode='a')
        fileHandler.setFormatter(formatter)
        streamHandler = logging.StreamHandler()
        streamHandler.setFormatter(formatter)
        self._log.setLevel(self.log_level)
        self._log.addHandler(fileHandler)
        self._log.addHandler(streamHandler)

    def logger(self, *msg, level) -> None:
        '''Save log interface'''
        if level == 'info':
            self._log.info(self.log_format, *msg)
        if level == 'warning':
            self._log.warning(self.log_format, *msg)