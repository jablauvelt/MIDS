-- Load data into table
LOAD DATA INPATH '/user/w205/hospital_compare/complications/complications.csv' OVERWRITE INTO TABLE complications_raw;

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
         FROM complications_raw) tbl
GROUP BY Measure_ID;


-- Create complications table that is ready for later analysis. It includes the score_relative field, which
-- looks up to the temporary table created above to find the relative score for that measure_id.
DROP TABLE complications;
CREATE TABLE complications AS 
SELECT Provider_ID, a.Measure_ID, Measure_Name, Compared_to_National, Score, Score / Score_Max AS Score_Relative, 
CAST(CASE WHEN Denominator LIKE '%[a-z]%' THEN NULL ELSE Denominator END AS INT) AS Denominator
FROM complications_raw a
INNER JOIN measure_score_ranges b
ON a.measure_id = b.measure_id;


