library database_api;

import 'dart:convert';
import 'package:http/http.dart';

part 'league.dart';
part 'season.dart';
part 'simulationdata.dart';
part 'sitedata.dart';
part 'standings.dart';
part 'team.dart';
part 'tiebreakers.dart';

String apiUrl = "https://cors-proxy.blaseball-reference.com/database/";

final String _ilbId = "d8545021-e9fc-48a3-af74-48685950a183";
final String _allTeamsUrl = apiUrl + "allTeams";
final String _divisionUrl = apiUrl + "division?id=";
final String _gamesByDateUrl = apiUrl + "games";
final String _leagueUrl = apiUrl + "league?id=" 
  + _ilbId;
final String _seasonUrl = apiUrl + "season?number=";
final String _simulationDatUrl = apiUrl + "simulationData";
final String _standingsUrl = apiUrl + "standings?id=";
final String _subleagueUrl = apiUrl + "subleague?id=";
final String _tiebreakersUrl = apiUrl + "tiebreakers?id=";

Future<Season> getSeason(int season) async {
  var response = await get(_seasonUrl 
    + season.toString() );
  //print('Response body: ${response.body}');
  return Season.fromJson(json.decode(response.body));
}

Future<Standings> getStandings(String standingsId) async {
  var response = await get(_standingsUrl + standingsId);
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

Future<SimulationData> getSimulationData() async {
  var response = await get(_simulationDatUrl);
  //print('Response body: ${response.body}');
  return SimulationData.fromJson(json.decode(response.body));
}

Future<Subleague> getSubleague(String id) async {
  var response = await get(_subleagueUrl + id);
  return Subleague.fromJson(json.decode(response.body));
}

Future<List<Team>> getTeams() async {
  //Standings standings = await getCurrentStandings();
  var response = await get(_allTeamsUrl);
  List<dynamic> parsed = json.decode(response.body);
  List<Team> teams = parsed.map((json) => Team.fromJson(json)).toList();
  //teams.forEach((team) {
  //  team.wins = standings.wins[team.id];
  //  team.losses = standings.losses[team.id];
  //});
  return teams;
}

Future<Tiebreakers> getTiebreakers(String id) async {
  var response = await get(_tiebreakersUrl + id);
  var decjson = json.decode(response.body)[0];
  return Tiebreakers.fromJson(decjson);
}
