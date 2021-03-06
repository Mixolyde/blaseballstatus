import 'package:test/test.dart';

import '../lib/database_api.dart';
import '../lib/calc_stats.dart';
import '../lib/s3_api.dart';
import '../lib/site_objects.dart';

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
      expect(subStandings[0].length, greaterThanOrEqualTo(10));
      expect(subStandings[0][0].id, isNotNull);
      expect(subStandings[0][9].gbDiv, isNot('-'));
      expect(subStandings[0][9].gbWc, isNot('-'));
      expect(subStandings[0][0].winning[0], isNot('-'));
      expect(subStandings[0][0].partytime[0], isNot('-'));      
      
      expect(subStandings[1], isNotNull);
      expect(subStandings[1].length, greaterThanOrEqualTo(10));
      expect(subStandings[1][0].id, isNotNull);
      expect(subStandings[1][9].gbDiv, isNot('-'));
      expect(subStandings[1][9].gbWc, isNot('-'));      
      expect(subStandings[1][0].winning[0], isNot('-'));
      expect(subStandings[1][0].partytime[0], isNot('-'));        
    });
  });
}