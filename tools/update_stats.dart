import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import '../lib/calc_stats.dart';
import '../lib/database_api.dart';


Future<void> main() async {  
  apiUrl = "https://blaseball.com/database/";
  
  //overall blaseball status data
  SimulationData simData = await getSimulationData();
  //site data
  SiteData sitedata = await calcSiteData(simData);
  print(sitedata);
  
  //get subleague standings and calculate stats
  List<List<TeamStandings>> subStandings = await calcStats(simData);
  
  //print out data
  print(subStandings[0]);
  print(subStandings[1]);
  
  Directory temp = Directory.systemTemp;
  print(temp);
  
  String filenameJSON = temp.path + '/data/sitedata.json';
  var sinkJSON = new File(filenameJSON).openWrite();
  sinkJSON.write(json.encode(sitedata));
  sinkJSON.close();
  
  filenameJSON = temp.path + '/data/${sitedata.sub1id}.json';
  sinkJSON = new File(filenameJSON).openWrite();
  sinkJSON.write(json.encode(subStandings[0]));
  sinkJSON.close();
  
  filenameJSON = temp.path + '/data/${sitedata.sub2id}.json';
  sinkJSON = new File(filenameJSON).openWrite();
  sinkJSON.write(json.encode(subStandings[1]));
  sinkJSON.close();

  uploadFiles();

}

void uploadFiles() {
  Process.run('/usr/bin/aws', ['s3', 'cp', '/tmp/data/',
    's3://blaseball-status/data/', '--include="*.json"',
    '--recursive', '--acl=public-read']).then((ProcessResult results) {
    print(results.stdout);
    print(results.stderr);
  });

}



