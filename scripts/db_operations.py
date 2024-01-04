# db_operations.py

import sqlite3

DB_FILE = "keys.db"

def create_table():
    conn = sqlite3.connect(DB_FILE)
    cursor = conn.cursor()

    # Create a table if it dosen't exist
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS keys (
            id INTEGER PRIMARY KEY,
            key TEXT
        );
    ''')

    conn.commit()
    conn.close()

def add_key(key):
    conn = sqlite3.connect(DB_FILE)
    cursor = conn.cursor()

    # Insert the key into the keys table
    cursor.execute("INSERT INTO keys (key) VALUES (?)", (key,)) #single element tuple

    conn.commit()
    conn.close()

def get_latest_key():
    conn = sqlite3.connect(DB_FILE)
    cursor = conn.cursor()

    # Retrieve the latest key from the keys table
    cursor.execute("SELECT key FROM keys ORDER BY id DESC LIMIT 1")
    latest_key = cursor.fetchone()

    conn.close()

    return latest_key[0] if latest_key else None
