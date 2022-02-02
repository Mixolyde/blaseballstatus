library chronicler_api;

import 'dart:convert';
import 'package:http/http.dart';
import 'database_api.dart';


String apiUrl = 'https://api.sibr.dev/chronicler/v1/';

final String _gamesUrl = apiUrl + 'games';

Future<List<Game>> getGames(int season, {int? day, 
  String sim = 'gamma10', bool includePostSeason = false}) async {
  String getGamesUrl = _gamesUrl + '?season=$season&sim=$sim';
  if(day != null){
    getGamesUrl += '&day=$day';
  }
  print("GetGames URL: $getGamesUrl");
  var response = await get(Uri.parse(getGamesUrl));
  //print(response.body);
  List<dynamic> gamesList = json.decode(response.body)['data'];
  List<Game> games = gamesList.expand((json) {
    try {
      if(!includePostSeason && json['data']['isPostseason'] as bool){
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


/*
Future<List<Game>> getAllGames(int season) async {
  var response = await get(Uri.parse(_gamesUrl 
    + season.toString() ));
  //print('Response body: ${response.body}');
  
  var games = <Game>[];
  List<dynamic> objects = json.decode(response.body)['data'];
  for (var o in objects) {
    games.add(Game.fromJson(o['data']));
  }

  return games;
}

*/
