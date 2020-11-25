import 'dart:math';
import 'package:test/test.dart';

import '../lib/database_api.dart';
import '../lib/sim_season.dart';

Random rand = new Random(0);

void main() {
  group('season simulation tests', () {
    test('Short season', () {
      List<Game> games = new List<Game>();
      for (int i = 0; i < 10; i++){
        games.add(createRandomGame(i, false,
          "Team 1", "Team 2", 0.25));
        games.add(createRandomGame(i, false,
          "Team 3", "Team 4", 0.75));
      }
      Standings standings = createStandings(4);
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
      int numTeams = 10;
      int numGames = 29;
      Standings standings = createStandings(numTeams);
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
      int numTeams = 10;
      int numGames = 29;
      int numCompleted = 19;
      Standings standings = createStandings(numTeams);
      List<Game> games = createSeasonOfGames(numGames, numCompleted, 
        numTeams, standings,
        [0.1, 0.2, 0.3, 0.4, 0.5, 0.6,
        0.7, 0.8, 0.9, 0.99]);
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
      int numTeams = 10;
      int numGames = 39;
      int numCompleted = 29;
      Standings standings = createStandings(numTeams);
      List<Game> games = createSeasonOfGames(numGames, numCompleted, 
        numTeams, standings,
        [0.2, 0.2, 0.3, 0.4, 0.5, 0.6,
        0.7, 0.8, 0.9, 0.99]);
      List<int> winVariances = [2, 0, -1, 3, 1, 0, -2, 0, 1, -1];
      //apply variances to standings
      for (int i = 0; i < winVariances.length; i++){
        standings.wins["Team ${i + 1}"] += winVariances[i];
        if(standings.wins["Team ${i + 1}"] < 0){
          standings.wins["Team ${i + 1}"] = 0;
        }
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
  
}

Standings createStandings(int numTeams){
  Map<String, int> wins = new Map<String, int> ();
  Map<String, int> losses = new Map<String, int> ();
  
  for(int i = 1; i <= numTeams; i++){
    wins["Team $i"] = 0;
    losses["Team $i"] = 0;
  }
  
  return new Standings( id: "Standings", 
    losses: losses, wins: wins);
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
  int numTeams, Standings standings, [List<num> initialChances]){
  if(numTeams % 2 != 0){
    throw new ArgumentError("NumTeams must be even");
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
          standings.wins[played.awayTeam]++;
          standings.losses[played.homeTeam]++;
        } else {
          standings.wins[played.homeTeam]++;
          standings.losses[played.awayTeam]++;
        }
      }
      games.add(played);
    }
  }
  
  return games;
}