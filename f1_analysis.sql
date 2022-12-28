-- Historical Analysis of F1 Data

--Total Points by Driver after year 2000
--notes: change #points from string to integer 
SELECT DISTINCT d.forename, d.surname, SUM(CAST(r.points AS decimal)) AS Total_points
FROM circuits AS c
INNER JOIN races AS rac
ON c.circuitId = rac.circuitId
INNER JOIN results AS r
ON rac.raceId = r.raceId
INNER JOIN drivers AS d
ON r.driverId = d.driverId
--INNER JOIN constructors AS con
--ON r.constructorId = con.constructorId
WHERE rac.year > 2000 AND position <> '\N'
GROUP BY d.forename, d.surname
ORDER BY SUM(CAST(r.points AS decimal)) DESC;


--TOTAL WINS BY EACH DRIVER
SELECT DISTINCT d.forename,d.surname, COUNT(CAST(position AS int)) AS Total_Wins
FROM results AS r
INNER JOIN drivers AS d
ON r.driverId = d.driverId
WHERE position = 1 AND position <> '\N'
GROUP BY d.forename,d.surname
ORDER BY COUNT(CAST(position AS int))DESC;

--LEWIS HAMILTON Wins by team
SELECT d.forename,d.surname, COUNT(CAST(position AS int)) AS Total_Wins, c.name
FROM results AS r
INNER JOIN drivers AS d
ON r.driverId = d.driverId
INNER JOIN constructors AS c
ON r.constructorId = c.constructorId
WHERE position = 1 AND position <> '\N' AND surname = 'Hamilton'
GROUP BY d.forename,d.surname, c.name
ORDER BY COUNT(CAST(position AS int))DESC;

--Sebastian Vettel Podiums by team
SELECT d.forename,d.surname, COUNT(CAST(position AS int)) AS Number_of_Podiums, c.name
FROM results AS r
INNER JOIN drivers AS d
ON r.driverId = d.driverId
INNER JOIN constructors AS c
ON r.constructorId = c.constructorId
WHERE position <> '\N' AND (position = 1 OR position = 2 OR position = 3 ) AND d.surname = 'Vettel'
GROUP BY d.forename,d.surname, c.name
ORDER BY COUNT(CAST(position AS decimal))DESC;

--Fastest Lap by circuit and year
SELECT DISTINCT rac.name AS Grand_Prix,rac.date, MIN(r.fastestLapTime) AS FastestTime, rac.year--,d.forename, d.surname
FROM circuits AS c
INNER JOIN races AS rac
ON c.circuitId = rac.circuitId
INNER JOIN results AS r
ON rac.raceId = r.raceId
INNER JOIN drivers AS d
ON r.driverId = d.driverId
WHERE r.fastestLapTime  <>'\n' AND rac.year > 2010
GROUP BY rac.name,rac.date, rac.year--, d.forename, d.surname
ORDER BY rac.year,rac.date, MIN(r.fastestLapTime)


--Winners of the Canada Grand Prix after 2000
SELECT DISTINCT rac.name AS Grand_Prix, rac.year, d.forename, d.surname
FROM circuits AS c
INNER JOIN races AS rac
ON c.circuitId = rac.circuitId
INNER JOIN results AS r
ON rac.raceId = r.raceId
INNER JOIN drivers AS d
ON r.driverId = d.driverId
WHERE c.country = 'Canada' AND r.position = 1 AND r.position <>'\n' AND rac.year >2000



-- Canada GP Winners since 2000
SELECT DISTINCT rac.name AS Grand_Prix, d.forename, d.surname, COUNT(r.position)AS Canadian_GP_Wins
FROM circuits AS c
INNER JOIN races AS rac
ON c.circuitId = rac.circuitId
INNER JOIN results AS r
ON rac.raceId = r.raceId
INNER JOIN drivers AS d
ON r.driverId = d.driverId
WHERE c.country = 'Canada' AND r.position = 1 AND r.position <>'\n' AND rac.year >2000-- AND d.surname = 'Hamilton'
GROUP BY rac.name, d.forename, d.surname
ORDER BY COUNT(r.position) DESC;

--USING CASE TO DETERMINE IF drive scored a victory, podium, or points in the Monaco GP 2022
SELECT rac.name, d.forename, d.surname, CAST(r.position AS int) AS position,
	CASE WHEN r.position = 1 THEN 'Victory'
		 WHEN r.position IN (2,3) THEN 'Podium'
		 WHEN r.position BETWEEN 4 AND 10 THEN 'Points'
		 ELSE 'Other' END AS Outcome 
FROM circuits AS c
INNER JOIN races AS rac
ON c.circuitId = rac.circuitId
INNER JOIN results AS r
ON rac.raceId = r.raceId
INNER JOIN drivers AS d
ON r.driverId = d.driverId
WHERE rac.name = 'Monaco Grand Prix ' AND rac.year = 2022 AND r.position <> '\N'
ORDER BY CAST(r.position AS int);

--update Raikonen last name
UPDATE drivers
SET surname = 'Räikkönen'
WHERE driverId = 8 ;

--update Hülkenberg last name
UPDATE drivers
SET surname = 'Hülkenberg'
WHERE driverId = 807 ;

SELECT driverId,forename, surname
FROM drivers
WHERE forename LIKE 'Ni%'


--Percentage of Podium of Drivers in 2021
--update Perez last name
UPDATE drivers
SET surname = 'Perez'
WHERE driverId = 815;


SELECT d.forename, d.surname, 
COUNT(CASE WHEN r.position BETWEEN 1 AND 3 THEN 'Podium'END)*100/COUNT(rac.name) AS Percentage_of_Podium_in_2021 
FROM circuits AS c
INNER JOIN races AS rac
ON c.circuitId = rac.circuitId
INNER JOIN results AS r
ON rac.raceId = r.raceId
INNER JOIN drivers AS d
ON r.driverId = d.driverId
WHERE rac.year = 2021 AND r.position <> '\N'
--WHERE d.surname = 'Perez' AND rac.year = 2021 AND r.position <> '\N'
GROUP BY  d.forename, d.surname
ORDER BY COUNT(CASE WHEN r.position BETWEEN 1 AND 3 THEN 'Podium'END)*100/COUNT(rac.name) DESC;


--NUMBER OF WINS BY TEAM IN 2021
SELECT DISTINCT CON.name,
SUM(CASE WHEN r.position = 1	THEN 1 ELSE 0 END) AS NUMBER_OF_WINS_BY_TEAM
FROM circuits AS c
INNER JOIN races AS rac
ON c.circuitId = rac.circuitId
INNER JOIN results AS r
ON rac.raceId = r.raceId
INNER JOIN constructors as con
ON r.constructorId= con.constructorId
INNER JOIN drivers AS d
ON r.driverId = d.driverId
WHERE r.position <> '\N' AND rac.year = 2021
GROUP BY CON.name,r.position
ORDER BY SUM(CASE WHEN r.position = 1 THEN 1 ELSE 0 END) DESC; 

--NUMBER OF WINS BY DRIVER IN 2021
SELECT DISTINCT con.name, d.forename, d.surname,
SUM(CASE WHEN r.position = 1	THEN 1 ELSE 0 END) AS NUMBER_OF_WINS_BY_DRIVER
FROM circuits AS c
INNER JOIN races AS rac
ON c.circuitId = rac.circuitId
INNER JOIN results AS r
ON rac.raceId = r.raceId
INNER JOIN constructors as con
ON r.constructorId= con.constructorId
INNER JOIN drivers AS d
ON r.driverId = d.driverId
WHERE r.position <> '\N' AND rac.year = 2021
GROUP BY con.name, d.forename, d.surname
ORDER BY SUM(CASE WHEN r.position = 1 THEN 1 ELSE 0 END) DESC; 


--FERNANDO ALONSO % OF DNFs IN 2021
SELECT d.forename, d.surname, 
COUNT(CASE WHEN r.position = '\N' THEN 'DNF'END)*100/COUNT(rac.name) AS Percentage_of_DNF_in_2022 
FROM circuits AS c
INNER JOIN races AS rac
ON c.circuitId = rac.circuitId
INNER JOIN results AS r
ON rac.raceId = r.raceId
INNER JOIN drivers AS d
ON r.driverId = d.driverId
WHERE d.surname = 'Alonso' AND rac.year = 2021 --AND r.position <> '\N'
GROUP BY  d.forename, d.surname
ORDER BY COUNT(CASE WHEN r.position = '\N' THEN 'DNF'END)*100/COUNT(rac.name)


--NUMBER OF DNFs BY RACE IN 2021
SELECT rac.name, CAST(rac.date AS DATE)AS Date,
COUNT(CASE WHEN r.position = '\N' THEN 'DNF'END) AS NUMBER_of_DNF_in_2021 
FROM circuits AS c
INNER JOIN races AS rac
ON c.circuitId = rac.circuitId
INNER JOIN results AS r
ON rac.raceId = r.raceId
INNER JOIN drivers AS d
ON r.driverId = d.driverId
WHERE rac.year = 2021 --AND r.position <> '\N'
GROUP BY CAST(rac.date AS DATE), rac.name
ORDER BY CAST(rac.date AS DATE), COUNT(CASE WHEN r.position = '\N' THEN 'DNF'END) DESC;

