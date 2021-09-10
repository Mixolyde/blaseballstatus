import 'dart:math';
import 'package:test/test.dart';

import '../lib/calc_stats.dart';
import '../lib/database_api.dart';
import '../lib/sim_season.dart';
import '../lib/site_objects.dart';

import 'sim_season_test.dart';

Random rand = new Random(0);


void main() async {
  await setNoWildCardSimData();

  group('single simulation Wild Card', () {
    test('new season', () async { 
      await setWildCardSimData();
      int numTeams = 20;
      int numGames = 99;
      int numCompleted = 0;
      int numSims = 1;
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
    test('completed season', () async { 
      await setWildCardSimData(); 
      int numTeams = 20;
      int numGames = 99;
      int numCompleted = 99;
      int numSims = 1;
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
  group('single simulation no Wild Card', () {
    test('new season', () async { 
      await setNoWildCardSimData();
      int numTeams = 20;
      int numGames = 99;
      int numCompleted = 0;
      int numSims = 1;
      List<List<TeamStandings>> standings = createStandings(numTeams, numCompleted);
      List<Game> games = createSeasonOfGames(numGames, numCompleted, 
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
        for(int i = 0; i < 5; i++){
          expect(stand.po[i], isNot('-'));
          if (i < 4)
            expect(stand.post[i], isNot('-'));
          else 
            expect(stand.post[i], '-');
        }
      })); 
    });  
    test('completed season', () async { 
      await setNoWildCardSimData(); 
      int numTeams = 20;
      int numGames = 99;
      int numCompleted = 99;
      int numSims = 1;
      List<List<TeamStandings>> standings = createStandings(numTeams, numCompleted);
      List<Game> games = createSeasonOfGames(numGames, numCompleted, 
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
      
      List<int> numCantReach = List.filled(4, 0);
      standings.forEach((league) => league.forEach((stand) {
        print('$stand Po ${stand.po} Post ${stand.post} Winning: ${stand.winning}');
        for(int i = 0; i < 5; i++){
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
      await setWildCardSimData();
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
    });
    
    test('new season no wild card', () async { 
      await setNoWildCardSimData();
      int numTeams = 20;
      int numGames = 99;
      int numCompleted = 0;
      int numSims = 19;
      List<List<TeamStandings>> standings = createStandings(numTeams, numCompleted);
      List<Game> games = createSeasonOfGames(numGames, numCompleted, 
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
        for(int i = 0; i < 5; i++){
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
      await setNoWildCardSimData();
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
        
      sortTeamsNotGrouped(standings[0]);
      sortTeamsNotGrouped(standings[1]);
      calculateWinningMagicNumbers(standings[0]);
      calculateWinningMagicNumbers(standings[1]);
      
      runSimulations(games, standings, numSims);
      
      List<int> numCantReach = List.filled(4, 0); 
      standings.forEach((league) => league.forEach((stand) {
        for(int i = 0; i < 5; i++){
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
