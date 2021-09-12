library s3_api;

import 'dart:convert';
import 'package:http/http.dart';
import 'site_objects.dart';

String _apiUrl = 'https://blaseball-status.s3.amazonaws.com/data/';

final String _sitedataUrl = _apiUrl + 'sitedata.json';
final String _entriesUrl = _apiUrl + 'entries.json';

Future<SiteData> getSiteData() async {
  var response = await get( Uri.parse(_sitedataUrl ));
  //print('SiteData Url: $_sitedataUrl');
  //print('Response body: ${response.body}');
  
  var sitedata = SiteData.fromJson(json.decode(response.body));

  return sitedata;
}

Future<List<PlayoffBracketEntry>> getPlayoffBracketEntries() async {
  var response = await get( Uri.parse(_entriesUrl ));
  //print('PlayoffBracketEntries Url: $_entriesUrl');
  //print('Response body: ${response.body}');
  
  var entries = <PlayoffBracketEntry>[];
  json.decode(response.body).forEach((j){ 
    var entry = PlayoffBracketEntry.fromJson(j);
    entries.add(entry);
  });

  return entries;

}

Future<List<List<TeamStandings>>> getSubStandings(SiteData sitedata) async {
  var response = await get( Uri.parse(_apiUrl + '${sitedata.sub1id}.json'));
  print('Standings 1 Url: ${_apiUrl + sitedata.sub1id}.json');
  //print('Response body: ${response.body}');
  
  var sub1Standings = decodeStandings(response.body);

  response = await get( Uri.parse(_apiUrl + '${sitedata.sub2id}.json'));
  print('Standings 2 Url: ${_apiUrl + sitedata.sub2id}.json');
  
  var sub2Standings = decodeStandings(response.body);
  
  return [sub1Standings, sub2Standings];
}

List<TeamStandings> decodeStandings(String body){
  var subStandings = <TeamStandings>[];
  json.decode(body).forEach((j){ 
    var standings = TeamStandings.fromJson(j);
    subStandings.add(standings);
  });
  
  return subStandings;
}
