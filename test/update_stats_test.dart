import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:test/test.dart';

import '../tools/update_stats.dart' as update;
import '../lib/s3_api.dart';
import '../lib/site_objects.dart';

void main() {
  group('update tests', () {
    test('update and load objects', () async {
      await update.main();
      
      Directory temp = Directory.systemTemp;
      File aws = new File(temp.path + '/data/sitedata.json');
      
      bool exists = await aws.exists();
      String filenameJSON = temp.path + '/data/sitedata.json';
      String body = await new File(filenameJSON).readAsString();     

      SiteData sitedata = SiteData.fromJson(json.decode(body));
      expect(sitedata.season, greaterThan(1));
      expect(sitedata.day, greaterThan(-1));
      
      filenameJSON = temp.path + '/data/${sitedata.sub1id}.json';
      body = await new File(filenameJSON).readAsString();

      List<TeamStandings> standings = decodeStandings(body);
      expect(standings.length, greaterThanOrEqualTo(10));
      expect(standings[0].winning.length, 5);
      expect(standings[0].partytime.length, 5);
      expect(standings[0].id.length, greaterThan(0));
      expect(standings[0].gbDiv.length, greaterThan(0));
      expect(standings[0].gbWc.length, greaterThan(0));
      
      filenameJSON = temp.path + '/data/${sitedata.sub2id}.json';
      body = await new File(filenameJSON).readAsString();

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