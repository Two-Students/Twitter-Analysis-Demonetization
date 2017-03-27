
#Defining Variables
inputFileName=demonetization-tweets.csv
inputFileDir=/TwitterCsvData
afinnLibDir=/Dictionary
afinnFile=AFINN.txt
pigOutputDir=/ExtractedData


#Removing HDFS directories if exist
hadoop fs -rmr $inputFile $afinnLibDir $pigOutputDir

#Creating HDFS Directories
hadoop fs -mkdir $inputFileLoc $afinnLibDir

#Uploading .csv Data and AFINN Library in HDFS location
hadoop fs -put $inputFileName $inputFileLoc
hadoop fs -put $afinnFile $afinnLibDir

#Runnig pig script
pig -p InputCsvData=$inputFileDir/$inputFileName -p Dictionary=$afinnLibDir/$afinnFile -p PigOutputLoc=$pigOutputDir extraction.pig

#Copying output in LFS
hadoop fs -get $pigOutputDir/part-r* .

#Converting output data into .csv format
cat part-r* > output.csv

