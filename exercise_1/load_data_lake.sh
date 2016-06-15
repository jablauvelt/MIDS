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

