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
  //site data
  SiteData sitedata = await calcSiteData(simData);
  print(sitedata);
  
  //get subleague standings and calculate stats
  List<List<TeamStandings>> subStandings = await calcStats(simData);
  
  //print out data
  print(subStandings[0]);
  print(subStandings[1]);
  
  var chances = await calculateChances();
  
  Directory temp = Directory.systemTemp;
  print(temp);
  
  Directory dataDir = new Directory(temp.path + '/data/');
  await dataDir.create(recursive: true);
  
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

  File aws = new File("/usr/bin/aws");
  bool exists = await aws.exists();
  if(exists){
    uploadFiles();
  }

}

void uploadFiles() {
  Process.run('/usr/bin/aws', ['s3', 'cp', '/tmp/data/',
    's3://blaseball-status/data/', '--include="*.json"',
    '--recursive', '--acl=public-read']).then((ProcessResult results) {
    print(results.stdout);
    print(results.stderr);
  });

}



