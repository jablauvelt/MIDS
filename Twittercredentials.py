import tweepy

consumer_key = "w5NwGVgNGlNbfMEgcPVdcp3z8";
#eg: consumer_key = "YisfFjiodKtojtUvW4MSEcPm";


consumer_secret = "XOdlPH6HJiyGvQlAM81ly8spHWEqieBtAhxvljTWzTleFCRcWg";
#eg: consumer_secret = "YisfFjiodKtojtUvW4MSEcPmYisfFjiodKtojtUvW4MSEcPmYisfFjiodKtojtUvW4MSEcPm";

access_token = "3807035249-xktzGi7k8UHo6yw6bJny44DGBV7Pcw3dFPLGUQ3";
#eg: access_token = "YisfFjiodKtojtUvW4MSEcPmYisfFjiodKtojtUvW4MSEcPmYisfFjiodKtojtUvW4MSEcPm";

access_token_secret = "OOSWcrl6O9o1KalNFahzaYkSc6SuJAm9Ea9E9wLdT6mhr";
#eg: access_token_secret = "YisfFjiodKtojtUvW4MSEcPmYisfFjiodKtojtUvW4MSEcPmYisfFjiodKtojtUvW4MSEcPm";


auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)

api = tweepy.API(auth)



