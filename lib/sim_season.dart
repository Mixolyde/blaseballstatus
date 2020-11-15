import 'dart:convert';
import 'package:intl/intl.dart';
import 'calc_stats.dart';
import 'database_api.dart';

SimulationData simData;
Season season;
Standings standings;
List<Game> games;

Future<void> calculateChances() async {
  simData = await getSimulationData();
  season = await getSeason(simData.season);
  standings = await getStandings(season.standings);
  games = await getAllGames(simData.season);
  
  print(games[0]);
  
  List<TeamSim> sims = new List<TeamSim>();
  standings.wins.forEach((id, count) {
    //print("Creating TeamSim $id $count");
    int actualWins = games.where((g) =>
      (g.awayTeam == id && g.awayScore > g.homeScore) ||
      (g.homeTeam == id && g.homeScore > g.awayScore)).length;
    TeamSim sim = new TeamSim(id, actualWins,
      count, standings.losses[id]);
    sim.save();
    sims.add(sim);
    print(sim);
  });
  
  //simulate season X times and gather results
  simulateSeason(games, sims);
  
}

void simulateSeason(List<Game> games, List<TeamSim> sims){
  //simulate unplayed games
  games.where((g) => !g.gameComplete).forEach((g) {
    print("Simulate outcome of $g");
  });
  
}

class TeamSim {
  String id;
  int actualWins;
  int wins;
  int losses;
  
  int actualWins_save;
  int wins_save;
  int losses_save;
  
  TeamSim(this.id, this.actualWins, this.wins, this.losses);
  
  void save(){
    actualWins_save = actualWins;
    wins_save = wins;
    losses_save = losses;
  }
  
  void load(){
    actualWins = actualWins_save;
    wins = wins_save;
    losses = losses_save;
  }
  
  String toString() => "$id $actualWins-$losses ($wins - $losses)";
  
}