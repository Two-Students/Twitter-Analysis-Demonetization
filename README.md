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

    Copy twitter.conf file provided to $FLUME_HOME/conf directory.
    
    Edit the twitter.conf file and set parameters in accordance with the Twitter Agent.
    
    Fill the correct Twitter's developer account authentication details.
    
    If you wish to edit the keywords and add Twitter API related data, do it. 
    
    Now, save the changes done in the file.
    
    

**Starting the Flume agent**

 Create the HDFS directory for storing the Flume data. Make sure that it is accessible by the user running the Agent 
    
    
    $ hadoop fs -mkdir <destination>
    $ hadoop fs -chown -R flume:flume <destination>
    $ hadoop fs -chmod -R 770 <destination>
    $ sudo /etc/init.d/flume-ng-agent start
    OR
    $ $FLUME_HOME/bin/flume-ng agent --conf $FLUME_HOME/conf/ -f $FLUME_HOME/conf/twitter.conf  Dflume.root.logger=DEBUG,console -n TwitterAgent
    
  
  
Conversion of Flume Data from Avro to CSV format and its Analyzation using Pig
----------------


**Avro to CSV using Pig**

  You need PiggyBank library.
   
  jar: http://search.maven.org/#search%7Cga%7C1%7Cpiggybank
   
  #register PiggyBank library
   
  grunt> register /<local_path>/piggybank-0.12.0.jar
  
  #load avro to pig
  
  grunt> result = LOAD '/<path_to_avro>/filename.avro' USING org.apache.pig.builtin.AvroStorage();
  
  #store avro as csv
  
  grunt> STORE result INTO '<destination_filename>' USING org.apache.pig.piggybank.storage.CSVExcelStorage(',', 'YES_MULTILINE', 'UNIX') PARALLEL 1;

   
**CSV Data Analyzation using Pig**

    Now place mainScript.sh, extraction.pig, AFINN.txt and the above formed .csv file, all in a Directory on your LFS.
    
    Replace the file name of demonetization-tweets.csv in mainScript.sh with your .csv file formed in above step.
    
    Run mainScript.sh as -----
    $ sh mainScript.sh
    
    We will rate the word as per its meaning from +5 to -5 using the dictionary AFINN. The AFINN is a dictionary 
    which  consists of 2500 words which are rated from +5 to -5 depending on their meaning.

#Visualizing Our Output
    
    After running mainScript.sh , output.csv file will be generated in your directory.
    
    Now , you can visualize your output.csv using MsExcel, etc.
    
    We have provided a screenshot of how we visualized our OUTPUT in output.csv

                                                   ---X--X--X--X---

