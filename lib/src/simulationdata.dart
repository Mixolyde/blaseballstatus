part of database_api;

/*
  {"phase":"restPhase",
  "startTime":"2023-01-05T23:01:00.000Z",
  "endTime":"2023-01-09T14:59:59.000Z",
  "startDayNumber":-1,
  "endDayNumber":-1,
  "simData":{
    "banner":null,
    "currentSeasonId":"cd1b6714-f4de-4dfc-a030-851b3459d8d1",
    "currentSeasonNumber":0,
    "currentDay":-1,
    "liveGames":false,
    "isTournament":false,
    "isOffseason":false,
    "currentLeagueData":{
      "id":"d3182b4d-91b6-4b4e-96a5-13d69e0043b7",
      "name":"Internet Blaseball League",
      "subLeagues":[{"id":"5335d626-db8c-4181-950a-e650f5f11d00",
        "divisions":[
          {"id":"8b22bdcf-8cf9-46d4-93da-bb75a6413786","name":"Awful Good"},
          {"id":"67a4acf7-60b6-463d-bcff-63fbf538b3d9","name":"Chaotic Good"}]},
        {"id":"226dc71f-b3a2-4d0d-814e-1b963781cda9",
        "divisions":[
          {"id":"b60a5664-66d8-462a-85ae-9da2d4d9c59e","name":"Awful Evil"},
          {"id":"0b684565-ecaf-4afc-96d2-f4100f127197","name":"Chaotic Evil"}]}]}}}
*/
class SimulationData {
  final String currentSeasonId;
  int day;
  final String league;
  int? playOffRound;
  int season;
  String seasonId;
  final String eraTitle;
  final String subEraTitle;
  final List<String> attributes;

  SimulationData({required this.currentSeasonId, required this.day, required this.league, 
    this.playOffRound, required this.season, required this.seasonId, 
    required this.eraTitle, required this.subEraTitle,
    required this.attributes});
  
  factory SimulationData.fromJson(Map<String, dynamic> json){
    Map<String, dynamic> simJson = json['simData'];
    Map<String, dynamic> currentLeagueData = simJson['currentLeagueData'];
    return SimulationData(
      currentSeasonId: simJson['currentSeasonId'] as String,
      day: simJson['currentDay'] as int,
      league: currentLeagueData['id'] as String,
      playOffRound: simJson['playOffRound'] as int?,
      season: simJson['currentSeasonNumber'] as int,
      seasonId: simJson['currentSeasonId'] as String,
      eraTitle: "",
      subEraTitle: "",
      //attributes: (simJson['attr'] as List<dynamic>)
      //  .map((t) => t.toString()).toList() as List<String>,
      attributes: [],
    );
  }
  
  @override
  String toString() => 'CurrentSeasonId: $currentSeasonId, Season $season, Day $day, League $league, PlayoffRound $playOffRound, Attributes $attributes';

  bool get leagueWildCards => attributes.contains('WILD_CARDS');
  
  bool get leagueMildCards => attributes.contains('MILD_CARDS');

  bool get inPostSeason => day >= SimulationData.daysInRegularSeason(currentSeasonId);
  
  static int daysInRegularSeason(String simId) {
    if(simId == 'gamma9'){
      return 166;
    } else if (simId == 'gamma10'){
      return 219;
    } else {
      return 90;
    } 
  }
  
  static int gamesInRegularSeason(String simId) {
    if (simId == 'gamma10'){
      return 162;
    } else {
      return 90;
    }
  }  

}
