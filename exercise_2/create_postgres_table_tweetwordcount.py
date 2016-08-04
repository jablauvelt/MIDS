### Create table

import psycopg2

# Connect to database
conn = psycopg2.connect(database="tcount", user="postgres", password="pass", host="localhost", port="5432")


#Create table Tweetwordcount
cur = conn.cursor()
cur.execute('DROP TABLE Tweetwordcount;')
cur.execute('CREATE TABLE Tweetwordcount (word TEXT PRIMARY KEY NOT NULL, count INT NOT NULL);')
conn.commit()
conn.close()
