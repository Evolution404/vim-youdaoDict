#!/usr/bin/env python
# -*- coding:utf-8 -*-

"""
Last Change: 2015-05-22
Maintainer: iamcco <ooiss@qq.com>
Github: http://github.com/iamcco <年糕小豆汤>
Version: 1.0.1
"""

import sys
import json
import requests
import time
from common import cData, dictShow
# from dictpy.common import cData,dictShow

queryWords = sys.argv[1]
# initData = cData['info'][1:] + (urllib.quote(queryWords),)
queryUrl = 'http://fanyi.youdao.com/openapi.do?keyfrom=aioiyuuko&key=1932136763&type=data&doctype=json&version=1.1&q={}'.format(queryWords)
dataBack = requests.get(queryUrl)
print('Dictbegin')
try:
    dataJson = json.loads(dataBack.text)
    dictShow(dataJson, '1234')
except ValueError:
        print(u'==================== open api response start ========================')
        print(dataBack)
        print(u'==================== open api response end ==========================')
print('Dicteof')
