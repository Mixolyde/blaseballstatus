part of database_api;

/*
    "id": "thisidisstaticyo",
        "day": 51,
        "league": "d8545021-e9fc-48a3-af74-48685950a183",
        "nextElectionEnd": "2020-09-20T19:15:00.295Z",
        "nextPhaseTime": "2020-09-14T16:00:00.678Z",
        "nextSeasonStart": "2020-09-21T16:00:00.295Z",
        "phase": 2,
        "playOffRound": 0,
        "playoffs": "f3118c69-63a2-434a-9724-bea36934b839",
        "rules": "4ae9d46a-5408-460a-84fb-cbd8d03fff6c",
        "season": 6,
        "seasonId": "554c7ce4-4c71-40d5-b05c-63e9bfd86601",
        "terminology": "b67e9bbb-1495-4e1b-b517-f1444b0a6c8b",
        "eraColor": "#ff0000",
        "eraTitle": "The Discipline Era",
        "twgo": "JHFMTOJMNPSMLMDGFOSEZDTMJWHPADAACGRTBBPBBCJRTPMJCSNKKAOMVMSTAJTVTCJIMPSSSTBFHRSSMSDKIRLWLVWSSMEIMCCDMDRTEIFBCLRMMW",
        "subEraColor": "#ffe082",
        "subEraTitle": "GETTING SHELLED",
        "attr": [
        ]
*/
class SimulationData {
  final String id;
  int day;
  final String league;
  final int playOffRound;
  final int season;
  final String seasonId;
  final String eraTitle;
  final String subEraTitle;

  SimulationData({this.id, this.day, this.league, this.playOffRound,
    this.season, this.seasonId, this.eraTitle, this.subEraTitle});
  
  factory SimulationData.fromJson(Map<String, dynamic> json){
    return SimulationData(
      id: json['id'] as String,
      day: json['day'] as int,
      league: json['league'] as String,
      playOffRound: json['playOffRound'] as int,
      season: json['season'] as int,
      seasonId: json['seasonId'] as String,
      eraTitle: json['eraTitle'] as String,
      subEraTitle: json['subEraTitle'] as String,
    );
  }
  
  @override
  String toString() => "Season $season, Day $day, PlayoffRound $playOffRound";

}