/*
select *
from olympics_history
order by Year
*/

-- How many olympics games have been held?
/*
select COUNT(Distinct Games) total_olympic_games
from olympics_history
*/


-- List down all Olympics games held so far.
/*
select Distinct Year, Season, City
from olympics_history
order by Year
*/


-- Mention the total no of nations who participated in each olympics game?
/*
select Games, count(Distinct NOC) total_countries
from olympics_history
group by Games
order by 1
*/


-- Which year saw the highest and lowest no of countries participating in olympics?
/*
select top 1 Games, total_countries
from ( select Games, count(Distinct NOC) total_countries
	   from olympics_history
	   group by Games ) sub
order by 2

select top 1 Games, total_countries
from ( select Games, count(Distinct NOC) total_countries
	   from olympics_history
	   group by Games ) sub
order by 2 desc
*/


-- Which nation has participated in all of the olympic games?
/*
with most_part_cte as (
	select NOC, COUNT(distinct Games) total_participated_games
	from olympics_history
	group by NOC
	having COUNT(distinct Games) = (select count(distinct Games) from olympics_history) )

select nr.region, mp.total_participated_games
from most_part_cte mp
join noc_regions nr
 on mp.NOC = nr.NOC
order by 1
*/


-- Identify the sport which was played in all summer olympics.
/*
select sport, count(distinct games) no_of_games,
	( select COUNT(distinct games)
	  from olympics_history
	  where Season = 'Summer' ) total_games
from olympics_history
where Season = 'Summer'
group by sport
having count(distinct games) = ( select COUNT(distinct games)
								 from olympics_history
								 where Season = 'Summer' )
order by 2 desc
*/


-- Which Sports were just played only once in the olympics?
/*
select Sport, COUNT(distinct games) no_of_games, 
	(select Distinct Games from olympics_history where Sport = oh.Sport) games
from olympics_history oh
group by Sport
having COUNT(distinct games) = 1
order by 1
*/


-- Fetch the total no of sports played in each olympic games.
/*
select Games, count(distinct Sport) no_of_sports
from olympics_history
group by Games
order by 2 desc
*/


-- Fetch oldest athletes to win a gold medal
/*
select *
from olympics_history
where Age = ( select MAX(age)
			  from olympics_history
			  where Medal = 'Gold' )
and Medal = 'Gold'
*/


-- Fetch the top 5 athletes who have won the most gold medals.
/*
select Name, Team, COUNT(*) total_gold_medals
from olympics_history
where Medal = 'Gold'
group by Name, Team
order by COUNT(*) desc, Name
offset 0 rows
fetch first 5 rows only
*/


-- Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).
/*
select Top 5 Name, Team, COUNT(*) total_medals
from olympics_history
where Medal in ('Gold', 'Silver', 'Bronze')
group by Name, Team
order by 3 desc, 1
*/


-- Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.
/*
select TOP 5 nr.region, COUNT(*) total_medals,
	RANK() OVER(order by COUNT(*) desc) rank_
from olympics_history oh
join noc_regions nr 
  on oh.NOC = nr.NOC
where Medal in ('Gold', 'Silver', 'Bronze')
group by nr.region
order by 2 desc
*/


-- List down total gold, silver and bronze medals won by each country.
/*
with medals_cte as (
	select nr.region, oh.Medal
	from olympics_history oh
	join noc_regions nr 
	  on oh.NOC = nr.NOC )
   
select region,
	(select COUNT(*) from medals_cte where region = mc.region and Medal = 'Gold') Gold,
	(select COUNT(*) from medals_cte where region = mc.region and Medal = 'Silver') Silver,
	(select COUNT(*) from medals_cte where region = mc.region and Medal = 'Bronze') Bronze
from medals_cte mc
where Medal <> 'NA'
group by region
order by 2 desc, 3 desc, 4 desc
*/


-- List down total gold, silver and bronze medals won by each country corresponding to each olympic games.
/*
with medals_cte as (
	select oh.games, nr.region, oh.Medal
	from olympics_history oh
	join noc_regions nr 
	  on oh.NOC = nr.NOC )
   
select games, region,
	(select COUNT(*) from medals_cte where region = mc.region and Games = mc.Games and Medal = 'Gold') Gold,
	(select COUNT(*) from medals_cte where region = mc.region and Games = mc.Games and Medal = 'Silver') Silver,
	(select COUNT(*) from medals_cte where region = mc.region and Games = mc.Games and Medal = 'Bronze') Bronze
from medals_cte mc
where Medal <> 'NA'
group by games, region
order by 1, 2
*/


-- Which countries have never won gold medal but have won silver/bronze medals?
/*
create view medals_view as 
with medals_cte as (
	select oh.games, nr.region, oh.Medal
	from olympics_history oh
	join noc_regions nr 
	  on oh.NOC = nr.NOC )
   
select games, region,
	(select COUNT(*) from medals_cte where region = mc.region and Games = mc.Games and Medal = 'Gold') Gold,
	(select COUNT(*) from medals_cte where region = mc.region and Games = mc.Games and Medal = 'Silver') Silver,
	(select COUNT(*) from medals_cte where region = mc.region and Games = mc.Games and Medal = 'Bronze') Bronze
from medals_cte mc
where Medal <> 'NA'
group by games, region


select region, sum(Gold) gold, sum(Silver) silver, sum(Bronze) bronze
from medals_view
group by region
having sum(Gold) = 0 and (sum(Silver) > 0 or sum(Bronze) > 0)
order by 3 desc
*/


-- In which Sport/event, India has won highest medals?
/*
select TOP 1 oh.Sport, COUNT(*) total_medals
from olympics_history oh
join noc_regions nr 
  on oh.NOC = nr.NOC
where nr.region = 'India' and oh.Medal <> 'NA'
group by oh.Sport
order by 2 desc
*/


-- Break down all olympic games where India won medal for Hockey and how many medals in each olympic games.
/*
select nr.region, oh.Sport, oh.Games, COUNT(*) total_medals
from olympics_history oh
join noc_regions nr 
  on oh.NOC = nr.NOC
where nr.region = 'India' and oh.Sport = 'Hockey' and Medal <> 'NA'
group by nr.region, oh.Sport, oh.Games
order by 4 desc
*/
