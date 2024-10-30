-- checking for any null values
SELECT *
FROM region_sales
WHERE region_id IS NULL 
	OR game_platform_id IS NULL 
	OR num_sales IS NULL;

-- creating table where each game and gerne are displayed as text
CREATE TABLE game_genre_names (
SELECT game.id AS game_id, game.game_name, genre.genre_name
FROM game
JOIN genre ON game.genre_id = genre.id
ORDER BY game.id
);

-- making a complete table with all available columns
CREATE TABLE total_list (
SELECT game_name, genre_name, platform_name, release_year , region_name, publisher_name, num_sales
FROM region_sales
JOIN game_platform ON region_sales.game_platform_id = game_platform.id
JOIN game_publisher ON game_platform.game_publisher_id = game_publisher.id
JOIN game_genre_names ON game_publisher.game_id = game_genre_names.game_id
JOIN publisher ON game_publisher.publisher_id = publisher.id
JOIN platform ON game_platform.platform_id = platform.id
JOIN region ON region_sales.region_id = region.id
);

SELECT *
FROM total_list
WHERE publisher_name LIKE 'N/A';	

-- overall sales
-- top games
SELECT game_name, SUM(num_sales) AS total_sales
FROM total_list
GROUP BY game_name
ORDER BY total_sales DESC
LIMIT 10;
-- top genre
SELECT genre_name, COUNT(*) AS N_titles, SUM(num_sales) AS total_sales, SUM(num_sales) / COUNT(*) AS avg_sales
FROM total_list
GROUP BY genre_name
ORDER BY total_sales DESC;
-- top region
SELECT region_name, SUM(num_sales) AS total_sales, SUM(num_sales) / COUNT(*) AS avg_sales
FROM total_list
GROUP BY region_name
ORDER BY total_sales DESC;
-- top conslole
SELECT platform_name, COUNT(*), SUM(num_sales) AS total_sales, SUM(num_sales) / COUNT(*) AS avg_sales
FROM total_list
GROUP BY platform_name
ORDER BY avg_sales DESC;
-- top publisher
SELECT publisher_name, COUNT(*), SUM(num_sales) AS total_sales, SUM(num_sales) / COUNT(*) AS avg_sales
FROM total_list
GROUP BY publisher_name HAVING COUNT(*) > 50
ORDER BY avg_sales DESC;

-- checking a specific game of interest
SELECT *
FROM total_list
WHERE game_name LIKE "Dark Souls%";


-- creating a table that groups the same game together on every aspect except region
CREATE TABLE total_by_region(
SELECT game_name, region_name, genre_name, SUM(num_sales) AS game_sales
FROM total_list
GROUP BY game_name, region_name, genre_name);
-- alternative way to search top games total for all regions
SELECT game_name, genre_name, SUM(game_sales) AS sales 
FROM video_games.total_by_region
GROUP BY game_name, genre_name
ORDER BY sales DESC;


-- researching rankings per region
-- top game per region
-- change region name to 'Europe', 'North America', 'Japan', 'Other' for stats on that region
SELECT ROW_NUMBER() OVER (ORDER BY SUM(num_sales) DESC) AS '#_rank', game_name, sum(num_sales) as total_sales
FROM total_list
WHERE region_name = 'Europe'
GROUP BY game_name
ORDER BY total_sales DESC
LIMIT 10;

-- top genres per region
SELECT ROW_NUMBER() OVER (ORDER BY SUM(num_sales) DESC) AS '#_rank', genre_name, sum(num_sales) as total_sales
FROM total_list
WHERE region_name = 'Europe'
GROUP BY genre_name
ORDER BY total_sales DESC;


-- total sales across all years/ games etc.
SELECT SUM(num_sales)
FROM total_list;


-- number of games released per year
WITH temp AS ( -- starting with this so i first group same name games together. Otherwise each game is counted multiple times
SELECT game_name, release_year
FROM total_list
GROUP BY game_name, release_year)
SELECT release_year, COUNT(*) AS number_released
FROM temp
GROUP BY release_year
ORDER BY release_year;

-- game per genre released per year
CREATE TABLE releases_by_year (
WITH temp AS (
SELECT game_name, release_year, genre_name
FROM total_list
GROUP BY game_name, release_year, genre_name)
SELECT release_year, genre_name, COUNT(*) AS N, SUM(COUNT(*)) OVER (PARTITION BY release_year) AS released_in_year
FROM temp
GROUP BY genre_name, release_year -- HAVING genre_name = 'Action'
ORDER BY release_year);

-- some quick checks for question that arised during graphing in tableau (even though japan's 3rd genre in sales was sports, there was no sport games to be found in the top 20)
select game_name, num_Sales from total_list where genre_name = 'sports' and region_name = 'japan' order by num_sales desc;
-- confirming there is no error in the value displayed in tableau
select region_name, genre_name, sum(game_sales) from total_by_region group by genre_name, region_name having genre_name = 'sports';




CREATE TABLE success (
WITH games AS
	(
	WITH recent_games AS 
		(
		SELECT game_name AS game, genre_name AS genre, platform_name AS platform, region_name AS region, publisher_name AS publisher, num_sales 
		FROM total_list
		WHERE release_year >= 2005
		)
	SELECT game, genre, platform, publisher, SUM(num_sales) AS sales
	FROM recent_games
	GROUP BY game, genre, platform, publisher
    )
SELECT 
	-- ROW_NUMBER() OVER (ORDER BY sales DESC) AS '#_rank',
	game, genre, platform, publisher, 
    -- sales, 
	CASE 
        WHEN sales > (SELECT AVG(sales) FROM games) THEN 'Successful'
        ELSE 'Not Successful' 
    END AS game_success
FROM games);