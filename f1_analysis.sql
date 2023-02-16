-- Historical Analysis of F1 Data

--Total Points by Driver after year 2000
--notes: change #points from string to integer 
SELECT DISTINCT d.forename, d.surname, SUM(CAST(r.points AS decimal)) AS Total_points
--INTO Total_Points_Driver_2000
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
--INTO total_wins_driver
FROM results AS r
INNER JOIN drivers AS d
ON r.driverId = d.driverId
WHERE position = 1 AND position <> '\N'
GROUP BY d.forename,d.surname
ORDER BY COUNT(CAST(position AS int))DESC;

--LEWIS HAMILTON Wins by team
SELECT d.forename,d.surname, COUNT(CAST(position AS int)) AS Total_Wins, c.name
--INTO Lewis_hamilton_wins
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
--INTO sebas_vettel_podiums
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
--INTO fastest_lap_bycircuit_byyear
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
--INTO canada_GP_winners_aft2000
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
--INTO vic_pod_poin_Monaco2022
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


--FERNANDO ALONSO % OF DNFs(did not finish) IN 2021
SELECT d.forename, d.surname, 
COUNT(CASE WHEN r.position = '\N' THEN 'DNF'END)*100/COUNT(rac.name) AS Percentage_of_DNF_in_2021 
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


--NUMBER OF DNFs(did not finish) BY RACE IN 2021
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

SELECT *
--INTO rrr
FROM results;

--Top 100 of Maximum points made by a constructor in one race 
-- Set up your CTE
WITH cte AS (
    SELECT TOP 100
  		rac.name AS GP, 
		rac.date as Date, 
		con.name AS Constructor,
		SUM(CAST(r.points AS decimal)) AS Total_Points
    FROM results AS r
    LEFT JOIN races as rac 
	ON r.raceId = rac.raceid
	LEFT JOIN constructors AS con 
	ON r.constructorId = con.constructorId
	WHERE r.points <> '\N'
	GROUP BY con.name, rac.name, rac.date
	ORDER BY SUM(CAST(r.points AS decimal)) DESC
	)
-- Select the league, date, home, and away goals from the CTE
SELECT GP, Date,Constructor,Total_Points
FROM cte
-- Filter by total goals
WHERE Total_Points >20;


-- Using Windows Functions 
--Finding the differnce between the shortest pit stop and the other pit stops in the Austrian GP in 2021
SELECT 
	con.name AS constructor,
	rac.name,
	d.forename, d.surname,
	CAST(pit.milliseconds AS decimal)/1000 AS pit_duration,
	-- Use a window to include the aggregate average in each row
	MIN(CAST(pit.milliseconds AS decimal) /1000) OVER() AS Min_pit_duration,
	(CAST(pit.milliseconds AS decimal) /1000) - (MIN(CAST(pit.milliseconds AS decimal) /1000) OVER()) AS Diff
 FROM results AS r
    LEFT JOIN races as rac 
	ON r.raceId = rac.raceid
	LEFT JOIN constructors AS con 
	ON r.constructorId = con.constructorId
	LEFT JOIN pit_stops AS pit
	ON r.raceId = pit.raceId
	LEFT JOIN drivers AS d
	ON r.driverId = d.driverId
	WHERE pit.duration IS NOT NULL AND rac.year = 2021 and rac.name = 'Austrian Grand Prix'


--Partirtion by year
--Finding the differnce between the shortest pit stop and the other pit stops by year and by GP 
	SELECT 
	con.name AS constructor,
	rac.name,
	d.forename, d.surname, rac.year,
	CAST(pit.milliseconds AS decimal)/1000 AS pit_duration,
	-- Use a window to include the aggregate average in each row
	MIN(CAST(pit.milliseconds AS decimal) /1000) OVER(PARTITION BY year) AS Min_pit_duration
	--(CAST(pit.milliseconds AS decimal) /1000) - (MIN(CAST(pit.milliseconds AS decimal) /1000) OVER()) AS Diff
 FROM results AS r
    LEFT JOIN races as rac 
	ON r.raceId = rac.raceid
	LEFT JOIN constructors AS con 
	ON r.constructorId = con.constructorId
	LEFT JOIN pit_stops AS pit
	ON r.raceId = pit.raceId
	LEFT JOIN drivers AS d
	ON r.driverId = d.driverId
	WHERE pit.duration IS NOT NULL AND rac.year > 2020 