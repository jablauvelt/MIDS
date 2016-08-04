-- Load data into table
LOAD DATA INPATH '/user/w205/hospital_compare/hospitals/hospitals.csv' OVERWRITE INTO TABLE hospitals;

-- Create hospitals table
DROP TABLE hospitals;
CREATE TABLE hospitals AS
SELECT Provider_ID, Hospital_Name, State
FROM hospitals_raw;
