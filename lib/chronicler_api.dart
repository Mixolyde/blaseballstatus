library chronicler_api;

import 'dart:convert';
import 'package:http/http.dart';
import 'database_api.dart';


String apiUrl = 'https://api.sibr.dev/chronicler/v1/';

final String _gamesUrl = apiUrl + 'games?season=';

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
