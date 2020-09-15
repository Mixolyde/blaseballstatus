# Blaseball Status
## About
An attempt to replicate [Playoff Status](http://playoffstatus.com)
 behavior, but for [Blaseball](https://blaseball.com).
 
Published at https://mixolyde.github.io/blaseballstatus

## TODO
* Schedule data fetch
* Games Behind calculation
* Auto detect current season
* Playoff chance pages
* Magic Number pages
* Schedule pages
* Tiebreaker/Sort order description
* Simulate rest of season X times
* Automate data fetching and deployment every hour
* Pick league toggle
* Group by division toggle
* Unit test coverage report
* Postseason chances
* Postseason Schedule
* Clinched and Destiny Control Calculations
* Pull database api code out into a separate library

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

## Acknowledgements
A huge thank you to:
* The Game Band
* The Blaseball community
* The SIBR community
* PlayoffStatus.com
* Dart for being an awesome language!
* Peanut plugin for Dart to auto deploy to gh-pages

Created from templates made available by Stagehand under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).
