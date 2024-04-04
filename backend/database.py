import sqlite3

# Connect to the database
conn = sqlite3.connect('database.db')
cursor = conn.cursor()

cursor.execute('''
  CREATE TABLE users (
               uid INTEGER PRIMARY KEY AUTOINCREMENT,
               name TEXT NOT NULL,
               email TEXT UNIQUE NOT NULL,
               bio TEXT,
               rating REAL,
               isOnline BOOLEAN,
               image TEXT
  );
''')

cursor.execute('''
  CREATE TABLE classes (
               cid INTEGER PRIMARY KEY AUTOINCREMENT,
               className TEXT UNIQUE NOT NULL
  );
''')

cursor.execute('''
  CREATE TABLE reviews (
               uid INTEGER NOT NULL,
               review TEXT,
               FOREIGN KEY (uid) REFERENCES users(uid),
               PRIMARY KEY (uid, review)
  );
''')



cursor.execute('''
  CREATE TABLE tutor_classes (
               uid INTEGER NOT NULL,
               cid INTEGER NOT NULL,
               price REAL NOT NULL,
               FOREIGN KEY (uid) REFERENCES users(uid),
               FOREIGN KEY (cid) REFERENCES classes(cid),
               PRIMARY KEY (uid, cid)
  );
''')

conn.commit()
conn.close()