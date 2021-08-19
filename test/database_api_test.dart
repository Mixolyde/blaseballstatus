import 'package:test/test.dart';

import '../lib/database_api.dart';
import '../lib/site_objects.dart';

void main() {
  apiTests();
}

void apiTests() {
  apiUrl = "https://blaseball.com/database/";
  group('regular season', () {
    int seasonNumber = 5;
    int teamCount = 20;
    int divisionCount = 1;
    test('Current Simulation Data', () async {
      SimulationData data = await getSimulationData();
      print(data);
      expect(data.season, greaterThan(seasonNumber));
      expect(data.id, "thisidisstaticyo");
      expect(data.attributes.length, greaterThan(1));
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
      expect(current.wins.length, greaterThanOrEqualTo(teamCount));
      expect(current.losses.length, greaterThanOrEqualTo(teamCount));
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
      expect(current.teams.length, greaterThanOrEqualTo(divisionCount));
      print("Division: $current");
    });
    test('Get Tiebreakers', () async {
      League league = await getLeague();
      Tiebreakers current = await getTiebreakers(league.tiebreakersId);
      expect(current, isNotNull);
      expect(current.order, isNotNull);
      expect(current.order.length, greaterThanOrEqualTo(teamCount));
      print("$current");
    });  
    test('Get games first day of season', () async {
      SimulationData data = await getSimulationData();
      List<Game> current = await getGames(data.season, 0);
      expect(current, isNotNull);
      expect(current.length, greaterThanOrEqualTo(10));
      expect(current[0], isNotNull);      
      print("Day 0 Game 0: ${current[0]}");
    });   
    test('Get games last day of season', () async {
      SimulationData data = await getSimulationData();
      List<Game> current = await getGames(data.season, 98);
      expect(current, isNotNull);
      expect(current.length, greaterThanOrEqualTo(10));
      expect(current[0], isNotNull);      
      print("Day 98 Game 0: ${current[0]}");
    });     
    test('Get all games of season', () async {
      SimulationData data = await getSimulationData();
      List<Game> current = await getAllGames(data.season);
      expect(current, isNotNull);
      expect(current.length, greaterThan(10));
      expect(current[0], isNotNull);      
      print("Day 0 Game 0: ${current[0]}");
      print("Last Game: ${current.last}");
    }, timeout: Timeout(Duration(minutes: 2)));     
  });
  group('postseason', () {
    int seasonNumber = 10;
    int teamCount = 20;
    int divisionCount = 1;
    test('playoffs', () async {
      Playoffs? current = await getPlayoffs(seasonNumber);
      if(current == null) fail("current is null");
      expect(current.season, seasonNumber);
      expect(current.id, isNotNull);
      expect(current.numberOfRounds, 4);
      expect(current.rounds.length, 4);
      expect(current.winner, isNotNull);
      print(current);
    });
    //[6f7d7507-2768-4237-a2f3-f7c4ee1d6aa6, 2fc8cd07-48b2-460d-8b8d-10aee5c9f1c9, c378bb0c-2baa-4452-8d83-4546510c2a26, 653fe888-0a34-4663-bd2c-4a32f519d763]
    test('round', () async {
      List<String> roundIds = [
        "6f7d7507-2768-4237-a2f3-f7c4ee1d6aa6", 
        "2fc8cd07-48b2-460d-8b8d-10aee5c9f1c9",
        "c378bb0c-2baa-4452-8d83-4546510c2a26",
        "653fe888-0a34-4663-bd2c-4a32f519d763"];
      PlayoffRound current = await getPlayoffRound(roundIds[0]);
      expect(current, isNotNull);
      expect(current.id, "6f7d7507-2768-4237-a2f3-f7c4ee1d6aa6");
      expect(current.matchupIDs, isNotNull);
      expect(current.gameIDs, isNotNull);
      expect(current.winnerIDs, isNotNull);
      expect(current.roundNumber, 0);
      expect(current.special, false);
      expect(current.gameIndex, 2);
      print(current.matchupIDs);
    });
    test('matchups', () async {
      List<String> matchupIDs = [
        "cb8208c2-6473-4ab2-990c-8a0f04d2f6f6", 
        "a7853495-54fe-4c8b-93a2-18c8075d9e7b", 
        "618b7f75-da29-4860-bbc6-c82a80d55c5f", 
        "136e7769-f3e2-4f86-9f34-8abbf6b7d58e", 
        "05664891-7844-470c-9b9f-212038380e89", 
        "24a8ff8a-d2bb-4d9b-ace2-8cd2be211326", 
        "d85ec2f7-a824-469b-bc84-1259172ccf17", 
        "969ac1c9-84ad-4d1a-8232-8bafa1a1ce51"];

      List<PlayoffMatchup> current = await getPlayoffMatchups(matchupIDs);
      expect(current, isNotNull);
      expect(current.length, 8);
      PlayoffMatchup first = current[0];
      print(first);
      expect(first.id, "618b7f75-da29-4860-bbc6-c82a80d55c5f");
      expect(first.awaySeed, isNull);
      expect(first.awayTeam, isNull);
      expect(first.awayWins, 0);
      expect(first.homeSeed, 1);
      expect(first.homeTeam.length, 36);
      expect(first.homeWins, 0);
    });
    test('complete postseason', () async {
      CompletePostseason? current = await getCompletePostseason(seasonNumber);
      if(current == null) fail("current is null");
      expect(current.playoffs.season, seasonNumber);
      expect(current.id, isNotNull);
      expect(current.id, current.playoffs.id);
      expect(current.playoffs.numberOfRounds, 4);
      expect(current.playoffs.rounds.length, 4);
      expect(current.playoffs.winner, isNotNull);
      print(current);
    });   
    test('current postseason', () async {
      SimulationData data = await getSimulationData();
      expect(data.season, greaterThan(seasonNumber));      
      CompletePostseason? current = await getCompletePostseason(data.season);
      print(current);
    });    
  });
  
}
