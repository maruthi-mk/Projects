-- MySQL dump 11.19  Distrib 8.0.18, for Win64 (x86_64)
--
-- DATA 604: Assignment - 3
-- Maruthi Mutnuri
--
-- Host: localhost    Database: data604_a3
-- ------------------------------------------------------
-- Server version	8.0.18

--
-- Part-A
--

SELECT name,address 
FROM community_services 
WHERE type LIKE '%Attraction%';

--
-- Part-B
--

SELECT name 
FROM community_services 
WHERE type LIKE '%community centre%' 
	AND address LIKE '%SW%';

--
-- Part-C
--

SELECT name 
FROM community 
WHERE sector LIKE '%NorthEast%' 
	AND name LIKE '%ridge%';

--
-- Part-D
--

SELECT name 
FROM community 
WHERE class LIKE '%Industrial%';

--
-- Part-E
--

SELECT community.sector,community.comm_code,Community_Services.name 
FROM community_services 
	INNER JOIN community 
		ON (community_services.comm_code=community.comm_code);

--
-- Part-F
--

SELECT DISTINCT wardcommunity.ward_number 
FROM wardcommunity 
	INNER JOIN assessment 
		ON (wardcommunity.comm_code=assessment.comm_code)
WHERE assessment.median_value > 700000;

--
-- Part-G
--

 SELECT Community_Services.name 
 FROM community_services 
	INNER JOIN community
		ON (community_services.comm_code=community.comm_code)
 WHERE community.class NOT IN ('industrial', 'residential') 
	AND community_services.type like '%Attraction%';

--
-- Part-H
--

SELECT Community_Services.name
 FROM community_services 
	INNER JOIN wardcommunity
		ON (community_services.comm_code=wardcommunity.comm_code)
 WHERE wardcommunity.ward_number = 2 
	AND community_services.type like '%PHS Clinic%'; 

--
-- Part-I
--

SELECT community.name, Community_Services.name  
 FROM community 
	LEFT JOIN community_services
		ON (community.comm_code=community_services.comm_code);
		
-- Dump completed on 2019-11-19  11:02:05
