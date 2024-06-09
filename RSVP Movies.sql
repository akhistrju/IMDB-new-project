USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

-- We do count of each table to find the Number of Rows:

select count(*) from director_mapping;
-- we have 3867 rows in the director_mapping table. 

select count(*) from genre;
-- we have 14662 rows from the genre table. 

select count(*) from movie;
-- we have 7997 rows in the movie table. 

select count(*) from names;
-- we have 25735 rows in the names table. 

select count(*) from ratings;
-- we have 7997 rows in the ratings table.alter

select count(*) from role_mapping
-- we have 15615 rows in the role_mapping table. 

-- Q2. Which columns in the movie table have null values?
-- Type your code below:
-- the effective approach to find the nulls in the movie table is to write a sub query and we can do that as below:

select
(select count(*) from movie where id is null) as id, 
(select count(*) from movie where title is null) as title,
(select count(*) from movie where year is null) as year,
(select count(*) from movie where date_published is null) as date_published,
(select count(*) from movie where duration is null) as duration,
(select count(*) from movie where country is null) as country,
(select count(*) from movie where worlwide_gross_income is null) as worlwide_gross_income,
(select count(*) from movie where languages is null) as languages,
(select count(*) from movie where production_company is null) as production_company
;

-- from the above query we can find that 
-- id column has 0 null values
-- title column has 0 null values
-- year column has 0 null values
-- date_published has 0 null values
-- duration has 0 null values
-- country has 20 null values,
-- worlwide_gross_salary has 3724 null values
-- languages has 194 null values,
-- production_company has 528 null values. 

/*---------------------------------------------

-- Now as you can see four columns of the movie table has null values. Let's look at the movies released each year. 
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

-- we can do this using the movie table taking year and title columns.
select year, 
	   count(title) as no_of_movies
from movie
group by year;
 -- for the output, I have found that; 
 # year	no_of_movies
-- 2017	 3052 movies were released
-- 2018	 2944 movies were released
-- 2019	 2001 movies were released.

-- Now for month wise movie released we can take date_published column 
select month(date_published) as month_released,
	count(*) as no_of_movies
from movie
group by month_released
order by month_released;

-- we can find by the output that in the month of March there were the highest number of movies released that is 824
-- And in the month of december the least number of movies are released that is 438.

-- from the above query we can find that the trend of movies has been decreasing from 2017 to 2019 when 2019 being the lowest for movie releases
-- and 2017 being the highest releases


/*So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
-- to find this we can use the like Operator for Indian and USA

select count(distinct id) as no_of_movies, year
from movie
where (upper(country) like '%INDIA%' or upper(country) like '%USA%' ) 
and year = 2019;

/* for the above query I got an output of "1059" movies that are released both in India or USA in the year 2019 */


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

-- to do this we can use distinct function in the genre table. 

select distinct genre from genre;

-- from the above query there are "13" genres that are retrieved. 


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year? "YES"
Combining both the movie and genres table can give more interesting insights.  "SURE" */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

-- Let us now see how we can join the movie and genre tables to find highest number of movies genre wise. 

select g.genre, count(m.id) as no_of_movies
from movie m 
inner join genre g
where g.movie_id = m.id
group by genre
order by no_of_movies desc;

-- from the output it is clear that the genre "Drama" has the highest number of movies released that is "4285" 
-- we can also further optimise the query by limiting the output to 1 and we can just get the top genre with highest movies released. 



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

select genre_count, count(movie_id) movie_count
from (select movie_id, count(genre) genre_count
		from genre
		group by movie_id
		order by genre_count desc) genre_counts
where genre_count = 1
group by genre_count;

-- I have used sub query for finding the movies from 1 genre. 
-- as we know 1 movie can have mulple genres, I have grouped by the movie_id and found the count of the genre of that result aquired. 
-- we got "3289" movies that has 1 genre


/* So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’.*/

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
-- we can use jojns for the query again

select genre, 
	   round(avg(duration), 2) as avg_duration_of_movie
from movie m 
inner join genre g
on g.movie_id = m.id
group by genre
order by avg_duration_of_movie desc;

/* as we can see from the out put 
Action	112.88
Romance	109.53
Crime	107.05
Drama	106.77
Fantasy	105.14
Comedy	102.62
Adventure	101.87
Mystery	101.80
Thriller	101.58
Family	100.97
Others	100.16
Sci-Fi	97.94
Horror	92.72
... so on are the average duration for each movie genre wise.
we can also understand that horror genere has the least average duration which is 92.72 and Action has the highest average duration which is 112.88 */



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

with genre_summary as 
( 
	select genre, count(movie_id) as no_of_movies,
    rank() over(order by count(movie_id) desc) as genre_rank
    from genre
    group by genre
    )
select * from genre_summary
where genre = "THRILLER" ;

/* by using the views wecan see that thriller is on rank 3 
genre	no_of_movies	genre_rank
Thriller	1484		3
*/



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

-- we can do the above question by using min and max operatios to find median

select 
	min(avg_rating) min_avg_rate,
    max(avg_rating) max_avg_rate,
    min(total_votes) min_total_votes,
    max(total_votes) max_total_votes,
    min(median_rating) min_median_rate,
    max(median_rating) max_median_rate
from ratings;

/* the output we got is 
# min_avg_rate	max_avg_rate	min_total_votes	max_total_votes	min_median_rate	max_median_rate
1.0				10.0			100				725138			1				10

so wecan see that the minimum votes are 100 and the maximum votes are 725138. */

    

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

select title, avg_rating, 
		dense_rank() over(order by avg_rating desc) as Rank_of_movie
from ratings r
inner join movie m
on m.id = r.movie_id limit 10;

/* with the above query we can see that "kirket" and "Love in Kilnerry" has the highest rating that is 10.0 and the lowest
rating is given to the movie "Shibu" which has 9.4 rating */



/* Do you find your favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
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

select median_rating,
       Count(movie_id) AS movie_count
from ratings
group by median_rating
order by movie_count desc;

/* the output for the above is 
7	2257
6	1975
8	1030
5	985
4	479
9	429

 Movies with a median rating of 7 is highest in number. */



/*Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

select production_company,
	count(movie_id) movie_count,
    dense_rank() over(order by count(movie_id) desc) as prod_company_rank
from ratings r
	inner join movie m
    on m.id = r.movie_id
where avg_rating > 8
and production_company is not null
group by production_company; 


/* i have used not null function as the movie table has a lot of null values and more that 500 null values are coming from the production_company column. 
so to skew the results not null fuction is the best option */
/* we can see for the below output that "Dream Warrior Pictures" and "National Theatre Live" has the most number of hit movies that are 
3 movies with average rating of > 8 */ 



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

select genre,
       Count(m.id) movie_count
from movie m
     inner join genre g
           on g.movie_id = m.id
     inner join ratings r
           on r.movie_id = m.id
where year = 2017
	  and month(date_published) = 3
	  and country like '%USA%'
	  and total_votes > 1000
group by genre
order by movie_count desc;

/* out put for the above is 
# genre	movie_count
Drama	24
Comedy	9
Action	8
Thriller	8
Sci-Fi	7
Crime	6
Horror	6
*/

/* we can see that there were 24 movies released during march 2017 in the genre "Drama". which means that people are not that keen in other genre
and Drama is the most appreciated genre. */


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


select title, avg_rating, genre
from movie m
     inner join genre g
           on g.movie_id = m.id
     inner join ratings r
               on r.movie_id = m.id
where avg_rating > 8
	  and title like 'THE%'
order by avg_rating desc;

/* for the above code we got output as 

# title	avg_rating	genre
The Brighton Miracle	9.5	Drama
The Colour of Darkness	9.1	Drama
The Blue Elephant 2	8.8	Drama
The Blue Elephant 2	8.8	Horror
The Blue Elephant 2	8.8	Mystery
The Irishman	8.7	Crime
The Irishman	8.7	Drama
.... so on. 
we can see that all the movies with their genre and the rating above 8 is retrieved. */

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

select 
   median_rating,
Count(*) movie_count
from movie m inner join 
     ratings r on r.movie_id = m.id
where median_rating = 8
	  and date_published between '2018-04-01' and '2019-04-01'
group by median_rating;

/* with the above code we can say that there are 361 movies released between 1 April 2018 and 1 April 2019 with a median rating of 8. */

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

-- we can use where operator by taking the sum of total votes and join the ratings ad movie tables. 
select 
   country, 
   sum(total_votes) tot_votes
from movie m
	inner join ratings r
          on m.id=r.movie_id
where lower(country) = 'germany' or lower(country) = 'italy'
group by country;
-- I have used the upper and lower to take all kinds of strings as there is a possibility of case sensitivity.
/* the output is 
# country	tot_votes
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
-- this time i have used a case when statement instead of subquery as there are only 4 columns to retrive data .

select Sum(CASE
             WHEN name IS NULL THEN 1
             ELSE 0
           END) name_null,
       Sum(CASE
             WHEN height IS NULL THEN 1
             ELSE 0
           END) height_null,
       Sum(CASE
             WHEN date_of_birth IS NULL THEN 1
             ELSE 0
           END) date_of_birth_null,
       Sum(CASE
             WHEN known_for_movies IS NULL THEN 1
             ELSE 0
           END) known_for_movies_null
from names;

/* the output is as follows
name_null	height_null	date_of_birth_null	known_for_movies_null
0			17335			13431			15226

and we can see taht there are 0 null values in the names columns but there are 17335 records null in the height column of names table. 
*/

/* 
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
-- here I am using inner joins along with the help of views so the operations can be performed on the view. 

with top_3_genres
 as (
    select genre,
	   Count(m.id) movie_count ,
	   Rank() OVER(order by Count(m.id) desc) rank_of_genre
    from movie m
	   inner join genre as g
			 on g.movie_id = m.id
	   inner join ratings r
			 on r.movie_id = m.id  
    where avg_rating > 8
    group by genre limit 3 
    )
select 
    n.name name_of_director,
	Count(dm.movie_id) No_of_movie
from director_mapping dm
       inner join genre g using (movie_id)
       inner join names n
       on n.id = dm.name_id
       inner join top_3_genres using (genre)
       inner join ratings using (movie_id)
where avg_rating > 8
group by name
order by No_of_movie desc limit 3 ;

/* here I have joined director_mapping to fetch the director name and genre to get the number of movies under that direct
I have also joined ratings table to find the movies above 8 rating and ranked them on desc order to find the top 3 directors and their top 3
favourite genres.
the output is 
name_of_director No_of_movie
James Mangold	 4
Anthony Russo	 3
Soubin Shahir	 3
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
-- again I am using inner join to join names, role_mapping, movie, & ratings to fetch the top 2 actors

select 
   n.name actor_name,
       Count(movie_id) movie_count
from role_mapping rm
       inner join movie m
             on m.id = rm.movie_id
       inner join ratings r using(movie_id)
       inner join names n
             on n.id = rm.name_id
where r.median_rating >= 8
	 and category = 'actor'
group by actor_name
order by movie_count desc limit 2;

/* the output for the above code is 
# actor_name	movie_count
Mammootty	8
Mohanlal	5
and we can see that mammootty and mohanlal are the top two actors who has median ratings more than 8 and they have 8 and 5 movies respectively 
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
-- another query of inner join where I have taken the sum of total votes and ranking them by joining ratings and movie table.

select 
   production_company,
   Sum(total_votes) no_of_votes,
   Rank() OVER(order by Sum(total_votes) desc) production_comp_rank
from movie m
inner join ratings r
	  on r.movie_id = m.id
group by production_company limit 3;

/* the output for the above is 
production_company		no_of_votes	production_comp_rank
Marvel Studios			2656967		1
Twentieth Century Fox	2411163		2
Warner Bros.			2396057		3

we can see that Marvel studios is the number one production company. 


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

with actor_summary
     as (select n.name as actor_name, total_votes,
                count(r.movie_id) as movie_count,
                round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) as actor_avg_rating
         from movie m
                inner join ratings r
                      on m.id = r.movie_id
                inner join role_mapping rm
					  on m.id = rm.movie_id
                inner join names n
                        on rm.name_id = n.id
         where category = "actor"
                and country = "india"
        group by actor_name, total_votes
         having movie_count >= 5)
select *, rank() OVER(order by actor_avg_rating desc) actor_rank
from actor_summary;
/* similarly I have used views and calculated the average rating for the actor by taking total votes. I have also joined ratings
role_mapping to ge the movies of the actor and the names table to get the actors data. 

-- from the above query wecan see that Vijay Sethupathi, Fahadh Faasil and Yogi Babu are top 3 actors in respective order. 


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

with actress_detail
	 as(
       select 
          n.name actress_name, total_votes,
		  count(r.movie_id) movie_count,
		  round(Sum(avg_rating*total_votes)/Sum(total_votes),2) as actress_avg_rating
        from movie as m
             inner join ratings r
                   on m.id = r.movie_id
			 inner join  role_mapping rm
                   on  m.id = rm.movie_id
			 inner join  names n
                   on rm.name_id = n.id
	    where upper(category) = 'ACTRESS'
              and upper(country) = "INDIA"
              and upper(languages) like '%HINDI%'
	   group by n.name
	   having movie_count>=3 
       )
select *,
         Rank() OVER(order by actress_avg_rating desc) as actress_rank
from actress_detail limit 5;



/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

with thriller_movies as (
    select  
       distinct title, 
       avg_rating
    from movie as mov inner join ratings as rat
         on mov.id = rat.movie_id 
         inner join genre as gen on gen.movie_id = mov.id
	where genre like 'THRILLER')
select *, 
       case 
         when avg_rating > 8 then 'superhit movies'
         when avg_rating between 7 and 8  then 'Hit movies'
         when avg_rating between 5 and 7 then 'one-time-watch movies'
         else 'Flop movies'
		end as avg_rating_category
from thriller_movies ;
  
/* here I have used the case when statements and the output is as below


title			avg_rating	avg_rating_category
Der müde Tod		7.7			Hit movies
Fahrenheit 451		4.9			Flop movies
Pet Sematary		5.8			one-time-watch movies
Dukun				6.9			one-time-watch movies
Back Roads			7.0			Hit movies
Countdown			5.4			one-time-watch movies
... so on */

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


select genre,
       round(avg(duration),2) avg_duration,
       sum(round(avg(duration),2)) OVER(order by genre rows unbounded preceding) running_total_duration,
       round(avg(avg(duration)) OVER(order by genre rows 10 preceding),2) as moving_avg_duration
from movie m 
inner join genre g on m.id= g.movie_id
group by genre
order by genre;

/* I have used lagand led functions to find out the running total and moving average for the duration column in genre table. 
output is 
genre	avg_duration	running_total_duration	moving_avg_duration
Action		112.88			112.88					112.88
Adventure	101.87			214.75					107.38
Comedy		102.62			317.37					105.79
Crime		107.05			424.42					106.11
Drama		106.77			531.19					106.24
Family		100.97			632.16					105.36
Fantasy		105.14			737.30					105.33
... so on. */



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

WITH top_3_genres 
     AS( SELECT genre,
                Count(m.id) AS movie_count ,
                Rank() OVER(ORDER BY Count(m.id) DESC) AS genre_rank
         FROM movie AS m
              INNER JOIN genre AS g
                     ON g.movie_id = m.id
              INNER JOIN ratings AS r
                     ON r.movie_id = m.id
         GROUP BY genre limit 3 ), movie_summary 
     AS( SELECT genre, year,
                title AS movie_name,
                CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10)) AS worlwide_gross_income ,
                DENSE_RANK() OVER(partition BY year ORDER BY CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10))  DESC ) AS movie_rank
         FROM movie AS m
              INNER JOIN genre AS g
                    ON m.id = g.movie_id
         WHERE genre IN
         ( SELECT genre FROM top_3_genres)
         GROUP BY   movie_name
          )
SELECT * FROM   movie_summary
WHERE  movie_rank<=5
ORDER BY YEAR;


/* the above query is again a use of joins and a little calculation for the worlwide_gross_income. I have also used dence rank to find the 
top 5 movies for each of the top 3 genres. 


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

WITH production_company_detail
     AS (SELECT production_company,
                Count(*) AS movie_count
         FROM movie AS mov
                INNER JOIN ratings AS rat
		      ON rat.movie_id = mov.id
         WHERE median_rating >= 8
	       AND production_company IS NOT NULL
               AND Position(',' IN languages) > 0
         GROUP BY production_company
         ORDER BY movie_count DESC)
SELECT *,
       Rank() over( ORDER BY movie_count DESC) AS prod_comp_rank
FROM production_company_detail LIMIT 2;

/*from the above query we can find that Star Cinema and Twentieth Century Fox are
the top 2 production houses that have produced the highest number of hits.
production_company	movie_count	prod_comp_rank
Star Cinema				7			1
Twentieth Century Fox	4			2
 */


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


WITH actress_summary 
     AS( SELECT n.name AS actress_name,
                SUM(total_votes) AS total_votes,
		Count(r.movie_id) AS movie_count,
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
	WHERE lower(category) = 'actress'
              AND avg_rating>8
              AND lower(genre) = "drama"
	GROUP BY name )
SELECT *,
	   Rank() OVER(ORDER BY movie_count DESC) AS actress_rank
FROM actress_summary LIMIT 3;

/* from the above query the out put is 
actress_name	total_votes	movie_count	actress_avg_rating	actress_rank
Parvathy Thiruvothu	4974		2			8.25				1
Susan Brown			656			2			8.94				1
Amanda Lawrence		656			2			8.94				1

*/



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


WITH next_date_published_detail
     AS( SELECT d.name_id, name, d.movie_id, duration, r.avg_rating, total_votes, m.date_published,
                Lead(date_published,1) OVER(partition BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
          FROM director_mapping d
               INNER JOIN names n
                     ON n.id = d.name_id
               INNER JOIN movie m
                     ON m.id = d.movie_id
               INNER JOIN ratings r
                     ON r.movie_id = m.id ), top_director_summary AS
( SELECT *,
         Datediff(next_date_published, date_published) AS date_difference
  FROM   next_date_published_detail )
SELECT   name_id AS director_id,
         name AS director_name,
         Count(movie_id) AS number_of_movies,
         Round(Avg(date_difference),2) AS avg_inter_movie_days,
         Round(Avg(avg_rating),2) AS avg_rating,
         Sum(total_votes) AS total_votes,
         Min(avg_rating) AS min_rating,
         Max(avg_rating) AS max_rating,
         Sum(duration) AS total_duration
FROM top_director_summary
GROUP BY director_id
ORDER BY Count(movie_id) DESC limit 9;

/* the output for the above is 
# director_id	director_name	number_of_movies	avg_inter_movie_days	avg_rating	total_votes	min_rating	max_rating	total_duration
nm2096009		Andrew Jones		5					190.75					3.02		1989		2.7			3.2			432
nm1777967		A.L. Vijay			5					176.75					5.42		1754		3.7			6.9			613
nm0814469		Sion Sono			4					331.00					6.03		2972		5.4			6.4			502
nm0831321		Chris Stokes		4					198.33					4.33		3664		4.0			4.6			352
nm0515005		Sam Liu				4					260.33					6.23		28557		5.8			6.7			312
nm0001752		Steven Soderbergh	4					254.33					6.48		171684		6.2			7.0			401


... so on! */
