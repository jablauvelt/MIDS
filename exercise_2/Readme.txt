To run the application:

1. Navigate to exercise_2 (you should already be in this folder)
2. If you haven't set up postgres yet, run "setup_postgres.sh"
	a. Run "psql -U postgres"
	b. Run "CREATE DATABASE tcount;"
	c. \c tcount to make sure it worked
	d. \dt to show that it is empty
	e. \q to quit
3. Run "create_postgres_table_tweetwordcount.py" to create the table that the 
   tweets will be put into.
4. Run "sparse run" to activate the Storm / streamparse topology, which will
   look for tweets containing the word "surf", split the tweets by word,
   and then add/update the counts in the postgres database "Tcount", table
   "tweetwordcount".
   a. Press CTRL+C to stop that process once you have gotten enough tweets.
5. Analyze results:
   a. To obtain the total number of occurences for a specific word, run
	"python finalresults.py test_word", where test_word is the word you
	want to see the counts for.
   b. To see a list of the counts for all words, run "python finalresults.py"
	with no arguments specified.
   c. To see a list of words with occurence counts in a certain range, run
	"python histogram.py 5 10" where 5 and 10 represent the minimum
	and maximum counts allowed (inclusive).

