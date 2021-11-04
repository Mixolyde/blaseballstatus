// import 'dart:convert';
// import 'dart:io';
// import 'package:intl/intl.dart';
import '../lib/calc_stats.dart';
import '../lib/database_api.dart';
// import '../lib/sim_season.dart';
// import '../lib/site_objects.dart';

import "../lib/eventsource/eventsource.dart";


/// Test script used for manually executing methods and testing functionality.
Future<void> main() async {  
  print(apiUrl);
  
  //overall blaseball status data
  var simData = await getSimulationData();
  print(simData);
  /*
    thisidisstaticyo
    113
    d8545021-e9fc-48a3-af74-48685950a183
    3
    14
    645cdd84-175f-42f1-a9f3-d9014d97ae3b
  */
  
  var oldSimData = SimulationData(
    id: simData.id,
    day: 113,
    league: 'd8545021-e9fc-48a3-af74-48685950a183',
    playOffRound: 3,
    season: 14,
    seasonId: '645cdd84-175f-42f1-a9f3-d9014d97ae3b',
    eraTitle: simData.eraTitle,
    subEraTitle: simData.subEraTitle,
    attributes: ['TEST1']
  );

  //site data
  var sitedata = await calcSiteData(oldSimData);
  print(sitedata);
  
  //get subleague standings and calculate stats
  //List<List<TeamStandings>> subStandings = await calcStats(oldSimData);
  //CompletePostseason postseason = await getCompletePostseason(oldSimData.season);
  
  //print("CompletePostseason: $postseason");
  
  //var playoffs = await getPlayoffs(19);
  
  //print(playoffs);
  
  var games = await getGames(0, 0, sim:simData.id);
  print(games);
  print('Count: ${games.length}');
  
  //var allGames = await getAllGames(0, sim:simData.id);
  //print('All Count: ${allGames.length}');
  
  //var streamResult = await getEventStreamData(['games', 'standings']);
  //print(streamResult);
  
  Standings standings = await getStandings();
  print(standings);
  
}
