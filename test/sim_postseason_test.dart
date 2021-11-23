import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:test/test.dart';

import '../lib/calc_stats.dart';
import '../lib/database_api.dart';
import '../lib/sim_postseason.dart';
import '../lib/sim_season.dart';
import '../lib/site_objects.dart';

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
        print('$stand Po ${stand.po} Post ${stand.post} Winning: ${stand.winning}');
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
  
  group('Live post season no Wild Card', () {
    test('complete postseason standings no wild card', () async { 
      var numTeams = 20;
      var numGames = 99;
      var numCompleted = 99;
      var numSims = 1;
      await setSimDataOptions(false, numCompleted);
      
      var teamIDs = [
        "44d9dc46-7e81-4e21-acff-c0f5dd399ae3", 
        "16d1fd9b-c62b-4bed-b68a-b3a2d6e21524", 
        "74aea6b6-34f9-48f4-b298-7345e1f9f7cb", 
        "2dc7a1fa-3ae6-47ed-8c92-5d80167959f5", 
        "8981c839-cbcf-47e3-a74e-8731dcff24fe", 
        "6526d5df-6a9c-48e1-ba50-12dec0d8b22f", 
        "86f4485a-a6db-470b-82f5-e95e6b353537", 
        "b35926d4-22a3-4419-8fab-686c41687055",
        "Team 9",
        "Team 10",
        "Team 11",
        "Team 12",
        "Team 13",
        "Team 14",
        "Team 15",
        "Team 16",
        "Team 17",
        "Team 18",
        "Team 19",
        "Team 20"];

      var standings = createPostseasonStandings(teamIDs);
      
      sortTeamsNotGrouped(standings[0]);
      sortTeamsNotGrouped(standings[1]);
      calculateWinningMagicNumbers(standings[0]);
      calculateWinningMagicNumbers(standings[1]);
      
      String contents = File('./test/data/completed_postseason_nowildcard.json').readAsStringSync();
      var jsonMap = json.decode(contents);
      var postseasonMap = jsonMap['postseasons'][0]!;
      var completePost = CompletePostseason.fromStreamData(postseasonMap);        
      
      setCompletedPostSeasonStandings(standings, completePost);
      
      var numCarrots = List.filled(4, 0);
      var numXs = List.filled(4, 0);
      standings.forEach((league) => league.forEach((stand) {
        print('$stand Po ${stand.po} Post ${stand.post} Winning: ${stand.winning}');
        for(var i = 0; i < 5; i++){
          expect(stand.post[i], isNot('-'));
          if(i < 4){
            if(stand.post[i] == '^'){
              numCarrots[i]++;
            } else if(stand.post[i] == 'X') {
              numXs[i]++;
            }
          }
          if (i == 4){
            expect(stand.post[i], 'X');
          } 
        }
      })); 
      //^  ^  ^  ^
      //X  ^  ^  ^
      //X  X  ^  ^
      //X  X  ^  ^
      //X  X  X  ^ (x4)
      expect(numCarrots[0], 1);
      expect(numCarrots[1], 2);
      expect(numCarrots[2], 4);
      expect(numCarrots[3], 8);
      expect(numXs[0], numTeams - 1);
      expect(numXs[1], numTeams - 2);
      expect(numXs[2], numTeams - 4);
      expect(numXs[3], numTeams - 8);
      


    }, tags: ['current']);
  });    

}

List<List<TeamStandings>> createPostseasonStandings(List<String> teamIDs){
 var standings = <List<TeamStandings>>[];
  for(var league = 0; league < 2; league++){
    standings.add( [] );
  }

  var teamWins = 0;
  for(var team = 0; team < teamIDs.length; team++){
    // alternate wins/losses to keep rough parity
    if (team % 2 == 0){
      teamWins = rand.nextInt(33) + 33;
    } else {
      teamWins = 99 - teamWins;
    }
    var stand = TeamStandings(
      teamIDs[team], 'The Full Team ${team}s', 
      'The Team ${team}s', 'Emoji $team',
      'League ${team % 2}',
      'Div ${team % 4}',
      teamWins, 99 - teamWins, 99, team);
    standings[team % 2].add(stand);
  }
  return standings;  
  
}
