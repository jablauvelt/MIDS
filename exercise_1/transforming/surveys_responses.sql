-- Load data into table
LOAD DATA INPATH '/user/w205/hospital_compare/surveys_responses/surveys_responses.csv' OVERWRITE INTO TABLE surveys_responses;

-- Create surveys_responses table. Assuming overall_rating_of_hospital_dimension_score represents the overall score for the hospital.
DROP TABLE surveys_responses;
CREATE TABLE surveys_responses AS
SELECT Provider_Number AS Provider_ID, 
AVG(CAST(RTRIM(SUBSTR(overall_rating_of_hospital_dimension_score,1, 2)) AS INT)) AS Overall_Rating
FROM surveys_responses_raw
GROUP BY provider_number;
