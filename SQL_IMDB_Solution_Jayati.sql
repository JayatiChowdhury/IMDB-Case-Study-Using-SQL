USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

-- Number of rows = 3867
SELECT COUNT(*) FROM DIRECTOR_MAPPING;

-- Number of rows = 14662
SELECT COUNT(*) FROM GENRE ;

-- Number of rows = 7997
SELECT COUNT(*) FROM  MOVIE;

-- Number of rows = 25735
SELECT COUNT(*) FROM  NAMES;

-- Number of rows = 7997
SELECT COUNT(*) FROM  RATINGS;

-- Number of rows = 15615
SELECT COUNT(*) FROM  ROLE_MAPPING;

-- Q2. Which columns in the movie table have null values?
-- Type your code below:


SELECT Sum(CASE
             WHEN id IS NULL THEN 1
             ELSE 0
           END) AS ID_NULL_COUNT,
       Sum(CASE
             WHEN title IS NULL THEN 1
             ELSE 0
           END) AS title_NULL_COUNT,
       Sum(CASE
             WHEN year IS NULL THEN 1
             ELSE 0
           END) AS year_NULL_COUNT,
       Sum(CASE
             WHEN date_published IS NULL THEN 1
             ELSE 0
           END) AS date_published_NULL_COUNT,
       Sum(CASE
             WHEN duration IS NULL THEN 1
             ELSE 0
           END) AS duration_NULL_COUNT,
       Sum(CASE
             WHEN country IS NULL THEN 1
             ELSE 0
           END) AS country_NULL_COUNT,
       Sum(CASE
             WHEN worlwide_gross_income IS NULL THEN 1
             ELSE 0
           END) AS worlwide_gross_income_NULL_COUNT,
       Sum(CASE
             WHEN languages IS NULL THEN 1
             ELSE 0
           END) AS languages_NULL_COUNT,
       Sum(CASE
             WHEN production_company IS NULL THEN 1
             ELSE 0
           END) AS production_company_NULL_COUNT
FROM   movie; 

-- Country, worlwide_gross_income, languages and production_company columns have NULL values
-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+*/


SELECT * FROM  MOVIE;
/*--2017	3052
--2018	2944
--2019	2001*/

SELECT 
    year, COUNT(title) AS NUMBER_OF_MOVIES
FROM
    movie
GROUP BY year;

/*The highest number of movies is produced in 2017*/
/*Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
SELECT 
    MONTH(date_published) AS MONTH_NUM,
    COUNT(*) AS NUMBER_OF_MOVIES
FROM
    movie
GROUP BY month_num
ORDER BY month_num;

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT 
    COUNT(DISTINCT id) AS number_of_movies, year, country
FROM
    MOVIE
WHERE
    YEAR = '2019' AND country = 'USA'
        OR country = 'INDIA';

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

/* Total 13 genre */

Select distinct genre
FROM genre;


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

/* no_of_movies is 4285 for genre Drama */

SELECT 
    genre, COUNT(m.id) AS number_of_movies
FROM
    genre AS g
        INNER JOIN
    movie AS m ON m.id = g.movie_id
GROUP BY genre
ORDER BY number_of_movies DESC;

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

/* no of movies in one genre=3289*/
WITH movies_in_one_genre
     AS (SELECT movie_id
         FROM   genre
         GROUP  BY movie_id
         HAVING Count(DISTINCT genre) = 1)
SELECT Count(*) AS movies_in_one_genre
FROM   movies_in_one_genre; 



/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT 
    genre, AVG(m.duration) AS avg_duration
FROM
    genre AS g
        INNER JOIN
    movie AS m ON m.id = g.movie_id
GROUP BY genre
ORDER BY avg_duration DESC;



/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

/*so its clearly visible Thriller=3 genre_rank*/
SELECT genre,
       Count(m.id) AS movie_count,
       RANK() OVER(ORDER BY Count(m.id) DESC) As genre_rank 
FROM genre as g
INNER JOIN movie as m
ON m.id = g.movie_id
GROUP BY genre;




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM ratings;

/* min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
1.0	10.0	100	725138	1	10
/*

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

WITH top_10_movies AS
(
SELECT m.title AS title,avg_rating,
	  ROW_NUMBER() OVER (ORDER BY avg_rating DESC) AS movie_rank
FROM movie AS m
LEFT JOIN ratings AS r ON m.id = r.movie_id
)
SELECT *
FROM  top_10_movies
WHERE movie_rank <= 10;
    

/* Top 3 movies have average rating >= 9.8 /*

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT 
    median_rating, COUNT(movie_id) AS movie_count
FROM
    ratings
GROUP BY median_rating
ORDER BY median_rating;

/*output
median_rating	|	movie_count		
1	94
2	119
3	283
4	479
5	985
/*

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH top_produced_hits AS
(
SELECT m.production_company,
    COUNT(m.id) AS movie_count,
    RANK() OVER (ORDER BY COUNT(m.id) DESC) AS prod_company_rank
FROM movie AS m
	LEFT JOIN
    ratings AS r
	ON m.id = r.movie_id
WHERE avg_rating>8 AND m.production_company IS NOT NULL
GROUP BY production_company
)
SELECT * FROM top_produced_hits
WHERE prod_company_rank = 1;


/*output
|production_company|movie_count	       |	prod_company_rank|
Dream Warrior Pictures	3	1
National Theatre Live	3	1
/*




-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    genre, 
    COUNT(r.movie_id) AS movie_count
FROM
    genre AS g
        INNER JOIN
    movie AS m ON m.id = g.movie_id
        INNER JOIN
    ratings AS r ON m.id = r.movie_id
WHERE
    MONTH(date_published) = 3
        AND YEAR(date_published) = 2017
        AND country LIKE '%USA%'
        AND total_votes > 1000
GROUP BY genre;

/*genre			|	movie_count		
Drama	24
Comedy	9
Action	8
Thriller	8
/*



-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
    title, avg_rating, genre
FROM
    movie AS m
        INNER JOIN
    genre AS g ON m.id = g.movie_id
        INNER JOIN
    ratings AS r ON m.id = r.movie_id
WHERE
    title LIKE 'The%' AND avg_rating > 8
GROUP BY title
ORDER BY avg_rating DESC;

/*| title			|		avg_rating	|		genre	      |
The Brighton Miracle	9.5	Drama
The Colour of Darkness	9.1	Drama
The Blue Elephant 2	8.8	Drama
The Irishman	8.7	Crime
*/


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
    COUNT(m.id) AS movie_count
FROM
    movie AS m
        INNER JOIN
    ratings AS r ON m.id = r.movie_id
WHERE
    median_rating = 8
        AND date_published BETWEEN '2018-04-01' AND '2019-04-01';

-- 361 Movies were released b/w 1 April 2018 and 1 April 2019 given median rating of 8.

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT country, sum(total_votes) AS votes_count
FROM movie as m 
	INNER JOIN ratings as r
		ON r.movie_id=m.id
WHERE country = 'germany' OR country = 'italy'
GROUP BY country;


/*languages | Total votes
Germany	106710
Italy	77965
*/

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/


-- Segment 3:






-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
/*known_for_movies_nulls=15226
name_nulls=0
height_nulls=17335
date_of_birth_nulls=1343


*/

SELECT 
		SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls, 
		SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
		SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
		SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:





WITH top_3_genres AS
(
           SELECT     genre,
                      Count(m.id) AS movie_count ,
                      Rank() OVER(ORDER BY Count(m.id) DESC) AS genre_rank
           FROM       movie AS m
           INNER JOIN genre AS g
           ON         g.movie_id = m.id
           INNER JOIN ratings AS r
           ON         r.movie_id = m.id
           WHERE      avg_rating > 8
           GROUP BY   genre limit 3 )
SELECT     n.NAME            AS director_name ,
           Count(d.movie_id) AS movie_count
FROM       director_mapping  AS d
INNER JOIN genre G
using     (movie_id)
INNER JOIN names AS n
ON         n.id = d.name_id
INNER JOIN top_3_genres
using     (genre)
INNER JOIN ratings
using      (movie_id)
WHERE      avg_rating > 8
GROUP BY   NAME
ORDER BY   movie_count DESC limit 3 ;

/* director_name  |movie_count
James Mangold	4
Anthony Russo	3
Soubin Shahir	3
*/

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT 
    N.name AS actor_name, COUNT(movie_id) AS movie_count
FROM
    role_mapping AS RM
        INNER JOIN
    movie AS M ON M.id = RM.movie_id
        INNER JOIN
    ratings AS R USING (movie_id)
        INNER JOIN
    names AS N ON N.id = RM.name_id
WHERE
    R.median_rating >= 8
        AND category = 'ACTOR'
GROUP BY actor_name
ORDER BY movie_count DESC
LIMIT 2; 

/*actor_name | movie_count
Mammootty	8
Mohanlal	5
*/

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


SELECT     production_company,
           Sum(total_votes)                            AS vote_count,
           Rank() OVER(ORDER BY Sum(total_votes) DESC) AS prod_comp_rank
FROM       movie                                       AS m
INNER JOIN ratings                                     AS r
ON         r.movie_id = m.id
GROUP BY   production_company limit 3;

/*production_company|vote_count			|		prod_comp_rank|
Marvel Studios	2656967	1
Twentieth Century Fox	2411163	2
Warner Bros.	2396057	3
*/
/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


WITH actor_detail_summary
     AS (SELECT N.NAME                                                     AS
                actor_name
                ,
                total_votes,
                Count(R.movie_id)                                          AS
                   movie_count,
                Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS
                   actor_avg_rating
         FROM   movie AS M
                INNER JOIN ratings AS R
                        ON M.id = R.movie_id
                INNER JOIN role_mapping AS RM
                        ON M.id = RM.movie_id
                INNER JOIN names AS N
                        ON RM.name_id = N.id
         WHERE  category = 'ACTOR'
                AND country = "india"
         GROUP  BY NAME
         HAVING movie_count >= 5)
SELECT *,
       Rank()
         OVER(
           ORDER BY actor_avg_rating DESC) AS actor_rank
FROM   actor_detail_summary; 

/*actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
Vijay Sethupathi	20364	5	8.42	1
*/


-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:



WITH actress_detailsummary AS 
(
SELECT n.name as actress_name,
       total_votes,
	   Count(r.movie_id) AS movie_count,
       Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating
 FROM movie AS m
 INNER JOIN ratings AS r
 ON m.id = r.movie_id
 INNER JOIN role_mapping AS rm
 ON m.id = rm.movie_id
 INNER JOIN names AS n
 ON rm.name_id = n.id
 WHERE category ='ACTRESS'
 AND   country = "INDIA"
 AND   languages LIKE '%HINDI%'
 GROUP BY   NAME
 HAVING     movie_count>=3 )
 SELECT * ,
       RANK() OVER (ORDER BY actress_avg_rating DESC) AS actress_rank
 FROM actress_detailsummary;
 
       


/*actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   
Taapsee Pannu	2269	3	7.74	1
Kriti Sanon	14978	3	7.05	2
Divya Dutta	345	3	6.88	3
Shraddha Kapoor	3349	3	6.63	4
Kriti Kharbanda	1280	3	4.80	5
*/



/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
WITH thriller_movies
     AS (SELECT DISTINCT title,
                         avg_rating
         FROM   movie AS M
                INNER JOIN ratings AS R
                        ON R.movie_id = M.id
                INNER JOIN genre AS G using(movie_id)
         WHERE  genre LIKE 'THRILLER')
SELECT *,
       CASE
         WHEN avg_rating > 8 THEN 'Superhit movies'
         WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
         WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
         WHEN avg_rating < 5 THEN 'Flop movies'
       END AS avg_rating_category
FROM   thriller_movies;

/*Title | avg_rating | avg_rating_category
Der müde Tod	7.7	Hit movies
Fahrenheit 451	4.9	Flop movies
Pet Sematary	5.8	One-time-watch movies
Dukun	6.9	One-time-watch movies
Back Roads	7.0	Hit movies
*/

-- Segment 4:



-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

WITH genre_summ AS
(
SELECT genre,
    ROUND(AVG(duration),2) AS avg_duration
FROM genre AS g
	LEFT JOIN
    movie AS m 
	ON g.movie_id = m.id
GROUP BY genre
)
SELECT *,
	SUM(avg_duration) OVER (ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
    AVG(avg_duration) OVER (ORDER BY genre ROWS UNBOUNDED PRECEDING) AS moving_avg_duration
FROM
	genre_summ;


/*output
genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
Action	112.88	112.88	112.880000
Adventure	101.87	214.75	107.375000
Comedy	102.62	317.37	105.790000
Crime	107.05	424.42	106.105000
Drama	106.77	531.19	106.238000*/




-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies



WITH Top_three_genre AS
(
SELECT genre,
		COUNT(r.movie_id) AS number_of_movies
FROM genre g 
INNER JOIN movie m 
ON g.movie_id= m.id 
INNER JOIN ratings r 
ON m.id=r.movie_id 
GROUP BY genre
ORDER BY number_of_movies desc
limit 3
)
,
Top_5 AS
(
SELECT genre,
		year,
        title AS movie_name,
        worlwide_gross_income,
       RANK() OVER (PARTITION BY g.genre, year
					ORDER BY CONVERT(REPLACE(TRIM(worlwide_gross_income), "$ ",""), UNSIGNED INT) DESC) AS movie_rank
FROM movie m INNER JOIN genre g on
m.id= g.movie_id
WHERE genre IN (SELECT genre FROM Top_three_genre)
)
SELECT *
FROM Top_5
WHERE movie_rank<=5;







-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


SELECT production_company,count(m.id) AS movie_count,
        ROW_NUMBER() OVER(ORDER BY count(id) DESC) AS prod_comp_rank
FROM movie m INNER JOIN ratings r ON
m.id=r.movie_id
WHERE median_rating>=8 and production_company IS NOT NULL AND Position(',' IN languages)>0
GROUP BY production_company
LIMIT 2;

/*output
|production_company |movie_count		|		prod_comp_rank|
Star Cinema	7	1
Twentieth Century Fox	4	2



-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_details_summary AS
(
           SELECT     n.name AS actress_name,
                      SUM(total_votes) AS total_votes,
                      Count(r.movie_id)AS movie_count, 
                      Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating
           FROM movie AS m
           INNER JOIN ratings AS r
           ON m.id=r.movie_id
           INNER JOIN role_mapping AS rm
           ON m.id = rm.movie_id
           INNER JOIN names AS n
           ON rm.name_id = n.id
           INNER JOIN GENRE AS g
           ON g.movie_id = m.id
           WHERE category = 'ACTRESS'
           AND avg_rating>8
           AND genre = "Drama"
           GROUP BY   NAME )
SELECT   *,
         Rank() OVER(ORDER BY movie_count DESC) AS actress_rank
FROM     actress_details_summary LIMIT 3;


/*actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
Parvathy Thiruvothu	4974	2	8.25	1
Susan Brown	656	2	8.94	1
Amanda Lawrence	656	2	8.94	1 */




/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH next_date_detail AS
(
	  SELECT     d.name_id,
                      name,
                      d.movie_id,
                      duration,
                      r.avg_rating,
                      total_votes,
                      m.date_published,
                      Lead(date_published,1) OVER(partition BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
           FROM director_mapping AS d
           INNER JOIN names AS n
           ON n.id = d.name_id
           INNER JOIN movie AS m
           ON m.id = d.movie_id
           INNER JOIN ratings AS r
           ON r.movie_id = m.id ), top_director_summary AS
(
	   SELECT *,
              Datediff(next_date_published, date_published) AS date_difference
       FROM   next_date_detail )
       SELECT   name_id AS director_id,
                name AS director_name,
                Count(movie_id)               AS number_of_movies,
                Round(Avg(date_difference),2) AS avg_inter_movie_days,
                Round(Avg(avg_rating),2)               AS avg_rating,
                Sum(total_votes)              AS total_votes,
                Min(avg_rating)               AS min_rating,
                Max(avg_rating)               AS max_rating,
                Sum(duration)                 AS total_duration
        FROM     top_director_summary
        GROUP BY director_id
        ORDER BY Count(movie_id) DESC limit 9;

/*output
 director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
nm2096009	Andrew Jones	5	190.75	3.02	1989	2.7	3.2	432
nm1777967	A.L. Vijay	5	176.75	5.42	1754	3.7	6.9	613
nm0814469	Sion Sono	4	331.00	6.03	2972	5.4	6.4	502
/*



