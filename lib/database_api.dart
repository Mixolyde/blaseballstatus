library database_api;

import 'dart:convert';
import 'package:http/http.dart';
import 'site_objects.dart';

part 'src/game.dart';
part 'src/league.dart';
part 'src/playoffs.dart';
part 'src/season.dart';
part 'src/simulationdata.dart';
part 'src/standings.dart';
part 'src/team.dart';
part 'src/tiebreakers.dart';

String apiUrl = "https://cors-proxy.blaseball-reference.com/database/";

final String _ilbId = "d8545021-e9fc-48a3-af74-48685950a183";
final String _allTeamsUrl = apiUrl + "allTeams";
final String _divisionUrl = apiUrl + "division?id=";
final String _gamesByDateUrl = apiUrl + "games";
final String _leagueUrl = apiUrl + "league?id=" + _ilbId;
final String _playoffsUrl = apiUrl + "playoffs?number=";
final String _playoffMatchupsUrl = apiUrl + "playoffMatchups?ids=";
final String _playoffRoundUrl = apiUrl + "playoffRound?id=";
final String _seasonUrl = apiUrl + "season?number=";
final String _simulationDatUrl = apiUrl + "simulationData";
final String _standingsUrl = apiUrl + "standings?id=";
final String _subleagueUrl = apiUrl + "subleague?id=";
final String _tiebreakersUrl = apiUrl + "tiebreakers?id=";

Future<Season> getSeason(int season) async {
  var response = await get(Uri.parse(_seasonUrl 
    + season.toString()) );
  //print('Response body: ${response.body}');
  return Season.fromJson(json.decode(response.body));
}

Future<Standings> getStandings(String standingsId) async {
  var response = await get(Uri.parse(_standingsUrl + standingsId));
  //print('Response body: ${response.body}');
  var parsed = json.decode(response.body);
  var standings = Standings.fromJson(parsed);
  //print('Season: $season');
  return standings;
}

Future<Division> getDivision(String id) async {
  var response = await get(Uri.parse(_divisionUrl + id));
  return Division.fromJson(json.decode(response.body));
}


Future<League> getLeague() async {
  var response = await get(Uri.parse(_leagueUrl));
  return League.fromJson(json.decode(response.body));
}

Future<SimulationData> getSimulationData() async {
  var response = await get(Uri.parse(_simulationDatUrl));
  //print('Response body: ${response.body}');
  return SimulationData.fromJson(json.decode(response.body));
}

Future<Subleague> getSubleague(String id) async {
  var response = await get(Uri.parse(_subleagueUrl + id));
  return Subleague.fromJson(json.decode(response.body));
}

Future<List<Team>> getTeams() async {
  var response = await get(Uri.parse(_allTeamsUrl));
  List<dynamic> parsed = json.decode(response.body);
  List<Team> teams = parsed.map((json) => Team.fromJson(json)).toList();
  return teams;
}

Future<List<Game>> getGames(int season, int day) async {
  var response = await get(Uri.parse(_gamesByDateUrl + "?day=$day&season=$season"));
  List<dynamic> parsed = json.decode(response.body);
  List<Game> games = parsed.map((json) => Game.fromJson(json)).toList();
  return games;
}

Future<List<Game>> getAllGames(int season) async {
  List<Game> games = new List<Game>();
  for(int day = 0; day < 130; day++){
    //print("Getting day games: Season $season Day $day");
    List<Game> dayGames = await getGames(season, day);
    games.addAll(dayGames);
  }

  return games;
}

Future<Tiebreakers> getTiebreakers(String id) async {
  var response = await get(Uri.parse(_tiebreakersUrl + id));
  var decjson = json.decode(response.body)[0];
  return Tiebreakers.fromJson(decjson);
}

Future<Playoffs> getPlayoffs(int season) async {
  print('GetPlayoffs Request URL: ${_playoffsUrl + season.toString()}');
  var response = await get(Uri.parse(_playoffsUrl 
    + season.toString() ));
  //print('Response body: ***${response.body}***');
  if(response.body == null || response.body == "" 
    || response.body.contains("error"))
    return null;
  else
    return Playoffs.fromJson(json.decode(response.body));
}

Future<PlayoffRound> getPlayoffRound(String roundID) async {
  var response = await get(Uri.parse(_playoffRoundUrl + roundID ));
  //print('Response body: ${response.body}');
  return PlayoffRound.fromJson(json.decode(response.body));
}

Future<List<PlayoffMatchup>> getPlayoffMatchups(List<String> matchIDs) async {
  var response = await get(Uri.parse(_playoffMatchupsUrl 
    + matchIDs.join(',')));
  //print('Response body: ${response.body}');
  List<dynamic> parsed = json.decode(response.body);
  List<PlayoffMatchup> matchups = parsed.map((json) => 
    PlayoffMatchup.fromJson(json)).toList();
  
  return matchups;
}

Future<CompletePostseason> getCompletePostseason(int season) async {
  Playoffs playoffs = await getPlayoffs(season);
  if(playoffs == null){
    return null;
  }
  Map<String, PlayoffRound> playoffRounds = new Map<String, PlayoffRound>();
  Map<String, PlayoffMatchup> playoffMatchups = new Map<String, PlayoffMatchup>();
  
  await Future.forEach(playoffs.rounds, (id) async {
    playoffRounds[id] = await getPlayoffRound(id);
    print("Fetched round ${playoffRounds[id]} with ${playoffRounds[id].matchupIDs.length} matchupIDs");
    if (playoffRounds[id].matchupIDs.length > 0){
      List<PlayoffMatchup> matchups = await 
        getPlayoffMatchups(playoffRounds[id].matchupIDs);
      if(matchups != null){
        matchups.forEach((matchup){
          playoffMatchups[matchup.id] = matchup;
        });
      }
    }
  });
  
  return new CompletePostseason(id: playoffs.id, playoffs: playoffs, 
    playoffRounds: playoffRounds, playoffMatchups: playoffMatchups);
}
