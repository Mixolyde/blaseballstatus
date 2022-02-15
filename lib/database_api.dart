library database_api;

import 'dart:convert';
import 'package:http/http.dart';
import 'eventsource/eventsource.dart';

part 'src/game.dart';
part 'src/league.dart';
part 'src/playoffs.dart';
part 'src/simulationdata.dart';
part 'src/standings.dart';
part 'src/team.dart';
part 'src/tiebreakers.dart';

String apiUrl = 'https://api.blaseball.com/';

final String _dbUrl = apiUrl + 'database/';

final String _ilbId = '4b1a2354-f90a-40ad-9c05-d4c271c5a765';
final String _allTeamsUrl = _dbUrl + 'allTeams';
final String _divisionUrl = _dbUrl + 'division?id=';
final String _leagueUrl = _dbUrl + 'league?id=' + _ilbId;
final String _playoffsUrl = _dbUrl + 'playoffs?number=';
final String _playoffMatchupsUrl = _dbUrl + 'playoffMatchups?ids=';
final String _playoffRoundUrl = _dbUrl + 'playoffRound?id=';
final String _scheduleUrl = apiUrl + 'api/games/schedule/';
final String _simulationDataUrl = _dbUrl + 'simulationData';
final String _standingsUrl = apiUrl + 'api/standings';
final String _subleagueUrl = _dbUrl + 'subleague?id=';
final String _tiebreakersUrl = _dbUrl + 'tiebreakers?id=';
final String _streamDataUrl = apiUrl + 'events/streamData';

Future<Standings> getStandings() async {
  var response = await get(Uri.parse(_standingsUrl));
  var standings = Standings.fromJson(json.decode(response.body));
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

Future<CompletePostseason?> getCurrentPostseason() async {
  //var postseasons = games['postseasons'] as List<dynamic>;
  //print (postseasons);
  //if(postseasons.length == 0 || postseasons[0]!.keys.length == 0){
    print("Returning null CurrentPostseason");
    return null;
  //} else {
  //  return CompletePostseason.fromStreamData(postseasons[0]!);
  //}
  
}

Future<CompletePostseason?> getCompletePostseason(int season) async {
  var playoffs = await getPlayoffs(season);
  if(playoffs == null){
    return null;
  }
  
  return buildCompletePostseason(playoffs);
}

Future<CompletePostseason> buildCompletePostseason(Playoffs playoffs) async {

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
