import sys
import psycopg2

if len(sys.argv) <3:
	print 'Need two arguments'
	sys.exit()

conn = psycopg2.connect(database="tcount", user="postgres", password="pass", host="localhost", port="5432")

cur = conn.cursor()

cur.execute("SELECT word, count FROM Tweetwordcount WHERE count BETWEEN " + sys.argv[1] + " AND " + sys.argv[2])

records = cur.fetchall()

if records:
	for rec in records:
		print rec
else:
	print 'No records match this criteria.'

conn.close()
