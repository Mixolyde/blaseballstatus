# Blaseball Status
## About
An attempt to replicate [Playoff Status](http://playoffstatus.com)
 behavior, but for [Blaseball](https://blaseball.com).
 
Published at https://mixolyde.github.io/blaseballstatus

## TODO
* Display data as it comes in
  * League names
  * Games Behind standings
  * Other pages in background
* Winning Magic Numbers
* Party Time Magic Numbers
* Fetch future game schedule
* Factor future schedule into magic numbers
* Simulated playoff chances
* Schedule pages
* Tiebreaker/Sort order description page
* Automate static data calculations
* Group by division toggle
* Unit test coverage report
* Postseason chances
* Postseason Schedule
* Playoff berth clinches and destiny control calculations
* Pull database api code out into a separate library
* About page/acknowledgements
* Remember user's last data views

## Planned release schedule
* v0.0.1 
- [x] Wild/Mild league data toggle
- [x] Live pull data on refresh (thanks, [cors-proxy](https://github.com/Society-for-Internet-Blaseball-Research/cors-proxy)!)
- [x] Games behind math
* v0.0.2
- [ ] Data loading indicator and data filling as it comes in
- [ ] Winning magic numbers
- [ ] Party time magic numbers
- [ ] Clinch calculations
* v0.0.3
- [ ] Playoff prediction percentages
- [ ] Group by division toggle
* v0.0.4
- [ ] Automate hourly data updates during the season
- [ ] Postseason content

## Acknowledgements
Huge thank yous to:
* [The Game Band](https://thegameband.com/)
* The Blaseball Discord community
* The SIBR Discord community
* [PlayoffStatus.com](http://PlayoffStatus.com)
* [Dart](https://dart.dev/) for being an awesome language!
* [Peanut and Git plugins](https://github.com/kevmoo) for Dart to auto deploy to gh-pages

Created from templates made available by Stagehand under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).
