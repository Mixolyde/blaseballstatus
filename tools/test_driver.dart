import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import '../lib/calc_stats.dart';
import '../lib/database_api.dart';
import '../lib/sim_season.dart';
import '../lib/site_objects.dart';

Future<void> main() async {  
  apiUrl = "https://blaseball.com/database/";
  
  //overall blaseball status data
  SimulationData simData = await getSimulationData();
  
  //CompletePostseason postseason = await getCompletePostseason(simData.season);
  
  Playoffs playoffs = await getPlayoffs(simData.season);
  print(playoffs);
  
  playoffs.rounds.forEach((id) async {
    PlayoffRound round = await getPlayoffRound(id);
    print(round);
  });
  
  //wild card round matchups
  List<String> matchupIDs = [
    "3be7440a-7cd4-461c-ad22-fa256fe8d89b",
    "0f62a795-06c2-4339-901b-9e42b12538cc",
    "6a65a7a6-0a93-4127-b7df-d9488eeaf946",
    "2d307b56-7c11-4240-9ca2-aeede98fcd10",
    "f68e3812-9a67-4efd-80db-baeedc243e9f",
    "c295f9bf-d935-4da4-943e-b8d2ff34ce57",
    "7c6324e3-d5a9-48c5-b12d-3cbbc9eff617",
    "bb63e17e-257f-4b08-912a-033ac7c8ab8c"
  ];
  
  List<PlayoffMatchups> matchups = await getPlayoffMatchups(matchupIDs);
  matchups.forEach((matchup) async {
    print(matchup);
  });
  
  //round 2 matchups
  matchupIDs = [
    "b5b73c2f-811f-470e-926d-642d3207adc2",
    "a579bae8-aca2-45a7-8917-c66d62fb2699",
    "a2177f33-2045-472e-999a-0f8f4e05390a",
    "44bc4cc6-3ab8-4282-a9b8-7124b028494c"
  ];
  
  matchups = await getPlayoffMatchups(matchupIDs);
  matchups.forEach((matchup) async {
    print(matchup);
  });
}