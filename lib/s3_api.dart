library s3_api;

import 'dart:convert';
import 'package:http/http.dart';

import 'database_api.dart';
import 'calc_stats.dart';


String _apiUrl = "https://blaseball-status.s3.amazonaws.com/data/";

final String _sitedataUrl = _apiUrl + "sitedata.json";

Future<SiteData> getSiteData() async {
  var response = await get( _sitedataUrl );
  print('Url: $_sitedataUrl');
  print('Response body: ${response.body}');
  
  SiteData sitedata = SiteData.fromJson(json.decode(response.body));

  return sitedata;
}

Future<List<List<TeamStandings>>> getSubStandings(SiteData sitedata) async {
  var response = await get( _apiUrl + "${sitedata.sub1id}.json");
  print('Url: ${_apiUrl + sitedata.sub1id}.json');
  //print('Response body: ${response.body}');
  
  List<TeamStandings> sub1Standings = new List<TeamStandings>();
  json.decode(response.body).forEach((j){ 
    TeamStandings standings = TeamStandings.fromJson(j);
    
    sub1Standings.add(standings);
  });

  List<TeamStandings> sub2Standings;
  
  return [sub1Standings, sub2Standings];
}