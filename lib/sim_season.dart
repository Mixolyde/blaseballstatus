import 'dart:convert';
import 'package:intl/intl.dart';
import 'chronicler_api.dart';
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
  
  List<TeamSim> sims = new List<TeamSim>();
  standings.wins.forEach((id, count) {
    print("Creating TeamSim $id $count");
  });
  
  //simulate season 1,000 times and gather results
  _simulateSeason(games);
  
}

void _simulateSeason(List<Game> games){
  //get current standings
  
  //calculate "real" win rate"
  
  //simulate unplayed games
  
  //return standings

}

class TeamSim {
  String id;
  int actualWins;
  int wins;
  int losses;
  
  int actualWins_save;
  int wins_save;
  int losses_save;
  
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
  
  
  
}