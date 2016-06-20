-- Create table that shows the final ratings for each hospital per my analysis
DROP TABLE hospital_scores;
CREATE TABLE hospital_scores AS
SELECT a.Provider_ID, (Effective_Score + Readmission_Score + Complications_Score) / 3 AS Final_Rating
FROM (
SELECT Provider_ID, AVG(Score_Relative) AS Effective_Score
FROM effective_care
WHERE Sample IS NOT NULL AND Sample >=35
GROUP BY Provider_ID
) a
INNER JOIN (
SELECT Provider_ID, AVG(Score_Relative) AS Readmission_Score
FROM readmissions
WHERE Denominator IS NOT NULL AND Denominator >=35
GROUP BY Provider_ID
) b
ON a.provider_id = b.provider_id
INNER JOIN (
SELECT Provider_ID, AVG(Score_Relative) AS Complications_Score
FROM complications
WHERE Denominator IS NOT NULL AND Denominator >=35
GROUP BY Provider_ID
) c
ON a.provider_id = c.provider_id
INNER JOIN hospitals d
ON a.provider_id = d.provider_id;

-- Compare the hospital ratings per my analysis to the ratings from the survey
SELECT Corrrelation, COUNT(*)
FROM (
SELECT a.provider_id, 
CASE WHEN Final_Rating < 0.5 AND Overall_Rating < 5 THEN 'Both Below Average'
     WHEN Final_Rating < 0.5 AND Overall_Rating >=5 THEN 'JAB Rating Below Average, Survey Ratings Above Average'
     WHEN Final_Rating >= 0.5 AND Overall_Rating >= 5 THEN 'Both Above Average'
     WHEN Final_Rating >= 0.5 AND Overall_Rating < 5 THEN 'JAB Rating Above Average, Survey Ratings Below Average'
     ELSE 'Not Enough Information' END AS Corrrelation
FROM hospital_scores a
INNER JOIN surveys_responses b
ON a.provider_id = b.provider_id
) tbl
GROUP BY Corrrelation;
