# Netflix Content Engagement Data Analysis using SQL

![NETFLIX LOGO](https://github.com/jyoti7770/netflix_project/blob/main/The%20Hangover.jpeg)

## OVERVIEW
This project involves a comparehensive analysis of Netflix's Movies and TV Shows using content metadata with SQL.The goal is to analyze content trends to offer actionable insights that can shape content strategy.The following README provides a detailed account of the project's objectives,business problems,solutions,findings and conclusions.

## OBJECTIVES

- Analyze the distribution of content types.
- Identify the most common ratings for movies and Tv shows.
- Explore and Categorize content based on specific criteria and keywords.

## DATASET

The Data for this project is taken from kaggle dataset:

-**Dataset Link:**[Movies Dataset](https://www.kaggle.com/datasets/ozcanrec/netflix-analysis)

## Schema

```sql
drop table if exist netflix
create table netflix
(
 show_id varchar(7),
 type	 varchar(10),
 title	 varchar(150),
 director	varchar(208),
 casts	varchar(1000),
 country	varchar(150),
 date_added	varchar(50),
 release_year	int,
 rating	varchar(10),
 duration	varchar(15),
 listed_in	varchar(100),
 description varchar(250)
);
```

## Business Problems and Solutions

### 1.count the number of movies vs tv shows

```sql
select type,
count(*)
from netflix
group by type;
```
- To determine the distribution of content types on Netflix
  
![image](https://github.com/jyoti7770/netflix_project/blob/main/movies%20vs%20tv%20shows.png)

### 2.Find the most common rating for movies and TV shows.
```sql

select type,rating
from
(select type,rating,count(*),
rank() over(partition by type order by count(*) desc)as ranking
from netflix
group by type,rating)as T1
where ranking=1;
```
- To identify the most frequently occurring rating for each type of content.

![image](https://github.com/jyoti7770/netflix_project/blob/main/rating.png)

### 3.Name top 5 countries which deliver highest number of movies.
```sql

select trim(unnest(string_to_array(country,','))) as country,
count(*) as number_of_movies
from netflix 
where type ilike 'movie'
group by country
order by number_of_movies desc
limit 5;
```
- to identify the top 5 countries with the highest number of content items

![image](https://github.com/jyoti7770/netflix_project/blob/main/top%20countries.png)

### 4.Find top 5 year which released higher number of movies.
```sql

select release_year,count(*) as total_number_of_movies
from netflix
where type ilike 'movie'
group by release_year
order by total_number_of_movies desc
limit 5;
```
- to identify the movies demand over period of time

![image](https://github.com/jyoti7770/netflix_project/blob/main/top%20years.png)

### 5.Find top 5 most common genre on netflix.
```sql

select trim(unnest(string_to_array(listed_in,','))) genre,
rank() over(order by count(*) desc) as ranking
from netflix
group by genre
order by count(*) desc
limit 5;
```
- to identify which kind of content people are liking the most

![image](https://github.com/jyoti7770/netflix_project/blob/main/genre.png)

### 6.Find top 5 productive director.
```sql

select trim(unnest(string_to_array(director,','))) as director,
count(*)as total_movies
from netflix
group by director
order by total_movies desc
limit 5;
```
- to identify the demanding directors movies

![image](https://github.com/jyoti7770/netflix_project/blob/main/director.png)

### 7.Find top 5 actors from United States who appeared in the highest number of movies.
```sql
select trim(unnest(string_to_array(casts,',')))actors
from netflix
where country Ilike 'united%' and type Ilike 'movie'
group by actors
order by count(*) desc
limit 5;
```
- to identify the most demanding actors in united states for movies

![image](https://github.com/jyoti7770/netflix_project/blob/main/actor%20united%20states.png)

### 8.Find top 5 actors from United States who appeared in the highest number of TV Show.
```sql
select trim(unnest(string_to_array(casts,',')))actors
from netflix
where country Ilike 'United%' and type Ilike 'TV%'
group by actors
order by count(*) desc
limit 5;
```
- to identify the most demanding actors in united states for Tv shows

![image](https://github.com/jyoti7770/netflix_project/blob/main/tv%20shows%20actor%20united%20state.png)

### 9.Find top 5 actors from India who appeared in the highest number of Indian TV Show.
```sql
select trim(unnest(string_to_array(casts,',')))actors
from netflix
where country Ilike 'india' and type Ilike 'TV%'
group by actors
order by count(*) desc
limit 5;
```
- to identify the most demanding actors in india for movies

![image]()

### 10.Find top 5 actors from India who appeared in the highest number of Indian Movies.
```sql
select trim(unnest(string_to_array(casts,',')))actors
from netflix
where country Ilike 'india' and type Ilike 'movie'
group by actors
order by count(*) desc
limit 5;
```
- to identify the most demanding actors in india for tv shows

![image]()

### 11.Identify the longest movie.
```sql
select title,duration from netflix
where type Ilike 'movie'
and duration=(select max(duration) from netflix);
```
- to identify the movie having longest duration

![image]()

### 12.List all tv shows with more than 5 Seasons
```sql
select type,title
from netflix
where type ILike 'TV%'
AND SPLIT_PART(duration,' ',1)::numeric>5;
```
- to identify the tv shows more than 5 seasons

![image]() 

### 13.Find each year and the average number of content released by India on netflix.return top 5 year with highest avg content.
```sql
select 
extract(year from to_date(date_added,'month dd,yyyy'))as year ,
count(*) as yearly_content,
Round(count(*):: numeric/(select count(*) from netflix where country Ilike'india')::numeric*100,2)as avg_content_per_year
from netflix
where country Ilike'india'
group by year
order by avg_content_per_year desc
limit 5;
```
- to identify the avg number of content released by india on netflix

![image]()

### 14.Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field.label content containing these keywords as 'not for children below 12'.
```sql
with new_table
as
(
 select *,
 case
 when 
 description Ilike '%kill%' or
 description Ilike '%violence'or
 description Ilike '%sexual%' or
 description Ilike '%hot%'
 then 'Not for children below 12'
 else 'good_content'
 end category
 from netflix
)
select title,category
from new_table
group by title,category;
```
- to identify which content would not be good for children below age 12

![image]()

## Finding

- Content Distribution: The dataset contains a diverse range of movies and TV shows with varying ratings and genres.

- Common Ratings: Insights into the most common ratings provide an understanding of the content's target audience.

- Geographical Insights: The top countries and the average content releases by India highlight regional content distribution.

- Content Categorization: Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

## Conclusion

- This analysis offers a comprehensive view of the content and supports decision-making by identifying the types of content that can enhance user engagement on Netflix
  

