import 'package:test/test.dart';

import '../lib/database_api.dart';
import '../lib/site_objects.dart';

void main() {
  apiTests();
}

void apiTests() {
  apiUrl = "https://blaseball.com/database/";
  group('api tests', () {
    int seasonNumber = 5;
    int teamCount = 20;
    int divisionCount = 5;
    test('Current Simulation Data', () async {
      SimulationData data = await getSimulationData();
      expect(data.season, greaterThan(seasonNumber));
      expect(data.id, "thisidisstaticyo");
    });
    test('Current Season', () async {
      SimulationData data = await getSimulationData();
      Season current = await getSeason(data.season);
      expect(current, isNotNull);
      expect(current.seasonNumber, greaterThan(seasonNumber));
      expect(current.id, data.seasonId);
    });
    test('Current Standings', () async {
      SimulationData data = await getSimulationData();
      Season season = await getSeason(data.season);
      Standings current = await getStandings(season.standings);
      expect(current, isNotNull);
      expect(current.wins.length, teamCount);
      expect(current.losses.length, teamCount);
    });
    test('Get League', () async {
      League current = await getLeague();
      expect(current, isNotNull);
      expect("Internet League Blaseball", current.name);
      expect(current.subleagueId1, isNotNull);
      expect(current.subleagueId2, isNotNull);
      print("League: $current");
    });
    test('Get Subleague', () async {
      League league = await getLeague();
      Subleague current = await getSubleague(league.subleagueId1);
      expect(current, isNotNull);
      expect(current.divisionId1, isNotNull);
      expect(current.divisionId2, isNotNull);
      print("Subleague: $current");
    });
    test('Get Division', () async {
      League league = await getLeague();
      Subleague subleague = await getSubleague(league.subleagueId1);
      Division current = await getDivision(subleague.divisionId1);
      expect(current, isNotNull);
      expect(current.teams, isNotNull);
      expect(current.teams.length, divisionCount);
      print("Division: $current");
    });
    test('Get Tiebreakers', () async {
      League league = await getLeague();
      Tiebreakers current = await getTiebreakers(league.tiebreakersId);
      expect(current, isNotNull);
      expect(current.order, isNotNull);
      expect(current.order.length, 20);
      print("$current");
    });  
    test('Get games first day of season', () async {
      SimulationData data = await getSimulationData();
      List<Game> current = await getGames(data.season, 0);
      expect(current, isNotNull);
      expect(current.length, 10);
      expect(current[0], isNotNull);      
      print("Day 0 Game 0: ${current[0]}");
    });   
    test('Get games last day of season', () async {
      SimulationData data = await getSimulationData();
      List<Game> current = await getGames(data.season, 98);
      expect(current, isNotNull);
      expect(current.length, 10);
      expect(current[0], isNotNull);      
      print("Day 98 Game 0: ${current[0]}");
    });     
  });

}
