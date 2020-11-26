import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';
import 'calc_stats.dart';
import 'database_api.dart';
import 'site_objects.dart';

SimulationData simData;
Season season;
List<Game> games;
Random rand = new Random(0);

Future<void> calculateChances(List<List<TeamStandings>> subStandings, int numSims) async {
  simData = await getSimulationData();
  season = await getSeason(simData.season);
  games = await getAllGames(simData.season);
    
  print(games[0]);
  
  runSimulations(games, subStandings, numSims);
  
}

void runSimulations(List<Game> games, List<List<TeamStandings>> standings, 
  int numSims){
  Map<String, TeamSim> sims = mapTeamSims(standings, games);
  
  //simulate season X times and gather results
  Map<String, List<num>> counts = new Map<String, List<num>>();
  
  for (int count = 0; count < numSims; count++){
    simulateSeason(games, sims);
    
    //sort and count positions
    
    sims.values.forEach((sim) => sim.load());
  }  
  
  //update standings with counts / numSims and formatted
}

void simulateSeason(List<Game> games, Map<String, TeamSim> sims){
  //simulate unplayed games
  games.where((g) => !g.gameComplete).forEach((g) {
    TeamSim awaySim = sims[g.awayTeam];
    TeamSim homeSim = sims[g.homeTeam];
    //print("Simulate outcome of $g");
    num awayChance = .5;
    if(awaySim.actualWins_save != homeSim.actualWins_save ||
      awaySim.losses_save != homeSim.losses_save){
      //print("Uneven match: ${awaySim.actualWins_save}-${awaySim.losses_save} vs. " +
      //  "${homeSim.actualWins_save}-${homeSim.losses_save}");
      //Pa = (WPa * (1 - WPh)) / 
      // ((WPa * (1 - WPh) + WPh * ( 1 - WPa)))
      num WPa = awaySim.wins_save / (awaySim.losses_save + awaySim.wins_save);
      num WPh = homeSim.wins_save / (homeSim.losses_save + homeSim.wins_save);
      awayChance = (WPa * (1 - WPh)) / 
       ((WPa * (1 - WPh) + WPh * ( 1 - WPa)));
    }
    print("Calculated away win chance: $awayChance");    
    if(rand.nextDouble() < awayChance){
      awaySim.actualWins++;
      awaySim.wins++;
      homeSim.losses++;
    } else {
      homeSim.actualWins++;
      homeSim.wins++;
      awaySim.losses++;        
    }    
  });
  
}

Map<String, TeamSim> mapTeamSims(List<List<TeamStandings>> standings, List<Game> games){
  Map<String, TeamSim> sims = new Map<String, TeamSim>();
  standings.forEach((standingsList) {
    standingsList.forEach((standing) {
      int actualWins = games.where((g) =>
        (g.awayTeam == standing.id && g.awayScore > g.homeScore) ||
        (g.homeTeam == standing.id && g.homeScore > g.awayScore)).length;
      TeamSim sim = new TeamSim(standing.id, actualWins,
        standing.wins, standing.losses);
      sim.save();
      sims[sim.id] = sim;
    });
  });
  return sims;
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
  
  String toString() => "$id Wins $wins Record: ($actualWins - $losses) " +
    "Saved: $actualWins_save $wins_save $losses_save";
  
}