load_tweets = LOAD '$InputCsvData' USING PigStorage(',');

extract_details = FOREACH load_tweets GENERATE $0 as id,$1 as text;

tokens = foreach extract_details generate id,text, FLATTEN(TOKENIZE(text)) As word;

dictionary = load '$Dictionary' using PigStorage('\t') AS(word:chararray,rating:int);

word_rating = join tokens by word, dictionary by word;

rating = foreach word_rating generate tokens::id as id, dictionary::rating as rate;

word_group = group rating by id;

avg_rate = foreach word_group generate group as id, AVG(rating.rate) as tweet_rating;

store avg_rate into '$PigOutputLoc' using PigStorage(',');

