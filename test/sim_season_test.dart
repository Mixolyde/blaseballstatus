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
          "Team 1", "Team 2"));
        games.add(createRandomGame(i, false,
          "Team 3", "Team 4"));
      }
      List<TeamSim> sims = new List<TeamSim>();
      for(int i = 1; i < 5; i++){
        sims.add(new TeamSim("Team $i", 0, 0, 0));
      };
      
      simulateSeason(games, sims);
      sims.forEach((sim){
        //expect(sim.actualWins == sim.wins, true);
        //expect(sim.actualWins + sim.losses, 10);
        
      });
    
    });
  });
  
}

Game createRandomGame(int day, bool completed, 
  String home, String away){
  int homeScore = 0;
  int awayScore = 0;
  if(completed){
    homeScore = rand.nextInt(20);
    awayScore = rand.nextInt(20);
    if(homeScore == awayScore){
      homeScore++;
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