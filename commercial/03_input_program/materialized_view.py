# -*- coding: utf-8 -*-
"""
Created on Fri Mar 19 12:48:16 2021

@author: hardadi
"""

class MaterializedView:
    def __init__(self, le_index):
        self.sql_statement = """DELETE FROM com_new_final.single_bio;
        
        INSERT INTO com_new_final.single_bio
        (bi_index, le_index, fish_id, parameter, value, unit, comments)
        SELECT * FROM com_new_final.sample_bio WHERE le_index = {};
        
        REFRESH MATERIALIZED VIEW com_new_final.bio_transposed;
        
        SELECT * FROM com_new_final.bio_transposed;""".format(le_index)
        
    def sql(self):
        return self.sql_statement
        
# a = MaterializedView(1)

# print(a.sql())