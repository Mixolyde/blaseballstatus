import 'package:test/test.dart';

import '../lib/chronicler_api.dart';
import '../lib/database_api.dart';

void main() {
  apiTests();
}

void apiTests() {
  group('games', () {
    /* TODO replace with new games method tests
    test('Get games first day of season', () async {
      var data = await getSimulationData();
      var current = await getGames(data.season, day:0);
      expect(current, isNotNull);
      expect(current.length, greaterThanOrEqualTo(10));
      expect(current[0], isNotNull);      
      print('Day 0 Game 0: ${current[0]}');
    });   
    test('Get games last day of season', () async {
      var data = await getSimulationData();
      var current = await getGames(data.season, day:98);
      expect(current, isNotNull);
      expect(current.length, greaterThanOrEqualTo(10));
      expect(current[0], isNotNull);      
      print('Day 98 Game 0: ${current[0]}');
    });     
    test('Get all regular season games of gamma8 season', () async {
      var data = await getSimulationData();
      var current = await getGames(0, sim:'gamma8');
      expect(current, isNotNull);
      expect(current.length, 12 * 99);
      expect(current[0], isNotNull);      
      print('Day 0 Game 0: ${current[0]}');
      print('Last Game: ${current.last}');
    }, timeout: Timeout(Duration(minutes: 4)));     
    test('Get all regular season games of gamma9 season', () async {
      var data = await getSimulationData();
      var current = await getGames(0, sim:'gamma9');
      expect(current, isNotNull);
      expect(current.length, 12 * 99);
      expect(current[0], isNotNull);      
      print('Day 0 Game 0: ${current[0]}');
      print('Last Game: ${current.last}');
    }, timeout: Timeout(Duration(minutes: 4)));  
    test('Get all regular season games of gamma10 season', () async {
      var data = await getSimulationData();
      var current = await getGames(0, sim:'gamma10');
      expect(current, isNotNull);
      expect(current.length, 12 * 162);
      expect(current[0], isNotNull);      
      print('Day 0 Game 0: ${current[0]}');
      print('Last Game: ${current.last}');
    }, timeout: Timeout(Duration(minutes: 4)));      
    test('Get all games of gamma8 season', () async {
      var data = await getSimulationData();
      var current = await getGames(0, sim:'gamma8', includePostSeason:true);
      expect(current, isNotNull);
      expect(current.length, 1209);
      expect(current[0], isNotNull);      
      print('Day 0 Game 0: ${current[0]}');
      print('Last Game: ${current.last}');
    }, timeout: Timeout(Duration(minutes: 4)));     
    test('Get all games of gamma9 season', () async {
      var data = await getSimulationData();
      var current = await getGames(0, sim:'gamma9', includePostSeason:true);
      expect(current, isNotNull);
      expect(current.length, 1219);
      expect(current[0], isNotNull);      
      print('Day 0 Game 0: ${current[0]}');
      print('Last Game: ${current.last}');
    }, timeout: Timeout(Duration(minutes: 4)));   
    */    
  });
  
}