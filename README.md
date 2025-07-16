# Netflix Movies and TV Shows Data Analysis using SQL

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

### 2.find the most common rating for movies and TV shows.
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

### 3. Name top 10 countries which deliver highest number of movies.
```sql

select trim(unnest(string_to_array(country,','))) as country,
count(*) as number_of_movies
from netflix 
where type ilike 'movie'
group by country
order by number_of_movies desc
limit 10;
```
- to identify the top 10 countries with the highest number of content items

