import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';

import '../lib/database_api.dart';
import '../lib/site_objects.dart';

void main() {
  group('simulation data', () {
    test('no league wild cards', () async {
      var currentSimData = await getSimulationData();
      var simData = SimulationData(
        currentSeasonId: currentSimData.currentSeasonId,
        day: 113,
        league: 'd8545021-e9fc-48a3-af74-48685950a183',
        playOffRound: 3,
        season: 14,
        seasonId: '645cdd84-175f-42f1-a9f3-d9014d97ae3b',
        eraTitle: currentSimData.eraTitle,
        subEraTitle: currentSimData.subEraTitle,
        attributes: ['TEST_ATTR1', 'TEST_ATTR2', 'TEST_ATTR3'],
      );
      expect(simData.leagueWildCards, false);
    });
    test('has league wild cards', () async {
      var currentSimData = await getSimulationData();
      var simData = SimulationData(
        currentSeasonId: currentSimData.currentSeasonId,
        day: 113,
        league: 'd8545021-e9fc-48a3-af74-48685950a183',
        playOffRound: 3,
        season: 14,
        seasonId: '645cdd84-175f-42f1-a9f3-d9014d97ae3b',
        eraTitle: currentSimData.eraTitle,
        subEraTitle: currentSimData.subEraTitle,
        attributes: ['TEST_ATTR1', 'TEST_ATTR2', 'TEST_ATTR3', 'WILD_CARDS'],
      );
      expect(simData.leagueWildCards, true);
    });  
    test('in post season', () async {
      var currentSimData = await getSimulationData();
      var simData = SimulationData(
        currentSeasonId: currentSimData.currentSeasonId,
        day: 500,
        league: 'd8545021-e9fc-48a3-af74-48685950a183',
        playOffRound: 3,
        season: 14,
        seasonId: '645cdd84-175f-42f1-a9f3-d9014d97ae3b',
        eraTitle: currentSimData.eraTitle,
        subEraTitle: currentSimData.subEraTitle,
        attributes: ['TEST_ATTR1', 'TEST_ATTR2', 'TEST_ATTR3'],
      );
      expect(simData.inPostSeason, true);
    });   
    test('not in post season', () async {
      var currentSimData = await getSimulationData();
      var simData = SimulationData(
        currentSeasonId: currentSimData.currentSeasonId,
        day: 88,
        league: 'd8545021-e9fc-48a3-af74-48685950a183',
        playOffRound: 3,
        season: 14,
        seasonId: '645cdd84-175f-42f1-a9f3-d9014d97ae3b',
        eraTitle: currentSimData.eraTitle,
        subEraTitle: currentSimData.subEraTitle,
        attributes: ['TEST_ATTR1', 'TEST_ATTR2', 'TEST_ATTR3'],
      );
      expect(simData.inPostSeason, false);
    });    
  });
  group('playoff objects', () {
    test('current round incomplete', () {
      var playoffs = Playoffs(
        id: 'id',
        name: 'name',
        numberOfRounds: 3,
        playoffDay: 1,
        rounds: ['round0', 'round1', 'round2'],
        season: 1,
        round: 0, 
        tomorrowRound: 0, 
        winner: null,      
      );
      expect(playoffs.currentRoundComplete, false);
    });
    test('current round complete', () {
      var playoffs = Playoffs(
        id: 'id',
        name: 'name',
        numberOfRounds: 3,
        playoffDay: 1,
        rounds: ['round0', 'round1', 'round2'],
        season: 1,
        round: 0, 
        tomorrowRound: 1, 
        winner: null,      
      );
      expect(playoffs.currentRoundComplete, true);
    });
    test('current round complete with winner', () {
      var playoffs = Playoffs(
        id: 'id',
        name: 'name',
        numberOfRounds: 3,
        playoffDay: 1,
        rounds: ['round0', 'round1', 'round2'],
        season: 1,
        round: 2, 
        tomorrowRound: 2, 
        winner: 'winner',      
      );
      expect(playoffs.currentRoundComplete, true);
    });    
    test('completed postseason stream data', () async { 
      String contents = File('./test/data/completed_postseason_nowildcard.json').readAsStringSync();
  
      var jsonMap = json.decode(contents);
  
      var postseasonMap = jsonMap['postseasons'][0]!;
      
      var completePost = CompletePostseason.fromStreamData(postseasonMap);   
      print(completePost);

      expect(completePost, isNotNull);
      expect(completePost.id, isNotNull);
      expect(completePost.id, completePost.playoffs.id);
      expect(completePost.playoffs.numberOfRounds, 3);
      expect(completePost.playoffs.rounds.length, 3);
      expect(completePost.playoffs.rounds.length, completePost.playoffs.numberOfRounds);
      
      expect(completePost.playoffRounds.keys.length, completePost.playoffs.numberOfRounds);
      
      int totalMatchupCount = completePost.playoffRounds.values.
        fold(0, (prev, element) => prev + element.matchupIDs.length);
      expect(totalMatchupCount, 7);
      expect(completePost.playoffMatchups.keys.length, greaterThan(0));
      expect(completePost.playoffMatchups.keys.length, totalMatchupCount);


    });
  });
}