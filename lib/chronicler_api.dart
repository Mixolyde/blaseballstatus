library chronicler_api;

import 'dart:convert';
import 'package:http/http.dart';
import 'database_api.dart';


String apiUrl = 'https://api.sibr.dev/chronicler/v1/';
String api2Url = 'https://api2.sibr.dev/chronicler/v0/';

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
      bool isPrizeMatch = (json['data']['isPrizeMatch'] as bool?) ?? false;
      bool isTitleMatch = (json['data']['isTitleMatch'] as bool?) ?? false;
      if( 
      (!includePostSeason && json['data']['isPostseason'] as bool) ||
      isPrizeMatch ||
      isTitleMatch
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


Future<List<Game>> getAllGames() async {
  var response = await get(Uri.parse(
    api2Url + "entities?kind=game" ));
  //print('Response body: ${response.body}');
  
  var games = <Game>[];
  List<dynamic> objects = json.decode(response.body)['items'];
  for (var o in objects) {
    games.add(Game.fromJson(o['data']));
  }

  return games;
}

