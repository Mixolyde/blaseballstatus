import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import '../lib/calc_stats.dart';
import '../lib/database_api.dart';


Future<void> main() async {  
  apiUrl = "https://blaseball.com/database/";
  
  //site data
  print("Getting site data");
  SiteData sitedata = await calcSiteData();
  print(sitedata);
  
  //get subleague standings
  SimulationData simData = await getSimulationData();
  await calcStats(simData);
  
  //print out data
  print(subStandings[0]);
  print(subStandings[1]);
  
  Directory temp = Directory.systemTemp;
  print(temp);
  
  String filenameJSON = temp.path + '/sitedata.json';
  var sinkJSON = new File(filenameJSON).openWrite();
  sinkJSON.write(json.encode(sitedata));
  sinkJSON.close();
  
  filenameJSON = temp.path + '/${sitedata.sub1id}.json';
  sinkJSON = new File(filenameJSON).openWrite();
  sinkJSON.write(json.encode(subStandings[0]));
  sinkJSON.close();
  
  filenameJSON = temp.path + '/${sitedata.sub2id}.json';
  sinkJSON = new File(filenameJSON).openWrite();
  sinkJSON.write(json.encode(subStandings[1]));
  sinkJSON.close();

}