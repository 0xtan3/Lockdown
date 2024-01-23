import sqlite3

def dump_sql(db_file,dump_file):
    conn = sqlite3.connect(db_file)
    with open(dump_file, 'w') as f:
        for line in conn.iterdump():
            f.write('%s\n' % line)
    conn.close()
