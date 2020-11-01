import 'package:test/test.dart';

import '../lib/database_api.dart';
import '../lib/calc_stats.dart';
import '../lib/s3_api.dart';

void main() {
  apiTests();
}

void apiTests() {
  group('api tests', () {
    int seasonNumber = 9;
    test('Current Site Data', () async {
      SiteData data = await getSiteData();
      expect(data.season, greaterThan(seasonNumber));
    });
    test('Current Standings', () async {
      SiteData data = await getSiteData();
      List<List<TeamStandings>> subStandings = await getSubStandings(data);
      expect(subStandings[0], isNotNull);
    });
  });
}