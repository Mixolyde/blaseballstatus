import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import '../lib/calc_stats.dart';
import '../lib/database_api.dart';
import '../lib/sim_season.dart';
import '../lib/site_objects.dart';

/**
  Test script used for manually executing methods and testing
  functionality
**/
Future<void> main() async {  
  apiUrl = "https://blaseball.com/database/";
  
  //overall blaseball status data
  SimulationData simData = await getSimulationData();
  /*
    thisidisstaticyo
    113
    d8545021-e9fc-48a3-af74-48685950a183
    3
    14
    645cdd84-175f-42f1-a9f3-d9014d97ae3b
  */
  
  SimulationData oldSimData = new SimulationData(
    id: simData.id,
    day: 113,
    league: "d8545021-e9fc-48a3-af74-48685950a183",
    playOffRound: 3,
    season: 14,
    seasonId: "645cdd84-175f-42f1-a9f3-d9014d97ae3b",
    eraTitle: simData.eraTitle,
    subEraTitle: simData.subEraTitle,
  );

  //site data
  SiteData sitedata = await calcSiteData(oldSimData);
  print(sitedata);
  
  //get subleague standings and calculate stats
  List<List<TeamStandings>> subStandings = await calcStats(oldSimData);
  CompletePostseason postseason = await getCompletePostseason(oldSimData.season);
  
  print("CompletePostseason: $postseason");
  
}