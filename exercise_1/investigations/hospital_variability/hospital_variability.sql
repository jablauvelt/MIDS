-- Only analyzing effective care to look at variability because it should capture the variability sufficiently,
-- with no real need to include the variability from the complications or readmissions tables.
SELECT Measure_ID, STDDEV(Score_Relative) AS SD
FROM effective_care
WHERE Sample IS NOT NULL AND Sample >=35
GROUP BY Measure_ID
ORDER BY SD DESC
LIMIT 10;
