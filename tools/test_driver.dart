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
  
  CompletePostseason postseason = await getCompletePostseason(simData.season);
  
  print("CompletePostseason: $postseason");
  
}