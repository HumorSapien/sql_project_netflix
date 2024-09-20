-- Netflix Project

CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);

select * from netflix;

select count(*) from netflix;

select type, count(*)
from netflix
group by type;

--Business problems

-- 1.Count the number of movies and tv shows
select type,
count(*)
from netflix
group by 1;

-- 2. List all movies released in year 2020
select * 
from netflix
where release_year = '2020' and type='Movie';

-- 3. Find the top 5 countries with most content on Netflix
select * 
from
	(
		select 
		unnest(string_to_array(country, ',')) as country,
		count(*) as total_content
		from netflix
		group by 1
	)as t

where country is not null
order by total_content desc
limit 5;
	
-- 4. Identify the longest movie
select *
from netflix
where type = 'Movie' and  duration is not null
order by split_part(duration, ' ', 1)::int desc
limit 1;

-- 5. Find the content added in last 5 years
select * 
from netflix
where to_date(date_added, 'Month DD, YYYY') >= current_date - Interval '5 years';

--6. Find All Movies/TV Shows by Director 'Steven Spielberg'
select *
from 
	(
		select *,
		unnest(string_to_array(director, ',')) as director_name
		from netflix
	) as t1
where director_name = 'Steven Spielberg';


--7. List all tv season that have more than 5 season
select *
from netflix
where type = 'TV Show' and 
split_part(duration, ' ', 1)::int > 5;

-- 8. Count the number of content items in each genre
SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1
order by total_content desc;

-- 9. List All Movies that are Documentaries
select * 
from netflix
where listed_in like '%Documentaries' ;

-- 10. Find all content without a director
select *
from netflix
where director is null;

-- 11. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

select *
from
	(select *,
	unnest(string_to_array(casts, ',')) as actor
	from netflix) as t2
where actor = 'Salman Khan' and
release_year > extract(year from current_date) -10

-- 12.  Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
select 
unnest(string_to_array(casts, ',')) as actors,
count(*) as total_content
from netflix
where country= 'India'
group by 1
order by total_content desc
limit 10;

-- 13. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;