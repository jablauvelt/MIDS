mkdir /data/hospital_compare
cd /data/hospital_compare
wget -O flatfiles.zip --output-document=flatfiles.zip https://data.medicare.gov/views/bg9k-emty/files/Nqcy71p9Ss2RSBWDmP77H1DQXcyacr2khotGbDHHW_s?content_type=application%2Fzip%3B%20charset%3Dbinary&filename=Hospital_Revised_Flatfiles.zip
unzip flatfiles.zip
for file in *; do mv "$file" `echo $file | tr ' ' '_'` ; done
tail -n +2 Measure_Dates.csv > Measures.csv
tail -n +2 Hospital_General_Information.csv > hospitals.csv
tail -n +2 Timely_and_Effective_Care_-_Hospital.csv > effective_care.csv
tail -n +2 Readmissions_and_Deaths_-_Hospital.csv > readmissions.csv
tail -n +2 hvbp_hcahps_05_28_2015.csv > surveys_responses.csv
hdfs dfs -mkdir /user/w205/hospital_compare/measures
hdfs dfs -mkdir /user/w205/hospital_compare/hospitals
hdfs dfs -mkdir /user/w205/hospital_compare/effective_care
hdfs dfs -mkdir /user/w205/hospital_compare/readmissions
hdfs dfs -mkdir /user/w205/hospital_compare/surveys_responses
hdfs dfs -put Measures.csv /user/w205/hospital_compare/measures
hdfs dfs -put hospitals.csv /user/w205/hospital_compare/hospitals
hdfs dfs -put effective_care.csv /user/w205/hospital_compare/effective_care
hdfs dfs -put readmissions.csv /user/w205/hospital_compare/surveys_responses
hdfs dfs -put surveys_responses.csv /user/w205/hospital_compare/surveys_responses

