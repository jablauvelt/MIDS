-- Load data into table
LOAD DATA INPATH '/user/w205/hospital_compare/effective_care/effective_care.csv' OVERWRITE INTO TABLE effective_care_raw;

-- Create a temporary table to hold the maximum value of the scores for each measure_id. Some of the scores are above 100
-- or are on different scales, so I want to normalize these into a field Score_Relative in the subsequent query.
DROP TABLE measure_score_ranges;
CREATE TEMPORARY TABLE measure_score_ranges AS 
SELECT Measure_ID, MIN(Score) AS Score_Min, Max(Score) AS Score_Max
FROM	(SELECT Measure_ID, CAST(CASE WHEN Score = 'Not Available' THEN NULL
                                      WHEN Score LIKE 'Low %' THEN 1
                                      WHEN Score LIKE 'Medium %' THEN 2
                                      WHEN Score LIKE 'High %' THEN 3
                                      WHEN Score LIKE 'Very High %' THEN 4
                                      ELSE Score END AS INT) AS Score
         FROM effective_care_raw) tbl
GROUP BY Measure_ID;


-- Create effective_care table that is ready for later analysis. It includes the score_relative field, which
-- looks up to the temporary table created above to find the relative score for that measure_id.
DROP TABLE effective_care;
CREATE TABLE effective_care AS 
SELECT Provider_ID, Condition, a.Measure_ID, Measure_name, Score, Score / Score_Max as Score_Relative, 
CAST(CASE WHEN Sample LIKE '%[a-z]%' THEN NULL ELSE Sample END AS INT) AS Sample
FROM effective_care_raw a
INNER JOIN measure_score_ranges b
ON a.measure_id = b.measure_id;


