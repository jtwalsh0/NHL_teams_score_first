/*  Joe Walsh
	March 12, 2015  */


-- Identify the winner and loser and whether the game was decided after regulation
-- Only look at 2005-2006 and after, when ties were eliminated (earlier comparisons not equal)
-- Only look at the first 1010 games of the regular season, so the comparison for Boston is fair 
create temporary table hockey_temp as 
	select c.* from (
		select	season, gcode, max(event) 
		from 	hockey.events 
		where 	home_score != away_score and seconds > 2400 and 
				season::int >=20052006 and gcode::int > 20000 and gcode::int < 21010 
		group by season, gcode) as b, 
	   (select 	*, 
	   			case when home_score > away_score then hometeam else awayteam end as winner, 
	   			case when home_score < away_score then hometeam else awayteam end as loser, 
	   			case when seconds > 3600 then 1 else 0 end as ot 
	   	from hockey.events 
	   	where seconds > 2400 and season::int >=20052006 and gcode::int > 20000 and gcode::int < 21010) as c 
	where b.season = c.season and b.gcode = c.gcode and b.max = c.event;


-- Identify the first team to score and merge with the hockey_temp table
create table hockey.first_goal as 
	select 	a.season, a.gcode, a.first_team, d.winner, d.loser, d.ot 
	from 	(select season, gcode, ev_team as first_team 
			 from hockey.events 
			 where etype = 'GOAL' and home_score = 0 and away_score = 0) as a, 
			hockey_temp as d 
	where a.season = d.season and a.gcode = d.gcode;


-- Count wins, losses, OTs for each team each season when scoring first and when not scoring first
-- I use the percentage of points that the team obtained (e.g. first_percent, not_percent)
create table first_goal_results as 
	select 	a.season, a.winner, 
			a.count as first_w, b.count as first_l, c.count as first_ot, 
			d.count as not_w, e.count as not_l, f.count as not_ot, 
			(a.count + .5*c.count) / (a.count + b.count + c.count) as first_percent, 
			(d.count + .5*f.count) / (d.count + e.count + f.count) not_percent, 
			(a.count + .5*c.count) / (a.count + b.count + c.count) - (d.count + .5*f.count) / (d.count + e.count + f.count) as perc_diff 
	from 	(select season, winner, count(*) 
			 from hockey.first_goal 
			 where first_team = winner 
			 group by season, winner) as a, 
			(select season, loser, count(*) 
			 from hockey.first_goal 
			 where first_team != winner and ot = 0 
			 group by season, loser) as b, 
			(select season, loser, count(*) 
			 from hockey.first_goal 
			 where first_team != winner and ot = 1 
			 group by season, loser) as c, 
			(select season, winner, count(*) 
			 from hockey.first_goal 
			 where first_team != winner 
			 group by season, winner) as d, 
			(select season, loser, count(*) 
			 from hockey.first_goal 
			 where first_team = winner and ot = 0 
			 group by season, loser) as e, 
			(select season, loser, count(*) 
			 from hockey.first_goal 
			 where first_team = winner and ot = 1 
			 group by season, loser) as f 
	where 	a.season = b.season and a.season = c.season and a.season = d.season and a.season = e.season and a.season = f.season and 
			a.winner = b.loser and a.winner = c.loser and a.winner = d.winner and a.winner = e.loser and a.winner = f.loser 
	order by perc_diff desc;
