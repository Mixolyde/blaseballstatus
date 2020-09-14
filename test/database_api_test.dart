import 'package:test/test.dart';

import '../lib/database_api.dart';

void main() {
  apiTests();
}

void apiTests() {
  group('api tests', () {
    int seasonNumber = 5;
    test('Current Season Number', () {
      expect(getCurrentSeasonNumber(), equals(seasonNumber));
    });
    test('Current Season', () async {
      Season current = await getCurrentSeason();
      expect(current, isNotNull);
      expect(current.seasonNumber, seasonNumber);
    });
    test('Current Standings', () async {
      Standings current = await getCurrentStandings();
      expect(current, isNotNull);
      expect(20, current.wins.length);
      expect(20, current.losses.length);
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
      expect(5, current.teams.length);
      print("Division: $current");
    });
    test('Get Tiebreakers', () async {
      League league = await getLeague();
      Tiebreakers current = await getTiebreakers(league.tiebreakersId);
      expect(current, isNotNull);
      expect(current.order, isNotNull);
      expect(20, current.order.length);
      print("$current");
    });  
  });

}
