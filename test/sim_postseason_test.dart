import 'dart:math';
import 'package:test/test.dart';

import '../lib/calc_stats.dart';
import '../lib/sim_season.dart';

import 'sim_season_test.dart';

Random rand = Random(0);


Future<void> main() async {
  await setSimDataOptions(false, 0);

  group('single simulation Wild Card', () {
    test('new season', () async { 
      var numTeams = 20;
      var numGames = 99;
      var numCompleted = 0;
      var numSims = 1;
      await setSimDataOptions(true, numCompleted);
      var standings = createStandings(numTeams, numCompleted);
      var games = createSeasonOfGames(numGames, numCompleted, 
        numTeams, standings,
        [0.475, 0.475, 0.475, 0.475, 
         0.475, 0.5, 0.5, 0.5, 
         0.5, 0.5, 0.5, 0.5,
         0.5, 0.5, 0.5, 0.525,
        0.525, 0.525, 0.525, 0.525]); 
      runSimulations(games, standings, numSims);
      standings.forEach((league) => league.forEach((stand) {
        for(var i = 0; i < 5; i++){
          expect(stand.po[i], isNot('-'));
          expect(stand.post[i], isNot('-'));
        }
      })); 
      //total number of ilb champs should be numSims
    });  
    test('completed season with wild cards', () async { 
      var numTeams = 20;
      var numGames = 99;
      var numCompleted = 99;
      var numSims = 1;
      await setSimDataOptions(true, numCompleted);
      var standings = createStandings(numTeams, numCompleted);
      var games = createSeasonOfGames(numGames, numCompleted, 
        numTeams, standings,
        [0.475, 0.475, 0.475, 0.475, 
         0.475, 0.5, 0.5, 0.5, 
         0.5, 0.5, 0.5, 0.5,
         0.5, 0.5, 0.5, 0.525,
        0.525, 0.525, 0.525, 0.525]); 
      runSimulations(games, standings, numSims);
      standings.forEach((league) => league.forEach((stand) {
        for(var i = 0; i < 5; i++){
          expect(stand.po[i], isNot('-'));
          expect(stand.post[i], isNot('-'));
        }
      })); 
      //total number of ilb champs should be numSims
    }); 
  });
  group('single simulation no Wild Card', () {
    test('new season', () async { 
      var numTeams = 20;
      var numGames = 99;
      var numCompleted = 0;
      var numSims = 1;
      await setSimDataOptions(false, numCompleted);
      var standings = createStandings(numTeams, numCompleted);
      var games = createSeasonOfGames(numGames, numCompleted, 
        numTeams, standings,
        [0.475, 0.475, 0.475, 0.475, 
         0.475, 0.5, 0.5, 0.5, 
         0.5, 0.5, 0.5, 0.5,
         0.5, 0.5, 0.5, 0.525,
        0.525, 0.525, 0.525, 0.525]); 
        
      sortTeamsNotGrouped(standings[0]);
      sortTeamsNotGrouped(standings[1]);
      calculateWinningMagicNumbers(standings[0]);
      calculateWinningMagicNumbers(standings[1]);
      
      runSimulations(games, standings, numSims);
      standings.forEach((league) => league.forEach((stand) {
        for(var i = 0; i < 5; i++){
          expect(stand.po[i], isNot('-'));
          if (i < 4) {
            expect(stand.post[i], isNot('-'));
          } else {
            expect(stand.post[i], '-');
          }
        }
      })); 
    });  
    test('completed season no wild card', () async { 
      var numTeams = 20;
      var numGames = 99;
      var numCompleted = 99;
      var numSims = 1;
      await setSimDataOptions(false, numCompleted);
      var standings = createStandings(numTeams, numCompleted);
      var games = createSeasonOfGames(numGames, numCompleted, 
        numTeams, standings,
        [0.475, 0.475, 0.475, 0.475, 
         0.475, 0.5, 0.5, 0.5, 
         0.5, 0.5, 0.5, 0.5,
         0.5, 0.5, 0.5, 0.525,
        0.525, 0.525, 0.525, 0.525]); 
      
      sortTeamsNotGrouped(standings[0]);
      sortTeamsNotGrouped(standings[1]);
      calculateWinningMagicNumbers(standings[0]);
      calculateWinningMagicNumbers(standings[1]);
      
      runSimulations(games, standings, numSims);
      
      var numCantReach = List.filled(4, 0);
      standings.forEach((league) => league.forEach((stand) {
        print('$stand Po ${stand.po} Post ${stand.post} Winning: ${stand.winning}');
        for(var i = 0; i < 5; i++){
          expect(stand.po[i], isNot('-'));
          if (i < 4){
            expect(stand.post[i], isNot('-'));
            if(stand.post[i] == 'X'){
              numCantReach[i]++;
            }            
          } else {
            expect(stand.post[i], '-');
          }
          

        }
      })); 
      print(numCantReach);
      expect(numCantReach.every( (i) => i == 12), true);

    }); 
  });  
  group('multiple simulations', () {
    test('completed season wild card', () async { 
      var numTeams = 20;
      var numGames = 99;
      var numCompleted = 99;
      var numSims = 19;
      await setSimDataOptions(true, numCompleted);
      var standings = createStandings(numTeams, numCompleted);
      var games = createSeasonOfGames(numGames, numCompleted, 
        numTeams, standings,
        [0.475, 0.475, 0.475, 0.475, 
         0.475, 0.5, 0.5, 0.5, 
         0.5, 0.5, 0.5, 0.5,
         0.5, 0.5, 0.5, 0.525,
        0.525, 0.525, 0.525, 0.525]); 
        
      runSimulations(games, standings, numSims);
           
      standings.forEach((league) => league.forEach((stand) {
        for(var i = 0; i < 5; i++){
          expect(stand.po[i], isNot('-'));
          expect(stand.post[i], isNot('-'));
        }
      })); 
    });
    
    test('new season no wild card', () async { 
      var numTeams = 20;
      var numGames = 99;
      var numCompleted = 0;
      var numSims = 19;
      await setSimDataOptions(false, numCompleted);
      var standings = createStandings(numTeams, numCompleted);
      var games = createSeasonOfGames(numGames, numCompleted, 
        numTeams, standings,
        [0.475, 0.475, 0.475, 0.475, 
         0.475, 0.5, 0.5, 0.5, 
         0.5, 0.5, 0.5, 0.5,
         0.5, 0.5, 0.5, 0.525,
        0.525, 0.525, 0.525, 0.525]); 
        
      sortTeamsNotGrouped(standings[0]);
      sortTeamsNotGrouped(standings[1]);
      calculateWinningMagicNumbers(standings[0]);
      calculateWinningMagicNumbers(standings[1]);
      
      runSimulations(games, standings, numSims);
      
      standings.forEach((league) => league.forEach((stand) {
        for(var i = 0; i < 5; i++){
          expect(stand.po[i], isNot('-'));
          if (i < 4){
            expect(stand.post[i], isNot('-'));           
          } else {
            expect(stand.post[i], '-');
          }
        }
      })); 
    });    
    test('completed season no wild card', () async { 
      var numTeams = 20;
      var numGames = 99;
      var numCompleted = 99;
      var numSims = 19;
      await setSimDataOptions(false, numCompleted);
      var standings = createStandings(numTeams, numCompleted);
      var games = createSeasonOfGames(numGames, numCompleted, 
        numTeams, standings,
        [0.475, 0.475, 0.475, 0.475, 
         0.475, 0.5, 0.5, 0.5, 
         0.5, 0.5, 0.5, 0.5,
         0.5, 0.5, 0.5, 0.525,
        0.525, 0.525, 0.525, 0.525]); 
        
      sortTeamsNotGrouped(standings[0]);
      sortTeamsNotGrouped(standings[1]);
      calculateWinningMagicNumbers(standings[0]);
      calculateWinningMagicNumbers(standings[1]);
      
      runSimulations(games, standings, numSims);
      
      var numCantReach = List.filled(4, 0); 
      standings.forEach((league) => league.forEach((stand) {
        for(var i = 0; i < 5; i++){
          expect(stand.po[i], isNot('-'));
          if (i < 4){
            expect(stand.post[i], isNot('-'));
            if(stand.post[i] == 'X'){
              numCantReach[i]++;
            }            
          } else {
            expect(stand.post[i], '-');
          }
        }
      })); 
    });        
  });

}
