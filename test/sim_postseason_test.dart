import 'dart:math';
import 'package:test/test.dart';

import '../lib/calc_stats.dart';
import '../lib/database_api.dart';
import '../lib/sim_season.dart';
import '../lib/site_objects.dart';

import 'sim_season_test.dart';

Random rand = new Random(0);

void main() {
  group('single simulation', () {
    test('complete season', () { 
      int numTeams = 20;
      int numGames = 99;
      int numCompleted = 99;
      int numSims = 19;
      List<List<TeamStandings>> standings = createStandings(numTeams, numCompleted);
      List<Game> games = createSeasonOfGames(numGames, numCompleted, 
        numTeams, standings,
        [0.475, 0.475, 0.475, 0.475, 
         0.475, 0.5, 0.5, 0.5, 
         0.5, 0.5, 0.5, 0.5,
         0.5, 0.5, 0.5, 0.525,
        0.525, 0.525, 0.525, 0.525]); 
      runSimulations(games, standings, numSims);
      standings.forEach((league) => league.forEach((stand) {
        for(int i = 0; i < 5; i++){
          expect(stand.po[i], isNot('-'));
          expect(stand.post[i], isNot('-'));
        }
      })); 
      //total number of ilb champs should be numSims
    });
  });
}