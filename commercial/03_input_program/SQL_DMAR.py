# -*- coding: utf-8 -*-
"""
Created on Mon Mar 29 15:51:09 2021

@author: hardadi
"""

class SQL_DMAR:
    def __init__(self):
        pass
    def select(database):
        return "SELECT FROM {};".format(database)
    def insert(database, columns, values):
        return "INSERT INTO {} ({}) VALUES ({});".format(database, columns, values)
    def update(database, columns_update, values_update,
        columns, values):
        state = """UPDATE {} SET {} = {}
        WHERE {} = {};""".format(database, columns_update, values_update,
        columns, values)
        return state