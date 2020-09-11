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
  });

}
