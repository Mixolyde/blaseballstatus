import 'dart:math';
import 'package:test/test.dart';

import '../lib/database_api.dart';
import '../lib/sim_season.dart';
import '../lib/site_objects.dart';

Random rand = new Random(0);

void main() {
  group('single simulation', () {
    test('Short season', () {
      List<Game> games = new List<Game>();
      for (int i = 0; i < 10; i++){
        games.add(createRandomGame(i, false,
          "Team 1", "Team 2", 0.25));
        games.add(createRandomGame(i, false,
          "Team 3", "Team 4", 0.75));
      }
      List<List<TeamStandings>> standings = createStandings(4);
      print(standings);
      Map<String, TeamSim> sims = mapTeamSims(standings, games);
      print(sims);
      simulateSeason(games, sims);
      sims.values.forEach((sim){
        expect(sim.actualWins == sim.wins, true);
        expect(sim.actualWins + sim.losses, 10);
        print(sim);
      });
    });   
    test('Save and load', () {
      List<Game> games = new List<Game>();
      for (int i = 0; i < 10; i++){
        games.add(createRandomGame(i, false,
          "Team 1", "Team 2", 0.25));
        games.add(createRandomGame(i, false,
          "Team 3", "Team 4", 0.75));
      }
      Map<String, TeamSim> sims = new Map<String, TeamSim>();
      for(int i = 1; i < 5; i++){
        sims["Team $i"] = new TeamSim("Team $i", 0, 0, 0);
      };
      sims.values.forEach((sim) => sim.save());
      
      simulateSeason(games, sims);
      
      sims.values.forEach((sim) => sim.load());
      sims.values.forEach((sim) {
        expect(sim.actualWins, 0);
        expect(sim.wins, 0);
        expect(sim.losses, 0);
      });

    });   
    test('new long season', () {
      int numTeams = 12;
      int numGames = 29;
      List<List<TeamStandings>> standings = createStandings(numTeams);
      List<Game> games = createSeasonOfGames(numGames, 0, 
        numTeams, standings);
      print(standings);
      Map<String, TeamSim> sims = mapTeamSims(standings, games);
      print(sims);
      simulateSeason(games, sims);
      sims.values.forEach((sim){
        expect(sim.actualWins == sim.wins, true);
        expect(sim.actualWins + sim.losses, numGames);
        print(sim);
      });
    }); 
    test('partial long season', () {
      int numTeams = 12;
      int numGames = 29;
      int numCompleted = 19;
      List<List<TeamStandings>> standings = createStandings(numTeams);
      List<Game> games = createSeasonOfGames(numGames, numCompleted, 
        numTeams, standings,
        [0.2, 0.2, 0.3, 0.3, 0.4, 0.5, 0.6,
        0.7, 0.8, 0.8, 0.9, 0.99]);
      print(standings);
      Map<String, TeamSim> sims = mapTeamSims(standings, games);
      print(sims);
      simulateSeason(games, sims);
      sims.values.forEach((sim){
        expect(sim.actualWins == sim.wins, true);
        expect(sim.actualWins + sim.losses, numGames);
        print(sim);
      });
    });     
    test('partial long season with varying wins', () {
      int numTeams = 12;
      int numGames = 39;
      int numCompleted = 29;
      List<List<TeamStandings>> standings = createStandings(numTeams);
      List<Game> games = createSeasonOfGames(numGames, numCompleted, 
        numTeams, standings,
        [0.2, 0.2, 0.3, 0.3, 0.4, 0.5, 0.6,
        0.7, 0.8, 0.8, 0.9, 0.99]);
      List<int> winVariances = [2, 0, -1, 3, 1, 0, -2, 0, 1, -1];
      //apply variances to standings
      for (int i = 0; i < winVariances.length; i++){
        standings[(i + 1) % 2].firstWhere((stand) => stand.id == "Team ${i + 1}").
            wins += winVariances[i];
      }
      print(standings);
      Map<String, TeamSim> sims = mapTeamSims(standings, games);
      simulateSeason(games, sims);
      for (int i = 0; i < winVariances.length; i++){
        TeamSim sim = sims["Team ${i + 1}"];
        expect(sim.wins, sim.actualWins + winVariances[i]);
        expect(sim.actualWins + sim.losses, numGames);
        print(sim);
      }
    }); 
  });
  group('run multiple simulations', () {
    test('Short season', () { 
      int numTeams = 8;
      int numGames = 19;
      int numCompleted = 5;
      int numSims = 5;
      List<List<TeamStandings>> standings = createStandings(numTeams);
      List<Game> games = createSeasonOfGames(numGames, numCompleted, 
        numTeams, standings,
        [0.2, 0.2, 0.3, 0.4, 0.5, 0.6,
        0.7, 0.8]);    
      runSimulations(games, standings, numSims);
      
      
      
    }); 
  });    
}

List<List<TeamStandings>> createStandings(int numTeams){
  List<List<TeamStandings>> standings = new List<List<TeamStandings>>();
  for(int league = 0; league < 2; league++){
    standings.add( new List<TeamStandings>() );
  }
  
  for(int team = 1; team <= numTeams; team++){
    TeamStandings stand = new TeamStandings(
      "Team $team", "The Team ${team}s", "Div ${team % 4}",
      0, 0, 0, team);
    standings[team % 2].add(stand);
  }
  return standings;
}

Game createRandomGame(int day, bool completed, 
  String home, String away, num awayChance){
  int homeScore = 0;
  int awayScore = 0;
  if(completed){
    print("Creating completed game with awayChance $awayChance");
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
  Game game = new Game(
    id: rand.nextInt(1000).toString(),
    day: day,    
    gameComplete: completed,    
    awayTeam: away,
    awayTeamNickname: "$away Nickname",
    awayScore: awayScore,
    homeTeam: home,
    homeTeamNickname: "$home Nickname",
    homeScore: homeScore,
    season: 0,
   
  );
    
  return game;
}

List<Game> createSeasonOfGames(int numDays, int completedDays,
  int numTeams, List<List<TeamStandings>> standings, [List<num> initialChances]){
  if(numTeams % 4 != 0){
    throw new ArgumentError("NumTeams must be divisible by four");
  }
  List<Game> games = new List<Game>();
  if(initialChances == null || initialChances.length != numTeams){
    initialChances = List<num>.filled(numTeams, 0.25);
    print(initialChances);
  }
  
  for(int day = 0; day < numDays; day++){
    for(int matchup = 0; matchup < numTeams / 2; matchup++){
      //randomly assign matchups
      print("Creating matchup $matchup day $day");
      //create game between matchups
      int team1 = matchup * 2 + 1;
      int team2 = matchup * 2 + 2;
      Game played = createRandomGame(day, day < completedDays, 
        "Team $team1", "Team $team2", initialChances[matchup*2]);
      if(played.gameComplete){
        //update standings
        if(played.awayScore > played.homeScore){
          standings[team1 % 2].firstWhere((stand) => stand.id == "Team $team1").
            losses++;
          standings[team2 % 2].firstWhere((stand) => stand.id == "Team $team2").
            wins++;
        } else {
          standings[team1 % 2].firstWhere((stand) => stand.id == "Team $team1").
            wins++;
          standings[team2 % 2].firstWhere((stand) => stand.id == "Team $team2").
            losses++;
        }
      }
      games.add(played);
    }
  }
  
  return games;
}