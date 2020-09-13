import 'dart:convert';
import 'dart:io';
import 'lib/database_api.dart';

void main() async {
  print('Beginning stat calculations');
  
  List<Team> teams = await getTeams();
  sortTeamsNotGrouped(teams);
  
  print('Got team records');

  final filenameJSON = 'web/wildstandings.json';
  var sinkJSON = new File(filenameJSON).openWrite();
  sinkJSON.write(json.encode(teams));
  sinkJSON.close();
  

}