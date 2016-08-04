-- Combine average scores from the effective_care, readmissions, and complications tables. 
-- I average scores from all measures together for each facility, but I do not include measures
-- that do not have a sample size available or that have a sample size less than 35.
SELECT Hospital_Name, (Effective_Score + Readmission_Score + Complications_Score) / 3 AS Final_Rating
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
ON a.provider_id = d.provider_id
ORDER BY Final_Rating DESC 
LIMIT 10;
