import sys
import psycopg2
import matplotlib.pyplot as plt

if len(sys.argv) == 2:
	topx = sys.argv[1]
else:
	topx = 20

conn = psycopg2.connect(database="tcount", user="postgres", password="pass", host="localhost", port="5432")

cur = conn.cursor()

cur.execute("SELECT word, count FROM Tweetwordcount ORDER BY COUNT DESC LIMIT " + str(topx))

records = cur.fetchall()

if records:
	records = np.array(records)
	
	plt.Figure()
	plt.barh(range(20), records[:,1].astype(np.int))
	plt.yticks(range(20), records[:,0])
	plt.xlabel('Number of Occurences')
	plt.ylabel('Word')
	plt.title('Top ' + str(len(records)) + ' Words')
	plt.savefig("Plot.png")

else:
	print 'No records match this criteria.'
