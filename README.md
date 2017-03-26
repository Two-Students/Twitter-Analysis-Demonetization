Seeking Public Sentiments on "Demonetization" by Analyzing Twitter Data 
===================

This repository contains an application for analyzing Twitter data using [Hadoop](http://hadoop.apache.org), [Flume](http://flume.apache.org), [Pig](http://pig.apache.org) and MS-Excel.

Getting Started
---------------


**Install Hadoop ,Pig and Flume**

 Before you get started with the actual application, you'll need Hadoop, Flume and Pig. The easiest way to get them is to use Cloudera Quickstart VM to set up your initial environment. You can download [Cloudera Quickstart VM](https://www.cloudera.com/downloads/quickstart_vms.html) here or you can manually set them all up.

  
Configuring Flume
------------------


**Download the custom Flume Source and add the JAR file to the Flume classpath**

Copy `flume-sources-1.0-SNAPSHOT.jar` to `/usr/lib/flume-ng/plugins.d/twitter-streaming/lib/flume-sources-1.0-SNAPSHOT.jar`


**Configure flume.conf file**

    Go to /usr/lib/flume-ng/plugins.d/twitter-streaming/bin/flume.conf.
    
    Edit the flume.conf file and set parameters in accordance with the Twitter Agent.
    
    Provide the correct Twitter's developer account authentication details
    
    If you wish to edit the keywords and add Twitter API related data, do it. 
    
    Now, save the changes done in the file.
    
    

**Starting the Flume agent**

 Create the HDFS directory for storing the Flume data. Make sure that it is accessible by the user running the Agent 
    
    
    $ hadoop fs -mkdir <destination>
    $ hadoop fs -chown -R flume:flume <destination>
    $ hadoop fs -chmod -R 770 <destination>
    $ sudo /etc/init.d/flume-ng-agent start
    
  
  
Conversion of Flume Data from Avro to CSV format and its Analyzation using Pig
----------------


**Avro to CSV using Pig**

  You need PiggyBank library.
  
  info: https://cwiki.apache.org/confluence/display/PIG/PiggyBank
  
  jar: http://search.maven.org/#search%7Cga%7C1%7Cpiggybank
   <pre>
  #register PiggyBank library
   
  grunt> register /<local_path>/piggybank-0.12.0.jar
  
  #load avro to pig
  
  grunt> result = LOAD '/<path_to_avro>/filename.avro' USING org.apache.pig.builtin.AvroStorage();
  
  #store avro as csv
  
  grunt> STORE result INTO '<destination_filename>' USING org.apache.pig.piggybank.storage.CSVExcelStorage(',', 'YES_MULTILINE', 'UNIX') PARALLEL 1;

   </pre>

   

**CSV Data Analyzation using Pig**

    
    load_tweets = LOAD '/demonetization-tweets.csv' USING PigStorage(',');
    
    extract_details = FOREACH load_tweets GENERATE $0 as id,$1 as text;
    
    tokens = foreach extract_details generate id,text, FLATTEN(TOKENIZE(text)) As word;
    
    dictionary = load '/AFINN.txt' using PigStorage('\t') AS(word:chararray,rating:int);
    
    word_rating = join tokens by word left outer, dictionary by word using 'replicated';
    
    rating = foreach word_rating generate tokens::id as id,tokens::text as text, dictionary::rating as rate;
    
    word_group = group rating by (id,text)
    
    avg_rate = foreach word_group generate group, AVG(rating.rate) as tweet_rating;
    
    positive_tweets = filter avg_rate by tweet_rating>=0;
    
    negative_tweets = filter avg_rate by tweet_rating<0;
    

    We will rate the word as per its meaning from +5 to -5 using the dictionary AFINN. The AFINN is a dictionary which consists of 2500 words which are rated from +5 to -5 depending on their meaning.

    You can download the dictionary from the following link:
    
    https://drive.google.com/open?id=0ByJLBTmJojjzZ0d1RVdBTDVjT28
    

------------------------

