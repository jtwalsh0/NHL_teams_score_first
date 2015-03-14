# How Likely Are NHL Teams to Win If They Score First?

This repository contains the code and results of an analysis to determine whether scoring first is especially important to the 2014-2015 Boston Bruins.

On March 11, 2015, Greg Wyshinski of Yahoo's [Puck Daddy](http://sports.yahoo.com/blogs/nhl-puck-daddy/) blog noted that the Bruins have a far better record when they score first than when they don't:

![Wyshinski tweet](https://raw.githubusercontent.com/jtwalsh0/NHL_teams_score_first/master/Wyshinski_tweet.png)

This reminds me of a TSN tweet from a couple years ago:

![TSN tweet](https://raw.githubusercontent.com/jtwalsh0/NHL_teams_score_first/master/TSN_tweet.png)

Neither tweet gave a baseline for comparison, and without context, the numbers sound more impressive than they are. 

Goals are hard to come by in hockey. Each time a team scores, its probability of winning increases. This is true when scoring the first time (Wyshinski's tweet) or the fourth time (TSN's tweet). 

I collected data using [A.C. Thomas](https://twitter.com/acthomasca) and [Sam Ventura](https://twitter.com/stat_sam)'s [nhlscrapR](http://cran.r-project.org/web/packages/nhlscrapr/index.html) package and stored it in a Postgres server. For fair comparisons, I only used games starting in the 2005-2006 season, when the NHL eliminated ties, and the first 1,010 games of each regular season (Nashville and San Jose will play the [1,012th game](http://www.nhl.com/gamecenter/en/preview?id=2014021012) of the regular season tonight.)

This repository contains the SQL queries that I used to generate the results. The first query identifies the winner and loser and whether the game was decided after regulation; the second query adds the team that scores first; and the third query counts wins, losses, and OT wins for each team in each season by whether that team scored first.

Are the Bruins especially good when scoring first?  No. Of the 30 teams in the NHL, 22 have a bigger win gap between when they score first and when they don't. The biggest gap the Bruins have posted, 42.8% in 2007-2008, barely makes the top 75 win gaps in the dataset (out of more than 230).

This confirms that, for most teams, scoring the first goal has a huge impact on who wins.

Another note of interest: the 2014-2015 NY Islanders are the only team that post a higher winning percentage when their opponent scores the first goal.