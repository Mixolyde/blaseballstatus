import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';
import '../lib/calc_stats.dart';
import '../lib/database_api.dart';
import '../lib/sim_season.dart';

const simCount = 'sim-count';

Future<void> main(List<String> args) async {  
  var parser = ArgParser();
  parser.addOption(simCount, abbr: 'c',  defaultsTo: '103');
  var results = parser.parse(args);
  var numSims = int.parse(results[simCount]);
  
  //overall blaseball status data
  var simData = await getSimulationData();

  //site data
  var sitedata = await calcSiteData(simData);
  print(sitedata);
  
  //get subleague standings and calculate stats
  var subStandings = await calcStats(simData);
  
  //print out data
  print(subStandings[0]);
  print(subStandings[1]);
  

  //numSims = 17;
  var postSeason = await getCompletePostseason(simData.season);
  var entries = 
      await calculatePlayoffBracketEntries(postSeason, subStandings);
      
  await calculateChances(subStandings, numSims, entries);

  
  var temp = Directory.systemTemp;
  print(temp);
  
  var dataDir = Directory(temp.path + '/data/');
  await dataDir.create(recursive: true);
  
  var filenameJSON = temp.path + '/data/sitedata.json';
  var sinkJSON = File(filenameJSON).openWrite();
  sinkJSON.write(json.encode(sitedata));
  await sinkJSON.close();
  
  filenameJSON = temp.path + '/data/entries.json';
  sinkJSON = File(filenameJSON).openWrite();
  sinkJSON.write(json.encode(entries));
  await sinkJSON.close();  
  
  filenameJSON = temp.path + '/data/${sitedata.sub1id}.json';
  sinkJSON = File(filenameJSON).openWrite();
  sinkJSON.write(json.encode(subStandings[0]));
  await sinkJSON.close();
  
  filenameJSON = temp.path + '/data/${sitedata.sub2id}.json';
  sinkJSON = File(filenameJSON).openWrite();
  sinkJSON.write(json.encode(subStandings[1]));
  await sinkJSON.close();

  var aws = File('/usr/bin/aws');
  var exists = await aws.exists();
  if(exists){
    uploadFiles();
  }

}

void uploadFiles() {
  Process.run('/usr/bin/aws', [
      's3', 'cp', '/tmp/data/',
      's3://blaseball-status/data/',
      '--include="*.json"', 
      '--recursive',
      '--acl=public-read', 
      '--content-type=application/json; charset=utf-8'
  ]).then((ProcessResult results) {
    print(results.stdout);
    print(results.stderr);
  });

}



