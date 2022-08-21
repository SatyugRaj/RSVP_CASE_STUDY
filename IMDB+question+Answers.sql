USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

select count(*) from director_mapping as directorCOUNT;
select count(*) from genre as genreCOUNT;
select count(*) from movie as movieCOUNT;
select count(*) from names nameCOUNT;
select count(*) from ratings as ratingCOUNT;
select count(*) from role_mapping as roleCOUNT;


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

select * from movie where title is NULL;
select * from movie where year is NULL;
select * from movie where date_published is NULL;
select * from movie where duration is NULL;
select * from movie where country is NULL;
select * from movie where worlwide_gross_income is NULL;
select * from movie where languages is NULL;
select * from movie where production_company is NULL;
/* After checking from the above queries we see that the columns (country, worldwide_gross_income, languages and production_company) have null values in them.*/

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT year,count(id) as number_of_movies from movie group by year;

SELECT month(date_published) as month_num, count(id) as number_of_movies from movie group by month_num order by 2 desc;

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT COUNT(DISTINCT id) as number_of_movies,year from movie where country like '%INDIA%' or country like '%USA%' and year=2019;


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

select DISTINCT genre from genre;


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT 
    G.genre, COUNT(M.id) AS number_of_movies
FROM
    genre G
        INNER JOIN
    movie M ON M.id = G.movie_id
GROUP BY genre
ORDER BY number_of_movies DESC;


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH single_genre_movie AS
(SELECT movie_id,count(Distinct genre) from genre group by movie_id HAVING count(Distinct genre)=1 )
SELECT count(*) AS One_GENRE_MOVIE FROM single_genre_movie;



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

SELECT genre,AVG(duration) as AVG_Duration from  movie M
INNER JOIN genre G on G.movie_id=M.id group by G.genre ORDER BY AVG_Duration DESC;

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
SELECT 
    genre, COUNT(title) AS movie_count,
    RANK() OVER(order by COUNT(movie_id) DESC) as genre_rank
FROM
    genre G
        INNER JOIN
    movie M ON G.movie_id = M.id
GROUP BY G.genre
ORDER BY movie_count desc, genre_rank;


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT min(avg_rating) as min_avg_rating,
		max(avg_rating) as max_avg_rating,
		min(total_votes) as min_total_votes,
        max(total_votes) as max_total_votes,
        min(median_rating) as min_median_rating,
        max(median_rating) as max_median_rating
FROM ratings;    

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
WITH movie_rank_by_rating as
(SELECT M.title, (R.avg_rating),
		DENSE_RANK() OVER( ORDER BY (R.avg_rating) desc) as movie_rank
FROM ratings R 
INNER JOIN movie M
on M.id=R.movie_id 
order by avg_rating desc
)
SELECT * FROM movie_rank_by_rating
where movie_rank <= 10;

/* here we see 'Kirket' and "Love in Kilnerry" have the same avg_rating and tops the chart. */

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
ORDER BY movie_count DESC;


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
SELECT production_company, COUNT(id) as movie_count,
		DENSE_RANK() OVER(ORDER BY COUNT(id) desc) as prod_company_rank
FROM movie M 
INNER JOIN ratings R 
on R.movie_id=M.id
where avg_rating > 8
and production_company IS NOT NULL
GROUP BY production_company
order by 2 desc;

/* As said below, "Dream Warrior Pictures or National Theatre Live" both have the same number o fmovie count and hence they top the chart.*/

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
    genre, COUNT(M.id) AS movie_count
FROM
    genre G
        INNER JOIN
    movie M ON G.movie_id = M.id
        INNER JOIN
    ratings R ON M.id = R.movie_id
WHERE
    M.country LIKE '%USA%' AND M.year = 2017
        AND MONTH(M.date_published) = 3
        AND R.total_votes >= 1000
GROUP BY genre
ORDER BY movie_count DESC;


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
    movie M
        INNER JOIN
    ratings R ON R.movie_id = M.id
        INNER JOIN
    genre G ON M.id = G.movie_id
WHERE
    avg_rating > 8 AND title LIKE 'The%'
GROUP BY title
ORDER BY avg_rating;

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.

/* 'when used with median rating we see that we get many other results which have median rating more than 8 but their avg rating is below 8' */


-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT COUNT(title) as Movie_COunt, median_rating 
FROM movie M 
INNER JOIN ratings R 
on R.movie_id=M.id
where M.date_published between '2018-04-01' and '2019-04-01'
and R.median_rating=8
group by median_rating;


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT 
    country, SUM(total_votes) AS Numbre_of_Votes
FROM
    movie AS M
        INNER JOIN
    ratings AS R ON M.id = R.movie_id
WHERE
    country = 'Germany' OR country = 'Italy'
GROUP BY country;

-- method 2 using UNION

SELECT 
    languages, SUM(total_votes) AS Number_of_Votes
FROM
    movie M
        INNER JOIN
    ratings R ON R.movie_id = M.id
WHERE
    languages REGEXP 'GERMAN' 
    
UNION 

SELECT 
    languages, SUM(total_votes) AS Number_of_Votes
FROM
    movie M
        INNER JOIN
    ratings R ON R.movie_id = M.id
WHERE
    languages REGEXP 'ITALIAN'
ORDER BY Number_of_Votes DESC;
	
/* using both the ways we see that german language recieve high votes as compared to Italian , so the answer is YES */
    
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

SELECT 
		SUM(CASE WHEN name is NULL THEN  1  ELSE 0 END) as name_nulls,
        SUM(CASE WHEN height is NULL THEN  1  ELSE 0 END) as height_nulls,
        SUM(CASE WHEN date_of_birth is NULL THEN  1  ELSE 0 END) as date_of_birth_nulls,
        SUM(CASE WHEN known_for_movies is NULL THEN  1  ELSE 0 END) as known_for_movies_nulls
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

WITH top_genre as
(SELECT genre, COUNT(M.id) as movie_count,
		RANK() OVER(ORDER BY COUNT(M.id) DESC) as genre_rank
FROM movie M 
INNER JOIN genre G 
on G.movie_id=M.id
INNER JOIN ratings R 
on R.movie_id=M.id
where avg_rating > 8
GROUP BY genre limit 3
)
SELECT N.name as director_name,
		COUNT(D.movie_id) as movie_count
FROM director_mapping D 
INNER JOIN genre G 
USING (movie_id)
INNER JOIN names N 
on N.id=D.name_id
INNER JOIN top_genre
USING (genre)
INNER JOIN ratings
USING (movie_id)
WHERE avg_rating > 8
GROUP BY name
ORDER BY movie_count desc limit 3;


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

WITH top_actors as
(SELECT N.name AS actor_name,
       Count(movie_id) AS movie_count,
       ROW_NUMBER() OVER(ORDER BY COUNT(movie_id) DESC) as row_num
FROM   role_mapping AS RM
       INNER JOIN movie AS M
               ON M.id = RM.movie_id
       INNER JOIN ratings AS R USING(movie_id)
       INNER JOIN names AS N
               ON N.id = RM.name_id
WHERE  R.median_rating >= 8
AND category = 'ACTOR'
GROUP  BY actor_name
ORDER  BY movie_count DESC
)
Select actor_name, movie_count
FROM top_actors 
where row_num <=2;

-- We see top 2 actors are Mammootty and Mohanlal with median rating >= 8

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

WITH top_prod_house AS
(SELECT production_company, 
		sum(total_votes) AS vote_count,
	    RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM movie M
INNER JOIN ratings R 
ON R.movie_id=M.id
GROUP BY production_company
)
SELECT production_company, vote_count, prod_comp_rank
FROM top_prod_house
WHERE prod_comp_rank <= 3 ;



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

WITH top_actor AS 
(SELECT N.NAME AS actor_name,
                total_votes,
                Count(R.movie_id) AS movie_count,
                Round(Sum(avg_rating * total_votes) / Sum(total_votes)) AS actor_avg_rating
FROM movie  M
INNER JOIN ratings  R
	ON M.id = R.movie_id
INNER JOIN role_mapping  RM
	ON M.id = RM.movie_id
INNER JOIN names  N
	ON RM.name_id = N.id
WHERE  category = 'ACTOR'
AND country = "india"
GROUP  BY name
 HAVING movie_count >= 5)
SELECT *, Rank()OVER(ORDER BY actor_avg_rating DESC) AS actor_rank
FROM   top_actor
ORDER BY total_votes DESC; 

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

WITH top_acctress AS
( SELECT N.NAME AS actress_name,
         total_votes,
         COUNT(R.movie_id) AS movie_count,
		 ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actress_avg_rating,
         Rank() OVER(ORDER BY ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) DESC) AS actress_rank
FROM movie M
     INNER JOIN ratings R
           ON M.id=R.movie_id
     INNER JOIN role_mapping RM
           ON  M.id = RM.movie_id
     INNER JOIN names AS N
           ON RM.name_id = N.id
     WHERE category = 'ACTRESS'
     AND country = "INDIA"
     AND languages LIKE '%HINDI%'
     GROUP BY NAME
     HAVING movie_count >= 3 
)
SELECT   * FROM top_acctress where actress_rank < 6;


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

WITH thriller_movies_category AS
(SELECT DISTINCT(title),
                 avg_rating
FROM   movie AS M
       INNER JOIN ratings AS R
             ON R.movie_id = M.id
       INNER JOIN genre AS G 
             USING (movie_id)
       WHERE  genre LIKE 'THRILLER')
SELECT *,
       CASE
         WHEN avg_rating > 8 THEN 'Superhit movies'
         WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
         WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
         ELSE 'Flop movies'
       END AS avg_rating_category
FROM   thriller_movies_category; 


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

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

SELECT genre,
		ROUND(AVG(duration)) AS avg_duration,
        SUM(ROUND(AVG(duration))) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
        AVG(ROUND(AVG(duration))) OVER(ORDER BY genre ROWS 10 PRECEDING) AS moving_avg_duration
FROM movie M
INNER JOIN genre G
ON M.id= G.movie_id
GROUP BY genre
ORDER BY genre;


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

WITH top_genres AS
(
           SELECT     genre,
                      Count(m.id) AS movie_count ,
                      Rank() OVER(ORDER BY Count(m.id) DESC) AS genre_rank
           FROM       movie M
           INNER JOIN genre G
           ON         G.movie_id = M.id
           INNER JOIN ratings R
           ON         R.movie_id = M.id
           WHERE      avg_rating > 8
           GROUP BY   genre limit 3 ),
movie_summary AS
(
           SELECT     genre,
                      year,
                      title AS movie_name,
                      CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10)) AS worlwide_gross_income ,
                      DENSE_RANK() OVER(partition BY year ORDER BY CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10))  DESC ) AS movie_rank
           FROM       movie M 
           INNER JOIN genre G
           ON         M.id = G.movie_id
           WHERE      genre IN(SELECT genre FROM   top_genres)
		   GROUP BY   movie_name
)
SELECT *
FROM   movie_summary
WHERE  movie_rank<=5
ORDER BY YEAR;


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

WITH TOP_PRODUCTION_COMPANY AS
(
SELECT production_company,
	   Count(*) AS movie_count,
       RANK()OVER(ORDER BY Count(*) DESC) AS prod_comp_rank
FROM   movie M
INNER JOIN ratings R
      ON R.movie_id = M.id
WHERE  median_rating >= 8
AND production_company IS NOT NULL
AND Position(',' IN languages) > 0
GROUP  BY production_company
 ORDER  BY movie_count DESC
 )
SELECT *       
FROM  TOP_PRODUCTION_COMPANY
where prod_comp_rank<3;



-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


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

WITH TOP_ACTRESS AS
(
SELECT     N.NAME AS actress_name,
		   SUM(total_votes) AS total_votes,
		   Count(R.movie_id) AS movie_count,
		   Round(Sum(avg_rating * total_votes)/Sum(total_votes),2) AS actress_avg_rating,
           Rank() OVER(ORDER BY Count(R.movie_id) DESC) AS actress_rank,
           ROW_NUMBER() OVER(ORDER BY Count(R.movie_id) DESC) AS actress_row_num
FROM movie M
INNER JOIN ratings R
		ON M.id=R.movie_id
INNER JOIN role_mapping RM
		ON M.id = RM.movie_id
INNER JOIN names N
		ON RM.name_id = N.id
INNER JOIN genre AS G
		ON G.movie_id = M.id
WHERE category = 'ACTRESS'
AND avg_rating>8
AND genre = "Drama"
GROUP BY   NAME 
)
SELECT actress_name, total_votes, movie_count, actress_avg_rating, actress_rank FROM TOP_ACTRESS WHERE actress_row_num <= 3;


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

WITH TOP_DIRECTORS AS
( WITH INTERVAL_IN_MOVIES AS
( SELECT 
	M.id as movie_id,
    N.id as name_id,
    N.name,
    R.avg_rating,
    R.total_votes,
    M.duration,
    M.date_published,
    LEAD(M.date_published,1) OVER(W1) as Next_publish_date,
    DATEDIFF(LEAD(M.date_published,1) OVER(W1),date_published) as Release_Interval
FROM movie M
INNER JOIN director_mapping DM
	  ON M.id=DM.movie_id
INNER JOIN names as N
	  ON N.id=DM.name_id
INNER JOIN ratings R
	  ON R.movie_id=M.id
WINDOW W1 AS (PARTITION BY N.name ORDER BY M.date_published,M.id)
)
SELECT 
		name_id as director_id,
        name as director_name,
        COUNT(movie_id) as number_of_movies,
        AVG(Release_Interval) as avg_inter_movie_days,
        ROUND(SUM(avg_rating * total_votes)/SUM(total_votes),2) as avg_rating,
        SUM(total_votes) as total_votes,
        MIN(avg_rating) as min_rating,
        MAX(avg_rating) as max_rating,
        SUM(duration) as total_duration,
        ROW_NUMBER()OVER(ORDER BY COUNT(movie_id) DESC) AS director_row_num
FROM INTERVAL_IN_MOVIES
GROUP BY name
ORDER BY COUNT(movie_id) desc
)
SELECT  director_id,
		director_name,
        number_of_movies,
        avg_inter_movie_days,
        avg_rating,
        total_votes,
        min_rating,
        max_rating,
        total_duration
FROM TOP_DIRECTORS where director_row_num < 10;