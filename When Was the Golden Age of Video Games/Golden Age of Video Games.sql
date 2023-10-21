/* 
The ten best-selling video games
1. explore the top 400 best-selling video games created between 1977 and 2020
2. compare a dataset on game sales with critic and user reviews to determine whether or not video games have improved as the gaming market has grown
*/

--the top selling video games of all time
SELECT TOP 10 * 
FROM game_sales
ORDER BY Total_Shipped DESC;

-- missing review scores
SELECT COUNT(g.Name) AS num_of_missing_rev
FROM game_sales AS g
LEFT JOIN game_reviews AS r
ON g.Name = r.Name
WHERE Critic_Score IS NULL
    AND User_Score IS NULL;

-- the best years for video games
SELECT TOP 10 
	Year, 
	ROUND(AVG(Critic_Score), 2) AS avg_critic_score, 
	COUNT(g.Name) AS num_games
FROM game_sales AS g
INNER JOIN game_reviews AS r
ON g.Name = r.Name
GROUP BY Year
HAVING COUNT(g.Name) > 4
ORDER BY avg_critic_score DESC;

-- Years video game players loved
SELECT TOP 10 
	Year, 
	ROUND(AVG(User_Score), 2) AS avg_user_score, 
	COUNT(g.Name) AS num_games
FROM game_sales AS g
INNER JOIN game_reviews AS r
ON g.Name = r.Name
GROUP BY Year
HAVING COUNT(g.Name) > 4
ORDER BY avg_user_score DESC;

--  Years that both players and critics loved
SELECT c.year
FROM top_critic_scores_more_than_four_games AS c
INNER JOIN top_user_scores_more_than_four_games AS u
ON c.year = u.year

-- Sales in the best video game years 
SELECT 
	g.year, 
	ROUND(SUM(g.Total_Shipped), 2) AS total_games_sold
FROM game_sales AS g
WHERE g.year IN (
    SELECT c.year
FROM top_critic_scores_more_than_four_games AS c
INNER JOIN top_user_scores_more_than_four_games AS u
ON c.year = u.year)
GROUP BY g.year
ORDER BY total_games_sold DESC;
