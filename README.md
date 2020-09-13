# Blaseball Status
## About
An attempt to replicate [Playoff Status](http://playoffstatus.com)
 behavior, but for [Blaseball](https://blaseball.com).
 
Published at https://mixolyde.github.io/blaseballstatus

## TODO
* Copy CSS
* API data calls
  * Teams fetch
  * Tiebreaker fetch
  * League names fetch
  * Schedule fetch
* Auto detect current season
* Pick league page
* Playoff chance pages
* Magic Number pages
* Schedule pages
* Simulate rest of season X times
* Automate data fetching and deployment every hour
* Pick league toggle
* Group by division toggle
* Playoffstatus.com attribution
* Tools used
* Unit test coverage report
* Playoff chances
* Playoff Schedule
* Clinched Calculations

## Planned Stat Tables
### Playoff Standings
```
Wild League
               | Record|     Games Behind|           Playoffs| No Playoffs
 Team| Division|  W|  L| League| Playoffs|    1|    2|  3|  4| *
Crabs|     High| 70| 29|      -|        -| 100%|   0%| 0%| 0%| 0%
Mints|      Low| 68| 31|      2|        -|   0%| 100%| 0%| 0%| 0%
```

### Winning Magic Numbers
```
Wild League
               | Record|      Playoffs| No Playoffs
 Team| Division|  W|  L|    1| 2| 3| 4| *
Crabs|     High| 70| 24|    5| C| <| <| <
```



Created from templates made available by Stagehand under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).
