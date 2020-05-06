-- DATA 604: Assignment - 4
-- Maruthi Mutnuri
-- Part-1
-- Q1
SELECT title 
FROM movie
WHERE budget > revenue 
	AND vote_average > 8.0;

-- Q2
SELECT production_company.name
FROM production_company 
	INNER JOIN production_country 
		ON (production_company.tmdb_id=production_country.tmdb_id)
WHERE production_country.name = 'Liechtenstein';

-- Q3
SELECT name, Cast_id.character_name 
FROM person
	INNER JOIN
	(SELECT cast.person_id, cast.character_name
	FROM cast 
		INNER JOIN movie 
			ON (cast.tmdb_id=movie.tmdb_id)
	WHERE movie.title = 'Cast Away') AS Cast_id
		ON (person.person_id=Cast_id.person_id);

            
--
-- Part-2
-- Q4
SELECT COUNT(title) 
FROM movie
WHERE budget > 100000000; 

-- Q5
SELECT COUNT(DISTINCT name) FROM production_country; 

-- Q6
SELECT collection.name, MOVIE_C.M_COUNT AS No_of_Movies 
FROM collection
	INNER JOIN
	(SELECT collection_id, count(collection_id) AS M_COUNT
	FROM movie
	Where collection_id IS NOT NULL
	GROUP BY collection_id
	ORDER BY count(collection_id) DESC LIMIT 5) AS MOVIE_C
		ON (collection.collection_id=MOVIE_C.collection_id);
        
-- Q7
SELECT production_country.name AS COUNTRY, AVG(movie.revenue) AS Average_Revenue
FROM movie
	INNER JOIN production_country
		ON (movie.tmdb_id = production_country.tmdb_id)
GROUP BY COUNTRY
HAVING AVG(movie.revenue) > 0;

-- Q8
SELECT production_company.name AS Production_Company
FROM movie
	INNER JOIN production_company
		ON (movie.tmdb_id = production_company.tmdb_id)
GROUP BY Production_Company
ORDER BY count(movie.tmdb_id) DESC LIMIT 1;

-- Q9
SELECT TOM_GENRE.NAME, TOM_GENRE.GENRE, COUNT(TOM_GENRE.ID) AS NUM_MOVIES, 
	AVG(movie.revenue) AS AVG_REVENUE
FROM
	(SELECT TOM.NAME AS NAME, M_GENRE.GENRE AS GENRE, TOM.ID AS ID
	FROM 
		(SELECT person.name AS NAME, cast.person_id, cast.tmdb_id AS ID
		FROM person
			INNER JOIN cast
				ON (person.person_id = cast.person_id)
		WHERE person.name LIKE 'Tom Hanks') AS TOM
			INNER JOIN
			(SELECT name AS GENRE, genre.genre_id, movie_genre.tmdb_id AS ID  
			FROM genre
				INNER JOIN movie_genre
					ON (genre.genre_id = movie_genre.genre_id)) AS M_GENRE
				ON (TOM.ID = M_GENRE.ID)) AS TOM_GENRE
		INNER JOIN movie
			ON (TOM_GENRE.ID = movie.tmdb_id)
GROUP BY TOM_GENRE.GENRE;

--
-- Part-3
-- Q10
SELECT collection.name AS MOVIE_COLLECTION, MOVIE_C.M_SUM AS Total_Revenue 
FROM collection
	INNER JOIN
	(SELECT collection_id, SUM(revenue) AS M_SUM
	FROM movie
	Where collection_id IS NOT NULL
	GROUP BY collection_id
	ORDER BY SUM(revenue) DESC LIMIT 3) AS MOVIE_C
		ON (collection.collection_id=MOVIE_C.collection_id);

-- Q11
SELECT M_GENRE.GENRE, MAX(CAD.BUG) AS Max_Budget, AVG(CAD.BUG) AS Avg_Budget
FROM        
	(SELECT movie.tmdb_id AS ID, movie.budget AS BUG
	FROM movie
		INNER JOIN production_country
			ON (movie.tmdb_id = production_country.tmdb_id)
	WHERE production_country.name = 'CANADA') AS CAD
		INNER JOIN
		(SELECT name AS GENRE, genre.genre_id, movie_genre.tmdb_id AS ID  
		FROM genre
			INNER JOIN movie_genre
				ON (genre.genre_id = movie_genre.genre_id)) AS M_GENRE
			ON (CAD.ID = M_GENRE.ID)
GROUP BY M_GENRE.GENRE;

--
-- Part-3
-- Q12
SELECT count(DISTINCT cast.person_id) AS First_Degree_Connections
FROM cast
	INNER JOIN
	(SELECT cast.tmdb_id as ID #COUNT(DISTINCT name) 
	FROM person
		INNER JOIN cast
			ON (person.person_id = cast.person_id)
	WHERE person.name LIKE 'Kevin Bacon') AS KEVIN
		ON (cast.tmdb_id = KEVIN.ID);

-- Q13
SELECT count(DISTINCT cast.person_id) AS First_or_Second_Degree_Connections
FROM cast
	INNER JOIN
	(SELECT DISTINCT cast.tmdb_id AS C_ID
	FROM cast
		INNER JOIN
		(SELECT DISTINCT cast.person_id AS P_ID
		FROM cast
			INNER JOIN
			(SELECT cast.tmdb_id as ID  
			FROM person
				INNER JOIN cast
					ON (person.person_id = cast.person_id)
			WHERE person.name LIKE 'Kevin Bacon') AS KEVIN
				ON (cast.tmdb_id = KEVIN.ID)) AS KEVIN_1
			ON (cast.person_id = KEVIN_1.P_ID)) AS KEVIN_2
		ON(cast.tmdb_id = KEVIN_2.C_ID);

      
-- Q14
SELECT count(DISTINCT cast.person_id) AS Sixth_Degree_or_Less_Connections
FROM cast
	INNER JOIN
	(SELECT DISTINCT cast.tmdb_id AS C_ID
	FROM cast
		INNER JOIN
		(SELECT DISTINCT cast.person_id AS P_ID
		FROM cast
			INNER JOIN
			(SELECT DISTINCT cast.tmdb_id AS C_ID
			FROM cast
				INNER JOIN
				(SELECT DISTINCT cast.person_id AS P_ID
				FROM cast
					INNER JOIN
					(SELECT DISTINCT cast.tmdb_id AS C_ID
					FROM cast
						INNER JOIN
						(SELECT DISTINCT cast.person_id AS P_ID
						FROM cast
							INNER JOIN
							(SELECT DISTINCT cast.tmdb_id AS C_ID
							FROM cast
								INNER JOIN
								(SELECT DISTINCT cast.person_id AS P_ID
								FROM cast
									INNER JOIN
									(SELECT DISTINCT cast.tmdb_id AS C_ID
									FROM cast
										INNER JOIN
										(SELECT DISTINCT cast.person_id AS P_ID
										FROM cast
											INNER JOIN
											(SELECT cast.tmdb_id as ID  
											FROM person
												INNER JOIN cast
													ON (person.person_id = cast.person_id)
											WHERE person.name LIKE 'Kevin Bacon') AS KEVIN
												ON (cast.tmdb_id = KEVIN.ID)) AS KEVIN_1
											ON (cast.person_id = KEVIN_1.P_ID)) AS KEVIN_2
										ON(cast.tmdb_id = KEVIN_2.C_ID)) AS KEVIN_21
									ON (cast.person_id = KEVIN_21.P_ID)) AS KEVIN_3
								ON(cast.tmdb_id = KEVIN_3.C_ID)) AS KEVIN_31
							ON (cast.person_id = KEVIN_31.P_ID)) AS KEVIN_4
						ON(cast.tmdb_id = KEVIN_4.C_ID)) AS KEVIN_41
					ON (cast.person_id = KEVIN_41.P_ID)) AS KEVIN_5
				ON(cast.tmdb_id = KEVIN_5.C_ID)) AS KEVIN_51
			ON (cast.person_id = KEVIN_51.P_ID)) AS KEVIN_6
		ON(cast.tmdb_id = KEVIN_6.C_ID);

-- Q15
SELECT COUNT(DISTINCT person_id) AS TOTAL_ACTORS
FROM cast;