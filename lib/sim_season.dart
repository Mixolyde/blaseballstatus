import 'dart:convert';
import 'package:intl/intl.dart';
import 'chronicler_api.dart';
import 'calc_stats.dart';

void calculateChances(int season) async {
  List<Game> games = getGames(season);
  //get records for completed games
  
  //simulate season 1,000 times and gather results
  simulateSeason(games);
  
}

void simulateSeason(List<Game> games){

}