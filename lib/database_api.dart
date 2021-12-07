library database_api;

import 'dart:convert';
import 'package:http/http.dart';
import 'eventsource/eventsource.dart';

part 'src/game.dart';
part 'src/league.dart';
part 'src/playoffs.dart';
part 'src/season.dart';
part 'src/simulationdata.dart';
part 'src/standings.dart';
part 'src/team.dart';
part 'src/tiebreakers.dart';

String apiUrl = 'https://api.blaseball.com/';

final String _dbUrl = apiUrl + 'database/';

final String _ilbId = '09431fe6-a974-480b-9a7a-d75d14eeb117';
final String _allTeamsUrl = _dbUrl + 'allTeams';
final String _divisionUrl = _dbUrl + 'division?id=';
final String _leagueUrl = _dbUrl + 'league?id=' + _ilbId;
final String _playoffsUrl = _dbUrl + 'playoffs?number=';
final String _playoffMatchupsUrl = _dbUrl + 'playoffMatchups?ids=';
final String _playoffRoundUrl = _dbUrl + 'playoffRound?id=';
final String _scheduleUrl = apiUrl + 'api/games/schedule/';
final String _simulationDataUrl = _dbUrl + 'simulationData';
final String _subleagueUrl = _dbUrl + 'subleague?id=';
final String _tiebreakersUrl = _dbUrl + 'tiebreakers?id=';
final String _streamDataUrl = apiUrl + 'events/streamData';

Future<Season> getSeason() async {
  var parsed = await getEventStreamData(['games', 'season']);
  var season = Season.fromJson(parsed);
  print(season);
  return season;
}

Future<Standings> getStandings() async {
  var parsed = await getEventStreamData(['games', 'standings']);
  var standings = Standings.fromJson(parsed);
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
  Map<String, dynamic> dayMap = json.decode(response.body);
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
  Map<String, dynamic> dayMap = json.decode(response.body);

  for(var day = 0; day < 99; day++){
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
      for (var matchup in matchups) {
        playoffMatchups[matchup.id] = matchup;
      }
    }
  });
  
  return CompletePostseason(id: playoffs.id, playoffs: playoffs, 
    playoffRounds: playoffRounds, playoffMatchups: playoffMatchups);
}

Future<dynamic> getEventStreamData(List<String> objects) async {
  print("StreamDataUrl: $_streamDataUrl");
  EventSource eventSource = await EventSource
      .connect(_streamDataUrl);
  
  var event = await eventSource.first;
  //print("data: ${event.data}");  
  Map<String, dynamic> responseMap = json.decode(event.data!)['value']!;
  print('ResponseMap Keys: ' + responseMap.keys.join(' '));
  var resultMap = responseMap;
  for (var object in objects ){
    print("Checking resultMap for key: $object");
    resultMap = resultMap[object]! as Map<String, dynamic>;
    print(resultMap.keys.join(' '));
  }

  return resultMap;
}
