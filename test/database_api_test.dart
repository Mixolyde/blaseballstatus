import 'package:test/test.dart';

import '../lib/database_api.dart';

void main() {
  apiTests();
}

void apiTests() {
  group('regular season', () {
    var teamCount = 20;
    var divisionCount = 1;
    test('Current Simulation Data', () async {
      var data = await getSimulationData();
      print(data);
      expect(data.season, greaterThanOrEqualTo(0));
      expect(data.currentSeasonId, isIn(['thisidisstaticyo',
        'gamma4', 'gamma8', 'gamma9', 'gamma10',
        'cd1b6714-f4de-4dfc-a030-851b3459d8d1']));
      expect(data.attributes.length, greaterThanOrEqualTo(0));
      expect(data.inPostSeason, isNotNull);
    });
    test('Current Standings', () async {
      var current = await getStandings();
      expect(current, isNotNull);
      expect(current.standings.keys.length, greaterThanOrEqualTo(teamCount));
    });
    test('Get League', () async {
      var data = await getSimulationData();
      var current = await getLeague();
      expect(current, isNotNull);
      expect('Internet League Blaseball', current.name);
      expect(current.subleagueId1, isNotNull);
      expect(current.subleagueId2, isNotNull);
      expect(data.league, current.id);
      print('League: $current');
    });
    test('Get Subleague', () async {
      var league = await getLeague();
      var current = await getSubleague(league.subleagueId1);
      expect(current, isNotNull);
      expect(current.divisionId1, isNotNull);
      expect(current.divisionId2, isNotNull);
      print('Subleague: $current');
    });
    test('Get Division', () async {
      var league = await getLeague();
      var subleague = await getSubleague(league.subleagueId1);
      var current = await getDivision(subleague.divisionId1);
      expect(current, isNotNull);
      expect(current.teams, isNotNull);
      expect(current.teams.length, greaterThanOrEqualTo(divisionCount));
      print('Division: $current');
    });
    test('Get Tiebreakers', () async {
      var league = await getLeague();
      var current = await getTiebreakers(league.tiebreakersId);
      expect(current, isNotNull);
      expect(current.order, isNotNull);
      expect(current.order.length, greaterThanOrEqualTo(teamCount));
      print('$current');
    });  
  });
  group('postseason', () {
    var seasonNumber = 10;
    //var teamCount = 20;
    //var divisionCount = 1;
    test('playoffs', () async {
      var current = await getPlayoffs(seasonNumber);
      if(current == null) fail('current is null');
      expect(current.season, seasonNumber);
      expect(current.id, isNotNull);
      expect(current.numberOfRounds, 4);
      expect(current.rounds.length, 4);
      expect(current.winner, isNotNull);
      print(current);
    });
    //[6f7d7507-2768-4237-a2f3-f7c4ee1d6aa6, 2fc8cd07-48b2-460d-8b8d-10aee5c9f1c9, c378bb0c-2baa-4452-8d83-4546510c2a26, 653fe888-0a34-4663-bd2c-4a32f519d763]
    test('round', () async {
      var roundIds = [
        '6f7d7507-2768-4237-a2f3-f7c4ee1d6aa6', 
        '2fc8cd07-48b2-460d-8b8d-10aee5c9f1c9',
        'c378bb0c-2baa-4452-8d83-4546510c2a26',
        '653fe888-0a34-4663-bd2c-4a32f519d763'];
      var current = await getPlayoffRound(roundIds[0]);
      expect(current, isNotNull);
      expect(current.id, '6f7d7507-2768-4237-a2f3-f7c4ee1d6aa6');
      expect(current.matchupIDs, isNotNull);
      expect(current.gameIDs, isNotNull);
      expect(current.winnerIDs, isNotNull);
      expect(current.roundNumber, 0);
      expect(current.special, false);
      expect(current.gameIndex, 2);
      print(current.matchupIDs);
    });
    test('matchups', () async {
      var matchupIDs = [
        'cb8208c2-6473-4ab2-990c-8a0f04d2f6f6', 
        'a7853495-54fe-4c8b-93a2-18c8075d9e7b', 
        '618b7f75-da29-4860-bbc6-c82a80d55c5f', 
        '136e7769-f3e2-4f86-9f34-8abbf6b7d58e', 
        '05664891-7844-470c-9b9f-212038380e89', 
        '24a8ff8a-d2bb-4d9b-ace2-8cd2be211326', 
        'd85ec2f7-a824-469b-bc84-1259172ccf17', 
        '969ac1c9-84ad-4d1a-8232-8bafa1a1ce51'];

      var current = await getPlayoffMatchups(matchupIDs);
      expect(current, isNotNull);
      expect(current.length, 8);
      var first = current[0];
      print(first);
      expect(first.id, '618b7f75-da29-4860-bbc6-c82a80d55c5f');
      expect(first.awaySeed, 0);
      expect(first.awayTeam, isNull);
      expect(first.awayWins, 0);
      expect(first.homeSeed, 1);
      expect(first.homeTeam, isNotNull);
      expect(first.homeTeam!.length, 36);
      expect(first.homeWins, 0);
    });
    test('complete historical postseason', () async {
      var current = await getCompletePostseason(seasonNumber);
      if(current == null) fail('current is null');
      expect(current.playoffs.season, seasonNumber);
      expect(current.id, isNotNull);
      expect(current.id, current.playoffs.id);
      expect(current.playoffs.numberOfRounds, 4);
      expect(current.playoffs.rounds.length, 4);
      expect(current.playoffs.winner, isNotNull);
      print(current);
    });   
    test('current postseason', () async {
      var data = await getSimulationData();
      var current = await getCurrentPostseason();
      print(current);
      expect(current, isNull);
      /* TODO fix with live postseason data
      if(data.inPostSeason){
        expect(current, isNotNull);
        expect(current!.id, isNotNull);
        expect(current.id, current.playoffs.id);
        expect(current.playoffs.numberOfRounds, greaterThan(0));
        expect(current.playoffs.rounds.length, greaterThan(0));
        expect(current.playoffs.rounds.length, current.playoffs.numberOfRounds);
      } else {
        expect(current, isNull);
      }
      */
    });    
  }, timeout: Timeout(Duration(minutes: 4)));
  
}
