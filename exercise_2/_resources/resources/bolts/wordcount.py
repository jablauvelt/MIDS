from __future__ import absolute_import, print_function, unicode_literals

from collections import Counter
from streamparse.bolt import Bolt
from redis import StrictRedis
import psycopg2

class WordCounter(Bolt):

    def initialize(self, conf, ctx):
        self.counts = Counter()
        self.redis = StrictRedis()
	self.conn = psycopg2.connect(database="tcount", user="postgres", password="pass", host="localhost", port="5432")
	self.cur = self.conn.cursor()

    def process(self, tup):
        word = tup.values[0]

        # Increment the local count
        self.counts[word] += 1
        self.emit([word, self.counts[word]])

        # Log the count - just to see the topology running
        self.log('%s: %d' % (word, self.counts[word]))
	
	# Check if the word already exists in the table
	self.cur.execute("SELECT word from Tweetwordcount WHERE word='" + word + "'")
	records = self.cur.fetchall()

	# If the word doesn't exist, add it. Otherwise, update the count
	if not records:
		self.log("inserting")
		self.cur.execute("INSERT INTO Tweetwordcount (word, count) VALUES ('" + word + "'," + str(self.counts[word])+ ')')
		self.conn.commit()
	else:
		self.log("updating")
		self.cur.execute("UPDATE Tweetwordcount SET count=" + str(self.counts[word]) + " WHERE word='" + word + "'")
		self.conn.commit()

