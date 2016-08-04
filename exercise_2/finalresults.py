import sys
import psycopg2

conn = psycopg2.connect(database="tcount", user="postgres", password="pass", host="localhost", port="5432")

if len(sys.argv) > 1:
	print 'Searching for: ' + sys.argv[1]

	cur = conn.cursor()
	cur.execute("SELECT count FROM Tweetwordcount WHERE word = '" + str(sys.argv[1]) + "'")

	record = cur.fetchall()

	if record:
		print 'Total number of occurences of "' + sys.argv[1] + '": ' + str(record[0][0])
	else:
		print 'Word not in DB'
else:
	print 'Searching for all words in the stream:'

	cur = conn.cursor()
	cur.execute("SELECT word, count FROM Tweetwordcount ORDER BY word")
	
	records = cur.fetchall()

	if records:
		for rec in records:
			print rec
	else:
		"error - nothing found"



conn.close()	
