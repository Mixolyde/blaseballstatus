import 'package:test/test.dart';

import '../lib/s3_api.dart';

void main() {
  apiTests();
}

void apiTests() {
  group('api tests', () {
    var seasonNumber = 9;
    test('Current Site Data', () async {
      var data = await getSiteData();
      expect(data.season, greaterThan(seasonNumber));
    });
    test('Current Standings', () async {
      var data = await getSiteData();
      var subStandings = await getSubStandings(data);
      expect(subStandings[0], isNotNull);
      expect(subStandings[0].length, greaterThanOrEqualTo(2));
      expect(subStandings[0][0].id, isNotNull);
      expect(subStandings[0].last.gbDiv, isNot('-'));
      expect(subStandings[0].last.gbWc, isNot('-'));
      expect(subStandings[0][0].winning[0], isNot('-'));
      expect(subStandings[0][0].partytime[0], isNot('-'));      
      
      expect(subStandings[1], isNotNull);
      expect(subStandings[1].length, greaterThanOrEqualTo(2));
      expect(subStandings[1][0].id, isNotNull);
      expect(subStandings[1].last.gbDiv, isNot('-'));
      expect(subStandings[1].last.gbWc, isNot('-'));      
      expect(subStandings[1][0].winning[0], isNot('-'));
      expect(subStandings[1][0].partytime[0], isNot('-'));        
    });
    test('Current playoff entries', () async {
      var entries = await getPlayoffBracketEntries();
      expect(entries.length, 19);
    });
  });
}
