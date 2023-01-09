import 'dart:convert';
import 'dart:io';
// import 'package:intl/intl.dart';
import '../lib/calc_stats.dart';
import '../lib/chronicler_api.dart';
import '../lib/database_api.dart';
import '../lib/sim_season.dart';
import '../lib/site_objects.dart';


/// Test script used for manually executing methods and testing functionality.
Future<void> main() async {  
  //print(apiUrl);
  
  //overall blaseball status data
  var simData = await getSimulationData();
  print(simData);
  
  int gamesInRegularSeason = SimulationData.gamesInRegularSeason(simData.currentSeasonId);
  print(gamesInRegularSeason);
  /*
    {"phase":"restPhase",
    "startTime":"2023-01-05T23:01:00.000Z",
    "endTime":"2023-01-09T14:59:59.000Z",
    "startDayNumber":-1,
    "endDayNumber":-1,
    "simData":{
      "banner":null,
      "currentSeasonId":"cd1b6714-f4de-4dfc-a030-851b3459d8d1",
      "currentSeasonNumber":0,
      "currentDay":-1,
      "liveGames":false,
      "isTournament":false,
      "isOffseason":false,
      "currentLeagueData":{
        "id":"d3182b4d-91b6-4b4e-96a5-13d69e0043b7",
        "name":"Internet Blaseball League",
        "subLeagues":[{"id":"5335d626-db8c-4181-950a-e650f5f11d00",
          "divisions":[
            {"id":"8b22bdcf-8cf9-46d4-93da-bb75a6413786","name":"Awful Good"},
            {"id":"67a4acf7-60b6-463d-bcff-63fbf538b3d9","name":"Chaotic Good"}]},
          {"id":"226dc71f-b3a2-4d0d-814e-1b963781cda9",
          "divisions":[
            {"id":"b60a5664-66d8-462a-85ae-9da2d4d9c59e","name":"Awful Evil"},
            {"id":"0b684565-ecaf-4afc-96d2-f4100f127197","name":"Chaotic Evil"}]}]}}}
  */
  
  /*
  var oldSimData = SimulationData(
    id: simData.id,
    day: 113,
    league: 'd8545021-e9fc-48a3-af74-48685950a183',
    playOffRound: 3,
    season: 14,
    seasonId: '645cdd84-175f-42f1-a9f3-d9014d97ae3b',
    eraTitle: simData.eraTitle,
    subEraTitle: simData.subEraTitle,
    attributes: ['TEST1']
  );
  */

  //site data
  //var sitedata = await calcSiteData(oldSimData);
  //print(sitedata);
  
  //get subleague standings and calculate stats
  //List<List<TeamStandings>> subStandings = await calcStats(oldSimData);
  //CompletePostseason postseason = await getCompletePostseason(oldSimData.season);
  
  //print("CompletePostseason: $postseason");
  
  //var playoffs = await getPlayoffs(19);
  
  //print(playoffs);
  
  //var games = await getGames(0, 0, sim:simData.id);
  //print(games);
  //print('Count: ${games.length}');
  

  //var streamResult = await getEventStreamData(['games', 'standings']);
  //print(streamResult);
  
  //Standings standings = await getStandings();
  //print(standings);
  
  //var season = await getEventStreamData(['games', 'season']);
  //print (season);
  
  //var allGames = await getAllGames(simData.season, sim:simData.id);
  //print('All Count: ${allGames.length}');
  
  //Standings standings = await getStandings();
  //print('Standings $standings');
  
  //List<Game> games = await getGames(0, day:0);
  //print('Games Count: ${games.length}');

}
