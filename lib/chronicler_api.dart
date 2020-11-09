library chronicler_api;

import 'dart:convert';
import 'package:http/http.dart';


String apiUrl = "https://api.sibr.dev/chronicler/v1/";

final String _gamesUrl = = apiUrl + "games?season=";

Future<List<Game>> getGames(int season) async {
  var response = await get(_gamesUrl 
    + season.toString() );
  print('Response body: ${response.body}');
  
  List<Game>> games = new List<Game>();

  return games;
}

/*
Completed Game
{"gameId":"0a1061c6-b177-497a-9a0a-40b880804d9b",
"startTime":"2020-10-12T16:00:01.014248Z",
"endTime":"2020-10-12T16:28:48.616516Z",
"data":{"id":"0a1061c6-b177-497a-9a0a-40b880804d9b",
"day":0,
"phase":6,
"rules":"4ae9d46a-5408-460a-84fb-cbd8d03fff6c",
"shame":false,"inning":8,"season":9,"weather":9,
"awayOdds":0.5255458872371762,
"awayTeam":"b63be8c2-576a-4d6e-8daf-814f8bcea96f",
"homeOdds":0.4744541127628238,
"homeTeam":"3f8bbb15-61c0-4e3f-8e4a-907a5fb1565e",
"outcomes":[],"awayBases":5,"awayScore":7,
"finalized":true,"gameStart":true,
"homeBases":5,"homeScore":4,
"statsheet":"f0b00e74-087c-42ce-8e95-766cced4a30a",
"atBatBalls":0,"awayBatter":null,"homeBatter":null,
"lastUpdate":"Game over.",
"awayPitcher":"a38ada0a-aeac-4a3d-b9a5-968687ccd2f9",
"awayStrikes":3,"baseRunners":[],
"homePitcher":"ff5a37d9-a6dd-49aa-b6fb-b935fd670820",
"homeStrikes":3,"repeatCount":0,"seriesIndex":1,
"terminology":"b67e9bbb-1495-4e1b-b517-f1444b0a6c8b",
"topOfInning":false,"atBatStrikes":0,
"awayTeamName":"Miami Dale",
"gameComplete":true,
"homeTeamName":"Boston Flowers",
"isPostseason":false,
"seriesLength":3,
"awayTeamColor":"#9141ba",
"awayTeamEmoji":"0x1F6A4",
"basesOccupied":[],
"homeTeamColor":"#f7d1ff",
"homeTeamEmoji":"0x1F339",
"awayBatterName":"","halfInningOuts":0,
"homeBatterName":"","awayPitcherName":"Sixpack Santiago",
"baseRunnerNames":[],"baserunnerCount":0,
"halfInningScore":0,"homePitcherName":"Dunn Keyes",
"awayTeamNickname":"Dale","homeTeamNickname":"Flowers",
"awayTeamBatterCount":41,"homeTeamBatterCount":33,
"awayTeamSecondaryColor":"#cd76fa",
"homeTeamSecondaryColor":"#f7d1ff"}
}
Unplayed Game
{"gameId":"c814d7fc-682d-48f9-9e08-1a22a138fc8d",
"startTime":null,"endTime":null,
"data":{"id":"c814d7fc-682d-48f9-9e08-1a22a138fc8d",
"day":98,"phase":0,
"rules":"4ae9d46a-5408-460a-84fb-cbd8d03fff6c",
"shame":false,"inning":0,"season":9,
"weather":11,
"awayOdds":0,"awayTeam":"3f8bbb15-61c0-4e3f-8e4a-907a5fb1565e",
"homeOdds":0,"homeTeam":"b63be8c2-576a-4d6e-8daf-814f8bcea96f",
"outcomes":[],"awayBases":5,"awayScore":0,
"finalized":false,"gameStart":false,
"homeBases":5,"homeScore":0,
"statsheet":"5b4fcbe6-797c-42ed-a57d-0f6f9653f7c0",
"atBatBalls":0,"awayBatter":null,"homeBatter":null,
"lastUpdate":"","awayPitcher":null,"awayStrikes":3,
"baseRunners":[],"homePitcher":null,"homeStrikes":3,
"repeatCount":0,"seriesIndex":3
,"terminology":"b67e9bbb-1495-4e1b-b517-f1444b0a6c8b",
"topOfInning":true,"atBatStrikes":0,
"awayTeamName":"Boston Flowers",
"gameComplete":false,
"homeTeamName":"Miami Dale","isPostseason":false,
"seriesLength":3,"awayTeamColor":"#f7d1ff",
"awayTeamEmoji":"0x1F339","basesOccupied":[],
"homeTeamColor":"#9141ba","homeTeamEmoji":"0x1F6A4",
"awayBatterName":"","halfInningOuts":0,
"homeBatterName":"","awayPitcherName":"",
"baseRunnerNames":[],"baserunnerCount":0,
"halfInningScore":0,"homePitcherName":"",
"awayTeamNickname":"Flowers",
"homeTeamNickname":"Dale","awayTeamBatterCount":0,
"homeTeamBatterCount":0,"awayTeamSecondaryColor":"#f7d1ff",
"homeTeamSecondaryColor":"#cd76fa"}}
*/
class Game {
  String gameId;
  int day;
  bool gameComplete;
  
  
}