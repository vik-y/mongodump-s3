#!/usr/bin/env python

import os
import pymongo

uri = os.environ['MONGO_URI']
data = pymongo.uri_parser.parse_uri(uri)

if os.environ.get('MONGO_COMPLETE') is None:
    dbname = '-d %s' % data['database']
else:
    dbname = ''
options = '%s %s' % (dbname, uri)

print(options)
