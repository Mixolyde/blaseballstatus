import 'dart:math';
import 'package:test/test.dart';

import '../lib/calc_stats.dart';
import '../lib/database_api.dart';
import '../lib/sim_season.dart';
import '../lib/site_objects.dart';

Random rand = Random(0);

void main() async {
  await setNoWildCardSimData();
  
  group('single game', () {
    test('Teams with no games', () {
      //id, this.notLosses, this.wins, this.losses, this.favor, this.division
      var awaySim = TeamSim('Team 1', 0, 0, 0, 1, 'Div 1');
      var homeSim = TeamSim('Team 2', 0, 0, 0, 2, 'Div 1');
      awaySim.save();
      homeSim.save();
      
      var result = simulateGame(awaySim, homeSim, 2);
      expect(result, isNotNull);
      
    });  
    test('Unbalanced away team', () {
      var awaySim = TeamSim('Team 1', 1000, 1000, 0, 1, 'Div 1');
      var homeSim = TeamSim('Team 2', 0, 0, 1000, 2, 'Div 1');
      awaySim.save();
      homeSim.save();
      
      var result = simulateGame(awaySim, homeSim, 2);
      expect(result, isNotNull);
      
    }); 
    test('Unbalanced home team', () {
      var awaySim = TeamSim('Team 1', 0, 0, 1000, 1, 'Div 1');
      var homeSim = TeamSim('Team 2', 1000, 1000, 0, 2, 'Div 1');
      awaySim.save();
      homeSim.save();
      
      var result = simulateGame(awaySim, homeSim, 2);
      expect(result, isNotNull);
      
    });     
  });
  group('single simulation', () {
    test('Short season', () {
      var games = <Game>[];
      for (int i = 0; i < 10; i++){
        games.add(createRandomGame(i, false,
          'Team 1', 'Team 2', 0.25));
        games.add(createRandomGame(i, false,
          'Team 3', 'Team 4', 0.75));
      }
      List<List<TeamStandings>> standings = createStandings(4, 0);
      print(standings);
      Map<String, TeamSim> sims = mapTeamSims(standings, games);
      print(sims);
      simulateSeason(games, sims);
      sims.values.forEach((sim){
        expect(sim.notLosses == sim.wins, true);
        expect(sim.notLosses + sim.losses, 10);
        print(sim);
      });
    });   
    test('Save and load', () {
      List<Game> games = [];
      for (int i = 0; i < 10; i++){
        games.add(createRandomGame(i, false,
          'Team 1', 'Team 2', 0.25));
        games.add(createRandomGame(i, false,
          'Team 3', 'Team 4', 0.75));
      }
      Map<String, TeamSim> sims = Map<String, TeamSim>();
      for(int i = 1; i < 5; i++){
        sims['Team $i'] = TeamSim('Team $i', 0, 0, 0, i, 'Div 0');
      };
      sims.values.forEach((sim) => sim.save());
      
      simulateSeason(games, sims);
      
      sims.values.forEach((sim) => sim.load());
      sims.values.forEach((sim) {
        expect(sim.notLosses, 0);
        expect(sim.wins, 0);
        expect(sim.losses, 0);
      });

    });   
    test('new long season', () {
      int numTeams = 12;
      int numGames = 29;
      List<List<TeamStandings>> standings = createStandings(numTeams, 0);
      List<Game> games = createSeasonOfGames(numGames, 0, 
        numTeams, standings);
      print(standings);
      Map<String, TeamSim> sims = mapTeamSims(standings, games);
      print(sims);
      simulateSeason(games, sims);
      sims.values.forEach((sim){
        expect(sim.notLosses == sim.wins, true);
        expect(sim.notLosses + sim.losses, numGames);
        print(sim);
      });
    }); 
    test('partial long season', () {
      int numTeams = 12;
      int numGames = 29;
      int numCompleted = 19;
      List<List<TeamStandings>> standings = createStandings(numTeams, numCompleted);
      List<Game> games = createSeasonOfGames(numGames, numCompleted, 
        numTeams, standings,
        [0.2, 0.2, 0.3, 0.3, 
         0.4, 0.5, 0.6, 0.7, 
         0.8, 0.8, 0.9, 0.99]);
      print(standings);
      Map<String, TeamSim> sims = mapTeamSims(standings, games);
      print(sims);
      simulateSeason(games, sims);
      sims.values.forEach((sim){
        expect(sim.notLosses == sim.wins, true);
        expect(sim.notLosses + sim.losses, numGames);
        print(sim);
      });
    });     
    test('partial long season with varying wins', () {
      int numTeams = 12;
      int numGames = 39;
      int numCompleted = 29;
      List<List<TeamStandings>> standings = createStandings(numTeams, numCompleted);
      List<Game> games = createSeasonOfGames(numGames, numCompleted, 
        numTeams, standings,
        [0.2, 0.2, 0.3, 0.3, 
         0.4, 0.5, 0.6, 0.7, 
         0.8, 0.8, 0.9, 0.99]);
      List<int> winVariances = [2, 0, -1, 3, 1, 0, -2, 0, 1, -1];
      //apply variances to standings
      for (int i = 0; i < winVariances.length; i++){
        standings[(i + 1) % 2].firstWhere((stand) => stand.id == 'Team ${i + 1}').
            wins += winVariances[i];
      }
      print(standings);
      Map<String, TeamSim> sims = mapTeamSims(standings, games);
      simulateSeason(games, sims);
      for (int i = 0; i < winVariances.length; i++){
        TeamSim? sim = sims['Team ${i + 1}'];
        if(sim == null) fail('Sim was null');
        expect(sim.wins, sim.notLosses + winVariances[i]);
        expect(sim.notLosses + sim.losses, numGames);
        print(sim);
      }
    }); 
  });
  group('run multiple simulations', () {
    test('Short season', () { 
      int numTeams = 20;
      int numGames = 29;
      int numCompleted = 16;
      int numSims = 101;
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
        }
      }));
    });      
    test('complete season', () { 
      int numTeams = 20;
      int numGames = 99;
      int numCompleted = 0;
      int numSims = 2007;
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
        }
      }));   
    });      
    test('almost complete season with clinches', () { 
      int numTeams = 20;
      int numGames = 99;
      int numCompleted = 92;
      int numSims = 11;
      List<List<TeamStandings>> standings = createStandings(numTeams, numCompleted);

      List<Game> games = createSeasonOfGames(numGames, numCompleted, 
        numTeams, standings,
        [0.1, 0.1, 0.2, 0.2, 0.3, 0.3, 0.4, 0.4, 0.5, 0.5, 0.5, 0.5,
        0.6, 0.6, 0.7, 0.7, 0.8, 0.8, 0.9, 0.9]); 
      sortTeamsNotGrouped(standings[0]);
      sortTeamsNotGrouped(standings[1]);
      calculateMagicNumbers(standings[0]);
      calculateMagicNumbers(standings[1]);
      standings.forEach((standingList) => standingList.forEach((standing) {
        print('Magic Numbers Standing ${standing.id} winning: ${standing.winning}');
      }));        
      runSimulations(games, standings, numSims);
      standings.forEach((league) => league.forEach((stand) {
        for(int i = 0; i < 5; i++){
          expect(stand.po[i], isNot('-'));
          switch(stand.winning[i]){
            case '^':
            case 'X':
            case 'PT':
              expect(stand.po[i], stand.winning[i]);
              break;
            default:
              expect(stand.po[i].endsWith('%'), true);
              break;
          }
        }
      }));       
      
    }); 
  });   
  group('playoff bracket entries', () {
    test('null post season', () async { 
      int numTeams = 20;
      int numCompleted = 16;
      List<List<TeamStandings>> standings = createStandings(numTeams, numCompleted);
      
      List<PlayoffBracketEntry> entries = await calculatePlayoffBracketEntries(
        null, standings);
      
      expect(entries.length, 19);
      expect(entries[0].teamNickname, 'Seed');
      expect(entries[18].teamNickname, 'TBD');
      
      expect(entries[0].subleague, standings[0][0].subleague);
      expect(entries[2].subleague, standings[1][0].subleague);
      expect(entries[16].subleague, standings[0][0].subleague);
      expect(entries[17].subleague, standings[1][0].subleague);
      expect(entries[18].subleague, 'TBD');
    });
    test('live post season', () async {
      SimulationData simData = await getSimulationData();
      SiteData sitedata = await calcSiteData(simData);
      List<List<TeamStandings>> subStandings = await calcStats(simData);
      CompletePostseason? postseason = await getCompletePostseason(simData.season);    
      
      List<PlayoffBracketEntry> entries = await calculatePlayoffBracketEntries(
        postseason, subStandings);
        
      expect(entries.length, 19);
        
    });        
    test('full post season', () async {
      SimulationData simData = await getSimulationData();
      SimulationData oldSimData = SimulationData(
        id: simData.id,
        day: 113,
        league: 'd8545021-e9fc-48a3-af74-48685950a183',
        playOffRound: 3,
        season: 14,
        seasonId: '645cdd84-175f-42f1-a9f3-d9014d97ae3b',
        eraTitle: simData.eraTitle,
        subEraTitle: simData.subEraTitle,
        attributes: ['TEST_ATTR1', 'TEST_ATTR2', 'TEST_ATTR3'],
      );
      
      SiteData sitedata = await calcSiteData(oldSimData);
      List<List<TeamStandings>> subStandings = await calcStats(oldSimData);
      CompletePostseason? postseason = await getCompletePostseason(oldSimData.season);    
/*      
      List<PlayoffBracketEntry> entries = await calculatePlayoffBracketEntries(
        postseason, subStandings);
        
      expect(entries.length, 19);
      entries.forEach((entry) {
        print('Testing entry: $entry');
        expect(entry.teamNickname, isNot('Seed'));
        expect(entry.teamNickname, isNot('TBD'));
        expect(entry.seed, greaterThan(0));
      });    

      expect(entries[16].teamNickname, 'Wild Wings');
      expect(entries[16].wins, 1);
      expect(entries[16].seed, 5);

      expect(entries[17].teamNickname, 'Moist Talkers');
      expect(entries[17].wins, 3);
      expect(entries[17].seed, 2);

      expect(entries[18].teamNickname, 'Moist Talkers');
      expect(entries[18].wins, 3);
      expect(entries[18].seed, 2);
      expect(entries[18].subleague, 'Mild');
    */
    });
  });
    
}

List<List<TeamStandings>> createStandings(int numTeams, int gamesPlayed){
  List<List<TeamStandings>> standings = [];
  for(int league = 0; league < 2; league++){
    standings.add( [] );
  }
  
  for(int team = 1; team <= numTeams; team++){
    TeamStandings stand = TeamStandings(
      'Team $team', 'The Full Team ${team}s', 
      'The Team ${team}s', 'Emoji ${team}',
      'League ${team % 2}',
      'Div ${team % 4}',
      0, 0, gamesPlayed, team);
    standings[team % 2].add(stand);
  }
  return standings;
}

Game createRandomGame(int day, bool completed, 
  String home, String away, num awayChance){
  int homeScore = 0;
  int awayScore = 0;
  if(completed){
    //print('Creating completed game with awayChance $awayChance');
    int low = rand.nextInt(10);
    int high = low + 1 + rand.nextInt(10);
    if(rand.nextDouble() < awayChance){
      homeScore = low;
      awayScore = high;
    } else {
      homeScore = high;
      awayScore = low;
    }
  }
  Game game = Game(
    id: rand.nextInt(1000).toString(),
    day: day,    
    gameComplete: completed,    
    awayTeam: away,
    awayTeamNickname: '$away Nickname',
    awayScore: awayScore,
    homeTeam: home,
    homeTeamNickname: '$home Nickname',
    homeScore: homeScore,
    season: 0,
   
  );
    
  return game;
}

List<Game> createSeasonOfGames(int numDays, int completedDays,
  int numTeams, List<List<TeamStandings>> standings, [List<num>? initialChances]){
  if(numTeams % 4 != 0){
    throw ArgumentError('NumTeams must be divisible by four');
  }
  List<Game> games = [];
  if(initialChances == null || initialChances.length != numTeams){
    initialChances = List<num>.filled(numTeams, 0.5);
    print(initialChances);
  }
  
  for(int day = 0; day < numDays; day++){
    for(int matchup = 0; matchup < numTeams / 2; matchup++){
      //randomly assign matchups
      //print('Creating matchup $matchup day $day');
      //create game between matchups
      int team1 = matchup * 2 + 1;
      int team2 = matchup * 2 + 2;
      Game played = createRandomGame(day, day < completedDays, 
        'Team $team1', 'Team $team2', initialChances[matchup*2]);
      if(played.gameComplete){
        //update standings
        if(played.awayScore > played.homeScore){
          standings[team1 % 2].firstWhere((stand) => stand.id == 'Team $team1').
            losses++;
          standings[team2 % 2].firstWhere((stand) => stand.id == 'Team $team2').
            wins++;
        } else {
          standings[team1 % 2].firstWhere((stand) => stand.id == 'Team $team1').
            wins++;
          standings[team2 % 2].firstWhere((stand) => stand.id == 'Team $team2').
            losses++;
        }
      }
      games.add(played);
    }
  }
  
  return games;
}


Future<void> setNoWildCardSimData() async {
  apiUrl = 'https://blaseball.com/database/';
  SimulationData currentSimData = await getSimulationData();
  SimulationData simData = SimulationData(
    id: currentSimData.id,
    day: 113,
    league: 'd8545021-e9fc-48a3-af74-48685950a183',
    playOffRound: 3,
    season: 14,
    seasonId: '645cdd84-175f-42f1-a9f3-d9014d97ae3b',
    eraTitle: currentSimData.eraTitle,
    subEraTitle: currentSimData.subEraTitle,
    attributes: ['TEST_ATTR1', 'TEST_ATTR2', 'TEST_ATTR3'],
  );
  setLateData(simData);
}

Future<void> setWildCardSimData() async {
  apiUrl = 'https://blaseball.com/database/';
  SimulationData currentSimData = await getSimulationData();
  SimulationData simData = SimulationData(
    id: currentSimData.id,
    day: 113,
    league: 'd8545021-e9fc-48a3-af74-48685950a183',
    playOffRound: 3,
    season: 14,
    seasonId: '645cdd84-175f-42f1-a9f3-d9014d97ae3b',
    eraTitle: currentSimData.eraTitle,
    subEraTitle: currentSimData.subEraTitle,
    attributes: ['TEST_ATTR1', 'TEST_ATTR2', 'TEST_ATTR3','WILD_CARDS'],
  );
  setLateData(simData);
}
