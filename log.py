# -*- coding: utf-8 -*-
"""
Created on Mon Nov 16 12:16:33 2020

@author: hardadi
"""
import psycopg2 as pg

# login_info = ['dmar_entwicklung', 'hardadi', 'Jazz1991',
#               'dmar01-hro.thuenen.de', 5432]

login_info = ['dmar_entwicklung', 'postgres', 'Jazz1991',
              'localhost', 5432]

def login(login_info=['dmar_entwicklung', 'hardadi', 'Jazz1991',
                      'dmar01-hro.thuenen.de', 5432]):
    connect = pg.connect(dbname=login_info[0], user=login_info[1], password=login_info[2],
                     host=login_info[3], port=login_info[4])
    #cursors = connect.cursor()
    return connect
