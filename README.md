# Blaseball Status
## About
An attempt to replicate [Playoff Status](http://playoffstatus.com)
 behavior, but for [Blaseball](https://blaseball.com).
 
Published at https://mixolyde.github.io/blaseballstatus

## TODO
* Display data as it comes in
  * Games Behind standings
  * Other pages in background
* Add contributing instructions
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
* Pull database api code out into a separate library
* About page/acknowledgements
* Remember user's last data views
* Team emoji in table entries
* Move project to a blaseball status account
* Automated data refreshes [Dart Cron](https://pub.dev/packages/cron)

## Planned release schedule
* v0.0.1 
- [x] Wild/Mild league data toggle
- [x] Live pull data on refresh (thanks, [cors-proxy](https://github.com/Society-for-Internet-Blaseball-Research/cors-proxy)!)
- [x] Games behind math
* v0.0.2
- [x] Data loading indicator and data filling as it comes in
- [x] Winning magic numbers
- [x] Party time magic numbers
- [x] Clinch calculations
* v0.0.3
- [ ] Auto refresh data in browser
- [ ] Save last view
- [ ] Group by division toggle
- [ ] About and info page
* v0.0.4
- [ ] Playoff prediction percentages
- [ ] Automate static data updates during the season
- [ ] Postseason content

## Acknowledgements
Huge thank yous to:
* [The Game Band](https://thegameband.com/)
* The Blaseball Discord community
* The SIBR Discord community
* [PlayoffStatus.com](http://PlayoffStatus.com)
* [Dart](https://dart.dev/) for being an awesome language!
* [Peanut and Git plugins](https://github.com/kevmoo) for Dart to auto deploy to gh-pages
* [Codeship](https://codeship.com) for continuous integration and automated deployment

Created from templates made available by Stagehand under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).
