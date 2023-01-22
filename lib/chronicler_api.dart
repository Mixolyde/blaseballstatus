library chronicler_api;

import 'dart:convert';
import 'package:http/http.dart';
import 'database_api.dart';

String api2Url = 'https://api2.sibr.dev/chronicler/v0/';

Future<List<Game>> getAllRegularSeasonGames(String seasonId) async {
  int daysInSeason = SimulationData.daysInRegularSeason(seasonId);
  var response = await get(Uri.parse(
    api2Url + "entities?kind=game" ));
  //print('Response body: ${response.body}');
  print("Getting games before $daysInSeason for season: $seasonId");
  
  List<dynamic> entities = json.decode(response.body)['items'];
  print("Entity count: ${entities.length}");
  
  var games = entities.expand((json) {
   try {
      bool isPrizeMatch = (json['data']['isPrizeMatch'] as bool?) ?? false;
      bool isTitleMatch = (json['data']['isTitleMatch'] as bool?) ?? false;
      if(isPrizeMatch || isTitleMatch || 
        (json['data']['day']! as int) >= daysInSeason ||
        (json['data']['seasonId']! as String) != seasonId
      ){
        return <Game>[];
      } else {
        return [Game.fromJson(json['data'])];
      }
    } catch (e) {
      print('Bad game json: $json');
      print(e);
      throw e;
      //return <Game>[];
    }
  }).toList();

  return games;
}

