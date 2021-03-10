# Blaseball Status
## About
An attempt to replicate [Playoff Status](http://playoffstatus.com)
 behavior, but for [Blaseball](https://blaseball.com).
 
Published at https://mixolyde.net/blaseballstatus/

## TODO
* Figure out what's up with tied records getting weird sim results
* Postseason schedule
* Handle postseason data live
* Team rank history over season chart
* Schedule pages
* Get a twitter account and button
* Factor future schedule into magic numbers
* Unit test coverage report
* Pull database api code out into a separate library
* Move project to a blaseball-specific account on github
* Reduce API calls during siesta

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
- [x] Auto refresh data in browser
- [x] Save last view
- [x] About and info pages
* v0.0.4
- [x] New playoff birth rules
- [x] Group by division toggle
- [x] Properly calculate games played
- [x] Automate static data updates during the season
* v0.0.5
- [x] Playoff prediction percentages
* v0.0.6
- [x] Postseason content
- [x] Add emoji to team rows
- [x] Show full team name in wide view
* v0.0.7
- [ ] Live Postseason chance updates
- [ ] Live Postseason schedule updates
* v0.0.8
- [ ] Team Schedules
- [ ] Get a twitter account and button
- [ ] Unit test coverage report
- [ ] Move project to a blaseball-specific account on github

## Contributing

### Installing Dart
You will need Dart installed and on your $PATH to build and test 
the app.

On Linux
```
cd ~
wget --quiet https://storage.googleapis.com/dart-archive/channels/stable/release/latest/sdk/dartsdk-linux-x64-release.zip
unzip -q -o dartsdk-linux-x64-release.zip -d ~
export PATH=$PATH:~/dart-sdk/bin:~/.pub-cache/bin
pub global activate peanut
pub get
```
On Windows, get the Windows Dart SDK zip, unzip it somewhere,
and add that unzip's bin folder to your PATH variable. You also need
to add the Pub Cache bin folder to your PATH, which may be in 
`c:\Users\<username>\AppData\Roaming\Pub\Cache\bin`.

You typically need to call the '.bat' versions of the helper tools
in Windows.

```
pub.bat global activate peanut
pub.bat get
```

### Building and testing
You can run all unit-tests with `pub.bat run test` or
a specific test with `dart test\test-file.dart`.

To serve up the app and test in your browser run
`webdev.bat serve` and go to `http://localhost:8080/`.

On Windows, there doesn't seem to be a clean way to shutdown
the local webdev server, so you may have to kill the process
from Task Manager, or with `taskkill -f -pid ###`.

I find the Windows Git Shell from Github that emulates a lot of Linux
stuff to be really useful.

```
alias killdart='tasklist |grep dart |head -1 |awk '\''{print $2}'\'' | xargs taskkill -f -pid '
```

### Deploying
The Peanut plugin will automatically build your static web content
and commit it to the gh-pages branch. Then you can push the gh-pages
branch up to github.

```
peanut.bat
git push origin --set-upstream gh-pages
```

Your site should eventually get published to 
`yourusername.github.io/blaseballstatus`.

## Architecture
There are two main code components, and three infrastructure components.

### Code components
1. `tools/update_stats.dart` - a CLI script which generates the json data files
for the site and uploads them to an S3 bucket in AWS.
2. `web` - All of the web site code that gets published to the gh-pages branch
by the dart plugin Peanut.

### Infrastructure components
1. AWS S3 - A public data bucket for holding the json data structures with all of the stats and season
data.
2. AWS EC2 - A very simple server with a cronjob for periodically running
`tools\update_stats.dart`
3. Codeship - An automated build service which automatically tests the code
and deploys the published web site to the gh-pages branch, which is picked up
by github and deployed to the site.


## Acknowledgements
Huge thanks to:
* [The Game Band](https://thegameband.com/)
* [The Blaseball Discord](https://discord.gg/3uFgJhu) community
* The SIBR Discord community
* [PlayoffStatus.com](http://PlayoffStatus.com)
* [Dart](https://dart.dev/) for being an awesome language!
* [Peanut and Git plugins](https://github.com/kevmoo) for Dart to auto deploy to gh-pages
* [Codeship](https://codeship.com) for continuous integration and automated deployment

Created from templates made available by Stagehand under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).
