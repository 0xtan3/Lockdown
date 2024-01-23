import sqlite3

def dump_sql(db_file,dump_file):
    conn = sqlite3.connect(db_file)
