library database_api;

import 'dart:convert';
import 'package:http/http.dart';

part 'league.dart';
part 'season.dart';
part 'sitedata.dart';
part 'standings.dart';
part 'team.dart';
part 'tiebreakers.dart';

final String _ilbId = "d8545021-e9fc-48a3-af74-48685950a183";

final String _allTeamsUrl = "https://www.blaseball.com/database/allTeams";
final String _divisionUrl = "https://www.blaseball.com/database/division?id=";
final String _gamesByDateUrl = "https://www.blaseball.com/database/games";
final String _leagueUrl = "https://www.blaseball.com/database/league?id=" 
  + _ilbId;
final String _seasonUrl = "https://www.blaseball.com/database/season?number=";
final String _standingsUrl = "https://www.blaseball.com/database/standings?id=";
final String _subleagueUrl = "https://www.blaseball.com/database/subleague?id=";
final String _tiebreakersUrl = "https://www.blaseball.com/database/tiebreakers?id=";


int getCurrentSeasonNumber(){
  // TODO: replace with API detection 
  return 6;
}

Future<Season> getCurrentSeason() async {
  var response = await get(_seasonUrl + "${getCurrentSeasonNumber()}");
  //print('Response body: ${response.body}');
  return Season.fromJson(json.decode(response.body));
}

Future<Standings> getCurrentStandings() async {
  var season = await getCurrentSeason();
  var response = await get(_standingsUrl + season.standings);
  //print('Response body: ${response.body}');
  var parsed = json.decode(response.body);
  var standings = Standings.fromJson(parsed);
  //print('Season: $season');
  return standings;
}

Future<Division> getDivision(String id) async {
  var response = await get(_divisionUrl + id);
  return Division.fromJson(json.decode(response.body));
}


Future<League> getLeague() async {
  var response = await get(_leagueUrl);
  return League.fromJson(json.decode(response.body));
}

Future<Subleague> getSubleague(String id) async {
  var response = await get(_subleagueUrl + id);
  return Subleague.fromJson(json.decode(response.body));
}

Future<List<Team>> getTeams() async {
  Standings standings = await getCurrentStandings();
  var response = await get(_allTeamsUrl);
  List<dynamic> parsed = json.decode(response.body);
  List<Team> teams = parsed.map((json) => Team.fromJson(json)).toList();
  teams.forEach((team) {
    team.wins = standings.wins[team.id];
    team.losses = standings.losses[team.id];
  });
  return teams;
}

Future<Tiebreakers> getTiebreakers(String id) async {
  var response = await get(_tiebreakersUrl + id);
  var decjson = json.decode(response.body)[0];
  return Tiebreakers.fromJson(decjson);
}


void main() {
  getCurrentSeason()
    .then((s) { 
      print(s);
    });
    
  getCurrentStandings()
    .then((s) { 
      print(s);
    });
  getTeams()
    .then((s) { 
      print(s);
    });  
    
}
