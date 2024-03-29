import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';

import '../tools/update_stats.dart' as update;
import '../lib/s3_api.dart';
import '../lib/site_objects.dart';

void main() { 
  group('update tests', () {
    test('update and load objects', () async {
      await update.main(['-c', '3']);
      
      var temp = Directory.systemTemp;

      var filenameJSON = temp.path + '/data/sitedata.json';
      var body = await File(filenameJSON).readAsString();     

      var sitedata = SiteData.fromJson(json.decode(body));
      expect(sitedata.season, greaterThanOrEqualTo(0));
      expect(sitedata.day, greaterThan(-2));
      
      filenameJSON = temp.path + '/data/${sitedata.sub1id}.json';
      body = await File(filenameJSON).readAsString();

      var standings = decodeStandings(body);
      expect(standings.length, greaterThanOrEqualTo(2));
      expect(standings[0].winning.length, 5);
      expect(standings[0].partytime.length, 5);
      expect(standings[0].id.length, greaterThan(0));
      expect(standings[0].gbDiv.length, greaterThan(0));
      expect(standings[0].gbWc.length, greaterThan(0));
      
      filenameJSON = temp.path + '/data/${sitedata.sub2id}.json';
      body = await File(filenameJSON).readAsString();

      standings = decodeStandings(body);
      expect(standings.length, greaterThanOrEqualTo(10));
      expect(standings[0].winning.length, 5);
      expect(standings[0].partytime.length, 5);
      expect(standings[0].id.length, greaterThan(0));
      expect(standings[0].gbDiv.length, greaterThan(0));
      expect(standings[0].gbWc.length, greaterThan(0));      
    });
  }, timeout: Timeout(Duration(minutes: 4)));
}
