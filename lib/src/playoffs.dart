part of database_api;

/*
  "id": "d30b9002-6e9d-4c31-bb86-68b69ad32a75",
  "name": "Season 4 Postseason",
  "numberOfRounds": 3,
  "playoffDay": 12,
  "rounds": [
    "b435ba04-dd90-4454-a123-6bd10989a6eb",
    "def46e3e-3cec-410c-985d-4decef431eb6",
    "a46cf811-3202-4d5d-98aa-c8965337702c"
  ],
  "season": 3,
  "tomorrowRound": 2,
  "winner": "747b8e4a-7e50-4638-a973-ea7950a3e739"
*/
class Playoffs {
  final String id;
  final String name;
  final int numberOfRounds;
  final int playoffDay;
  final List<String> rounds;
  final int season;
  final int tomorrowRound;
  final String winner;
  
  Playoffs({this.id, this.name, this.numberOfRounds, this.playoffDay,
    this.rounds, this.season, this.tomorrowRound, this.winner});
  
  factory Playoffs.fromJson(Map<String, dynamic> json){
    return Playoffs(
      id: json['id'] as String,
      name: json['name'] as String,
      numberOfRounds: json['numberOfRounds'] as int,
      playoffDay: json['playoffDay'] as int,
      rounds: (json['rounds'] as List<dynamic>)
        .map((t) => t.toString()).toList(),
      season: json['season'] as int,
      tomorrowRound: json['tomorrowRound'] as int, 
      winner: json['winner'] as String,      
    );
  }
  
  @override
  String toString() => "$id $name $season";
}

/*
    "id": "1a531d31-5ec2-45a1-9ea0-004236139d59",
    "name": null,
    "awaySeed": 1,
    "awayTeam": "36569151-a2fb-43c1-9df7-2df512424c82",
    "awayWins": 3,
    "homeSeed": 0,
    "homeTeam": "ca3f1c8c-c025-4d8e-8eef-5be6accbeb16",
    "homeWins": 2
*/

class PlayoffMatchups {
  final String id;
  final String name;
  final int awaySeed;
  final String awayTeam;
  final int awayWins;
  final int homeSeed;
  final String homeTeam;
  final int homeWins;
  
  PlayoffMatchups({this.id, this.name, this.awaySeed, this.awayTeam,
    this.awayWins, this.homeSeed, this.homeTeam,
    this.homeWins});
  
  factory PlayoffMatchups.fromJson(Map<String, dynamic> json){
    return PlayoffMatchups(
      id: json['id'] as String,
      name: json['name'] as String,
      awaySeed: json['awaySeed'] as int,
      awayTeam: json['awayTeam'] as String,   
      awayWins: json['awayWins'] as int,
      homeSeed: json['homeSeed'] as int,
      homeTeam: json['homeTeam'] as String,   
      homeWins: json['homeWins'] as int,
    );
  }
  
  @override
  String toString() => "$id $awayTeam vs. $homeTeam ($awayWins - $homeWins)";
}

/*
    "id": "aecb79df-5f61-40c1-a244-8a42268f2e4c",
    "matchups": [
        "7cc52df5-1e20-417b-9915-cd62c534182a"
    ],
    "games": [
        [
            "c0080509-f1f6-4b86-9c31-88abf157e283",
            "none"
        ]
    ],
    "winners": [
        "23e4cbc1-e9cd-47fa-a35b-bfa06f726cb7"
    ],
    "winnerSeeds": [
        0,
        2,
        0,
        1
    ],
    "gameIndex": 4,
    "name": "Round 1",
    "roundNumber": 0,
    "special": false
*/

class PlayoffRound {
  final String id;
  final List<String> matchupIDs;
  final List<String> gameIDs;
  final List<String> winnerIDs;
  final List<int> winnerSeeds;
  final int gameIndex;
  final String name;
  final int roundNumber;
  final bool special;
  
  PlayoffRound({this.id, this.matchupIDs, this.gameIDs, this.winnerIDs,
    this.winnerSeeds, this.gameIndex, this.name,
    this.roundNumber, this.special});
  
  factory PlayoffRound.fromJson(Map<String, dynamic> json){
    return PlayoffRound(
      id: json['id'] as String,
      matchupIDs: (json['matchups'] as List<dynamic>)
        .map((t) => t.toString()).toList(),
      gameIDs: (json['games'] as List<dynamic>)
        .map((t) => t.toString()).toList(),
      winnerIDs: (json['winners'] as List<dynamic>)
        .map((t) => t.toString()).toList(),
      winnerSeeds: (json['winnerSeeds'] as List<dynamic>)
        .map((t) => int.parse(t.toString())).toList(),
      gameIndex: json['gameIndex'] as int,
      name: json['name'] as String,
      roundNumber: json['roundNumber'] as int,
      special: json['special'] as bool,   
    );
  }
  
  @override
  String toString() => "$id $name Round $roundNumber";
}