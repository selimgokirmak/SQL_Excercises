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


-- Find the Ratio of male and female athletes participated in all olympic games.


























































