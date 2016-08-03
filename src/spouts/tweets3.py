from __future__ import absolute_import, print_function, unicode_literals

import itertools, time
import tweepy, copy 
import Queue, threading
import simplejson

from streamparse.spout import Spout

################################################################################
# Twitter credentials
################################################################################
twitter_credentials = {
	"consumer_key"		  :	 "w5NwGVgNGlNbfMEgcPVdcp3z8",
	"consumer_secret"	  :	 "XOdlPH6HJiyGvQlAM81ly8spHWEqieBtAhxvljTWzTleFCRcWg",
	"access_token"		  :	 "3807035249-xktzGi7k8UHo6yw6bJny44DGBV7Pcw3dFPLGUQ3",
	"access_token_secret" :	 "OOSWcrl6O9o1KalNFahzaYkSc6SuJAm9Ea9E9wLdT6mhr",
}

def auth_get(auth_key):
	if auth_key in twitter_credentials:
		return twitter_credentials[auth_key]
	return None

################################################################################
# Class to listen and act on the incoming tweets
################################################################################
class TweetStreamListener(tweepy.StreamListener):

	def __init__(self, listener):
		self.listener = listener
		self.startTime = time.time()
		super(self.__class__, self).__init__(listener.tweepy_api())

	def on_data(self, data):
		print('TESTSETESTSE')
		try:
			self.elapsedTime = time.time() - self.startTime
			print('test')
			if self.elapsedTime <= 30:
				self.dataJson =simplejson.loads(data[:-1])
				self.dataJsonText = self.dataJson["text"].lower()
				self.count += 1
				if self.count % 10 == 0:
					print(self.count)
				if "hello" in self.dataJsonText:
					print(self.dataJsonText)
			else:
				print("Count== ",self.count)
				print("End Time = %s"%(str(ctime())))
				print ("Elapsed Time = %s"%(str(self.elapsedTime)))
				return False

			return True

		except Exception, e:
			print('fail 1')
			# Catch any unicode errors while printing to console
			# and just ignore them to avoid breaking application.

	def on_status(self, status):
		self.listener.queue().put(status.text, timeout = 0.01)
		return True
  
	def on_error(self, status_code):
		print('fail 2')
		return True # keep stream alive
  
	def on_limit(self, track):
		return True # keep stream alive

class Tweets(Spout):

	def initialize(self, stormconf, context):
		self._queue = Queue.Queue(maxsize = 100)

		consumer_key = auth_get("consumer_key") 
		consumer_secret = auth_get("consumer_secret") 
		auth = tweepy.OAuthHandler(consumer_key, consumer_secret)

		if auth_get("access_token") and auth_get("access_token_secret"):
			access_token = auth_get("access_token")
			access_token_secret = auth_get("access_token_secret")
			auth.set_access_token(access_token, access_token_secret)

		self._tweepy_api = tweepy.API(auth)

		# Create the listener for twitter stream
		print('creating listener-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------')
		listener = TweetStreamListener(self)

		# Create the stream and listen for english tweets
		self.stream = tweepy.Stream(auth, listener, timeout=None)
		self.stream.filter(languages=["en"], track=["a", "the", "i", "you", "u"], async=True)

	def queue(self):
		return self._queue

	def tweepy_api(self):
		return self._tweepy_api

	def next_tuple(self):
		try:
			self.queue().put(self.stream)
			tweet = self.queue().get(timeout = 0.1) 
			if tweet:
				self.queue().task_done()
				self.emit([tweet])
 
		except Queue.Empty:
			self.log("Empty queue exception ")
			time.sleep(0.1) 

	def ack(self, tup_id):
		pass  # if a tuple is processed properly, do nothing

	def fail(self, tup_id):
		pass  # if a tuple fails to process, do nothing
