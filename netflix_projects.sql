select * from netflix;


--1.count the number of movies vs tv shows

select type,count(*)
from netflix
group by type;

--2.find the most common rating for movies and TV shows.
select type,rating
from
(select type,rating,count(*),
rank() over(partition by type order by count(*) desc)as ranking from netflix group by type,rating)as T1
where ranking=1;

--3.Name top 5 countries which deliver highest number of movies.
select trim(unnest(string_to_array(country,','))) as country,count(*) as number_of_movies
from netflix 
where type ilike 'movie'
group by country
order by number_of_movies desc
limit 5;

--4.find top 5 year which released higher number of movies.
select release_year,count(*) as total_number_of_movies
from netflix
where type ilike 'movie'
group by release_year
order by total_number_of_movies desc
limit 5;

select * from netflix
--5.find top 5 most common genre on netflix.

select trim(unnest(string_to_array(listed_in,','))) genre,
rank() over(order by count(*) desc) as ranking
from netflix
group by genre
order by count(*) desc
limit 5;

--6.find top 5 productive director.

select trim(unnest(string_to_array(director,','))) as director,
count(*)as total_movies,country
from netflix
group by director,country
order by total_movies desc
limit 5;

--7.find top 5 actors from United States who appeared in the highest number of movies.

select trim(unnest(string_to_array(casts,',')))actors
from netflix
where country Ilike 'united%' and type Ilike 'movie'
group by actors
order by count(*) desc
limit 5;

--8. find top 5 actors from United States who appeared in the highest number of TV Show.

select trim(unnest(string_to_array(casts,',')))actors
from netflix
where country Ilike 'United%' and type Ilike 'TV%'
group by actors
order by count(*) desc
limit 5;

--9.find top 5 actors from India who appeared in the highest number of Indian TV Show.
select trim(unnest(string_to_array(casts,',')))actors
from netflix
where country Ilike 'india' and type Ilike 'TV%'
group by actors
order by count(*) desc
limit 5;

--10.find top 5 actors from India who appeared in the highest number of Indian Movies.
select trim(unnest(string_to_array(casts,',')))actors
from netflix
where country Ilike 'india' and type Ilike 'movie'
group by actors
order by count(*) desc
limit 5;

--11.Identify the longest movie.

select title,duration from netflix
where type Ilike 'movie'
and duration=(select max(duration) from netflix);

--12.List all tv shows with more than 5 Seasons

select type,title
from netflix
where type ILike 'TV%'
AND SPLIT_PART(duration,' ',1)::numeric>5;

--13.Find each year and the average number of content released by India on netflix.return top 5 year with highest avg content.

select 
extract(year from to_date(date_added,'month dd,yyyy'))as year ,
count(*) as yearly_content,
Round(count(*):: numeric/(select count(*) from netflix where country Ilike'india')::numeric*100,2)as avg_content_per_year
from netflix
where country Ilike'india'
group by year
order by avg_content_per_year desc
limit 5;

--14.Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field.label content containing these keywords as 'not for children below 12'.
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