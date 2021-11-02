library database_api;

import 'dart:convert';
import 'package:http/http.dart';

part 'src/game.dart';
part 'src/league.dart';
part 'src/playoffs.dart';
part 'src/season.dart';
part 'src/simulationdata.dart';
part 'src/standings.dart';
part 'src/team.dart';
part 'src/tiebreakers.dart';

//String _dbUrl = 'https://cors-proxy.blaseball-reference.com/database/';
String apiUrl = 'https://api.blaseball.com/';

final String _dbUrl = apiUrl + 'database/';


final String _ilbId = 'd8545021-e9fc-48a3-af74-48685950a183';
final String _allTeamsUrl = _dbUrl + 'allTeams';
final String _divisionUrl = _dbUrl + 'division?id=';
final String _leagueUrl = _dbUrl + 'league?id=' + _ilbId;
final String _playoffsUrl = _dbUrl + 'playoffs?number=';
final String _playoffMatchupsUrl = _dbUrl + 'playoffMatchups?ids=';
final String _playoffRoundUrl = _dbUrl + 'playoffRound?id=';
final String _scheduleUrl = apiUrl + 'api/games/schedule/';
final String _seasonUrl = _dbUrl + 'season?number=';
final String _simulationDataUrl = _dbUrl + 'simulationData';
final String _standingsUrl = _dbUrl + 'standings?id=';
final String _subleagueUrl = _dbUrl + 'subleague?id=';
final String _tiebreakersUrl = _dbUrl + 'tiebreakers?id=';
final String _streamDataUrl = apiUrl + 'events/streamData';

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
  //print("url: $_simulationDataUrl");
  var response = await get(Uri.parse(_simulationDataUrl));
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
  var teams = parsed.map((json) => Team.fromJson(json)).toList();
  return teams;
}

Future<List<Game>> getGames(int season, int day, {String sim = 'gamma8'}) async {
  var getGamesUrl = _scheduleUrl + '?startDay=$day&endDay=$day&season=$season&sim=$sim';
  print("GetGames URL: $getGamesUrl");
  var response = await get(Uri.parse(getGamesUrl));
  //print(response.body);
  Map<String, dynamic> parsed = json.decode(response.body);
  Map<String, dynamic> dayMap = parsed['games']! as Map<String, dynamic>;
  List<dynamic> gamesList= dayMap['$day']! as List<dynamic>;
  //print(gamesList);
  var games = gamesList.map((json) => Game.fromJson(json)).toList();
  return games;
}

Future<List<Game>> getAllGames(int season, {String sim = 'gamma8'}) async {
  var games = <Game>[];
  var getAllGamesUrl = _scheduleUrl + '?startDay=0&endDay=98&season=$season&sim=$sim';
  print("GetAllGames URL: $getAllGamesUrl");
  var response = await get(Uri.parse(getAllGamesUrl));
  //print(response.body);
  Map<String, dynamic> parsed = json.decode(response.body);

  for(var day = 0; day < 99; day++){
    Map<String, dynamic> dayMap = parsed['games']! as Map<String, dynamic>;
    List<dynamic> gamesList= dayMap['$day']! as List<dynamic>;
    //print(gamesList);
    var dayGames = gamesList.map((json) => Game.fromJson(json)).toList();
    games.addAll(dayGames);
  }

  return games;
}

Future<Tiebreakers> getTiebreakers(String id) async {
  var response = await get(Uri.parse(_tiebreakersUrl + id));
  var decjson = json.decode(response.body)[0];
  return Tiebreakers.fromJson(decjson);
}

Future<Playoffs?> getPlayoffs(int season) async {
  print('GetPlayoffs Request URL: ${_playoffsUrl + season.toString()}');
  var response = await get(Uri.parse(_playoffsUrl 
    + season.toString() ));
  //print('Response body: ***${response.body}***');
  if(response.body == '' 
    || response.body.contains('error')) {
    return null;
  } else {
    return Playoffs.fromJson(json.decode(response.body));
  }
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
  var matchups = parsed.map((json) => 
    PlayoffMatchup.fromJson(json)).toList();
  
  return matchups;
}

Future<CompletePostseason?> getCompletePostseason(int season) async {
  var playoffs = await getPlayoffs(season);
  if(playoffs == null){
    return null;
  }
  var playoffRounds = <String, PlayoffRound>{};
  var playoffMatchups = <String, PlayoffMatchup>{};
  
  await Future.forEach(playoffs.rounds, (String id) async {
    var round = await getPlayoffRound(id);
    playoffRounds[id] = round;
    print('Fetched round ${playoffRounds[id]} with ${playoffRounds[id]?.matchupIDs.length} matchupIDs');
    if (round.matchupIDs.isNotEmpty){
      var matchups = await getPlayoffMatchups(round.matchupIDs);
      matchups.forEach((matchup){
        playoffMatchups[matchup.id] = matchup;
      });
    }
  });
  
  return CompletePostseason(id: playoffs.id, playoffs: playoffs, 
    playoffRounds: playoffRounds, playoffMatchups: playoffMatchups);
}

Future<dynamic> getEventStreamData(String object) async {
  var response = await get(Uri.parse(_streamDataUrl ));
  Map<String, dynamic> responseMap = json.decode(response.body);
  Map<String, dynamic> dataMap = responseMap['data']! as Map<String, dynamic>;
  
  return dataMap[object]!;
}
