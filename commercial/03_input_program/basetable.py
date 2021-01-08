# -*- coding: utf-8 -*-
"""
Created on Wed Sep 30 15:43:43 2020

@author: hardadi
"""

import psycopg2

db = "dmar_entwicklung"
user = "postgres"
password = "Jazz1991"
host = "localhost"
port = 5432

pg_engine = "dbname='{}' user='{}' password='{}' host='{}' port='{}'".format(db, user, password, host, port)

conn = psycopg2.connect(pg_engine)
cur = conn.cursor()