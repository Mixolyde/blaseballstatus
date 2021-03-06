part of database_api;

class CompletePostseason {
  final String id;
  final Playoffs playoffs;
  final Map<String, PlayoffRound> playoffRounds;
  final Map<String, PlayoffMatchups> playoffMatchups;
  
  CompletePostseason({this.id, this.playoffs, this.playoffRounds,
    this.playoffMatchups});
  
  @override
  String toString() => "Complete PostSeason ${playoffRounds.keys.length} Rounds " +
    "${playoffMatchups.keys.length} Matchups";
}

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
  
  MidPostSeason
  
  "id":"8b1181e8-9387-4ff5-b014-0d1c64db72a4",
  "name":"Postseason 12",
  "numberOfRounds":4,
  "playoffDay":4,
  "rounds":[
    "31611140-5299-47bb-8b3a-8b92809de348",
    "b78d2f33-a00f-4957-88af-74c38e5695fa",
    "0188518e-edc2-4e65-81cf-a6a601d466a8",
    "5f6bfecc-2cd9-4ade-b92d-2c69ab597ab3"
   ],
   "season":11,
   "tomorrowRound":1,
   "winner":null,
   "tournament":-1

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
    
    MidPostSeason
    Wild Card Round
    "id":"3be7440a-7cd4-461c-ad22-fa256fe8d89b",
    "name":null,
    "awaySeed":null,
    "awayTeam":null,
    "awayWins":0,
    "homeSeed":0,
    "homeTeam":"747b8e4a-7e50-4638-a973-ea7950a3e739",
    "homeWins":0,
    "gamesPlayed":0,
    "gamesNeeded":"2"
    
    "id":"6a65a7a6-0a93-4127-b7df-d9488eeaf946",
    "name":null,
    "awaySeed":null,
    "awayTeam":null,
    "awayWins":0,
    "homeSeed":1,
    "homeTeam":"f02aeae2-5e6a-4098-9842-02d2273f25c7",
    "homeWins":0,
    "gamesPlayed":0,
    "gamesNeeded":"2"
    
    "id":"0f62a795-06c2-4339-901b-9e42b12538cc",
    "name":null,
    "awaySeed":4,
    "awayTeam":"57ec08cc-0411-4643-b304-0e80dbc15ac7",
    "awayWins":2,
    "homeSeed":3,
    "homeTeam":"ca3f1c8c-c025-4d8e-8eef-5be6accbeb16",
    "homeWins":1,
    "gamesPlayed":3,
    "gamesNeeded":"2"
    
    "id":"2d307b56-7c11-4240-9ca2-aeede98fcd10",
    "name":null,
    "awaySeed":null,
    "awayTeam":null,
    "awayWins":0,
    "homeSeed":2,
    "homeTeam":"a37f9158-7f82-46bc-908c-c9e2dda7c33b",
    "homeWins":0,
    "gamesPlayed":0,
    "gamesNeeded":"2"
    
    "id":"f68e3812-9a67-4efd-80db-baeedc243e9f",
    "name":null,
    "awaySeed":null,
    "awayTeam":null,
    "awayWins":0,
    "homeSeed":0,
    "homeTeam":"23e4cbc1-e9cd-47fa-a35b-bfa06f726cb7",
    "homeWins":0,"gamesPlayed":0,
    "gamesNeeded":"2"
    
    "id":"c295f9bf-d935-4da4-943e-b8d2ff34ce57",
    "name":null,
    "awaySeed":4,
    "awayTeam":"bfd38797-8404-4b38-8b82-341da28b1f83",
    "awayWins":2,
    "homeSeed":3,
    "homeTeam":"36569151-a2fb-43c1-9df7-2df512424c82",
    "homeWins":1,
    "gamesPlayed":3,
    "gamesNeeded":"2"
    
    "id":"7c6324e3-d5a9-48c5-b12d-3cbbc9eff617",
    "name":null,
    "awaySeed":null,
    "awayTeam":null,
    "awayWins":0,
    "homeSeed":1,
    "homeTeam":"979aee4a-6d80-4863-bf1c-ee1a78e06024",
    "homeWins":0,
    "gamesPlayed":0,
    "gamesNeeded":"2"
    
    "id":"bb63e17e-257f-4b08-912a-033ac7c8ab8c",
    "name":null,
    "awaySeed":null,
    "awayTeam":null,
    "awayWins":0,
    "homeSeed":2,
    "homeTeam":"105bc3ff-1320-4e37-8ef0-8d595cb95dd0",
    "homeWins":0,
    "gamesPlayed":0,
    "gamesNeeded":"2"

    Round 2 Matchups
    "id":"a2177f33-2045-472e-999a-0f8f4e05390a",
    "name":null,
    "awaySeed":4,
    "awayTeam":"bfd38797-8404-4b38-8b82-341da28b1f83",
    "awayWins":1,
    "homeSeed":0,
    "homeTeam":"23e4cbc1-e9cd-47fa-a35b-bfa06f726cb7",
    "homeWins":0,
    "gamesPlayed":1,
    "gamesNeeded":"3"
    
    "id":"b5b73c2f-811f-470e-926d-642d3207adc2",
    "name":null,
    "awaySeed":4,
    "awayTeam":"57ec08cc-0411-4643-b304-0e80dbc15ac7",
    "awayWins":1,
    "homeSeed":0,
    "homeTeam":"747b8e4a-7e50-4638-a973-ea7950a3e739",
    "homeWins":1,
    "gamesPlayed":2,
    "gamesNeeded":"3"
    
    "id":"44bc4cc6-3ab8-4282-a9b8-7124b028494c",
    "name":null,
    "awaySeed":2,
    "awayTeam":"105bc3ff-1320-4e37-8ef0-8d595cb95dd0",
    "awayWins":2,
    "homeSeed":1,
    "homeTeam":"979aee4a-6d80-4863-bf1c-ee1a78e06024",
    "homeWins":0,
    "gamesPlayed":2,
    "gamesNeeded":"3"
    
    "id":"a579bae8-aca2-45a7-8917-c66d62fb2699",
    "name":null,
    "awaySeed":2,
    "awayTeam":"a37f9158-7f82-46bc-908c-c9e2dda7c33b",
    "awayWins":1,
    "homeSeed":1,
    "homeTeam":"f02aeae2-5e6a-4098-9842-02d2273f25c7",
    "homeWins":1,
    "gamesPlayed":2,
    "gamesNeeded":"3"
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
    "winnerSeeds": [0,2,0,1],
    "gameIndex": 4,
    "name": "Round 1",
    "roundNumber": 0,
    "special": false
    
    MidPostSeason Rounds
    Final Internet Series
    "id":"5f6bfecc-2cd9-4ade-b92d-2c69ab597ab3",
    "gameIndex":-1,
    "games":[],
    "matchups":[],
    "name":"The Internet Series",
    "roundNumber":3,
    "special":true,
    "winnerSeeds":[],
    "winners":[]
    
    Wild/Mild League Series
    "id":"0188518e-edc2-4e65-81cf-a6a601d466a8",
    "gameIndex":-1,
    "games":[],
    "matchups":[],
    "name":"Round 3",
    "roundNumber":2,
    "special":false,
    "winnerSeeds":[],
    "winners":[]

    Round 2
    "id":"b78d2f33-a00f-4957-88af-74c38e5695fa",
    "gameIndex":1,
    "games":[
      ["be78903e-5e55-4c2b-bebf-29905ddb4e47","9600359a-b556-4003-86a6-99170e36612c","c72b0327-3627-4f0c-a0f5-f3267c805686","99de966d-ffbc-4eb1-acdf-29e908e5e1fe","none","none","none","none"],
      ["63f20a62-e4a3-4fde-ac08-b7af254d9dd6","bb1bebd7-c8e8-488c-9b4a-6610ee966872","deaade1f-c0c2-44f5-b38f-0f2549533f24","ba7fedbb-e82d-45b4-90c6-b246b8abc414"]
    ],
    "matchups":[
      "b5b73c2f-811f-470e-926d-642d3207adc2",
      "a579bae8-aca2-45a7-8917-c66d62fb2699",
      "a2177f33-2045-472e-999a-0f8f4e05390a",
      "44bc4cc6-3ab8-4282-a9b8-7124b028494c"
    ],
    "name":"Round 2",
    "roundNumber":1,
    "special":false,
    "winnerSeeds":[-1,-1,-1,-1],
    "winners":["none","none","none","none"]
    
    Wild Card Round
    "id":"31611140-5299-47bb-8b3a-8b92809de348",
    "gameIndex":2,
    "games":[
      ["none","e538e50d-4eec-45e5-a502-56a943b9afa9","none","none","none","2f3dc725-1086-40ae-b971-6624267782f2","none","none","none","none","none","none","none","none","none","none"],
      ["none","d8e023bd-8cb0-4b41-9317-0b48d7a3bc74","none","none","none","468403e6-ce8c-4683-8d81-c7befbb4f40a","none","none"],
      ["none","f8697d34-915c-4d70-9ce9-41d7759c0695","none","none","none","f7ee0335-4642-4436-9dfd-118d13ff5bf6","none","none"]
    ],
    "matchups":[
      "3be7440a-7cd4-461c-ad22-fa256fe8d89b",
      "0f62a795-06c2-4339-901b-9e42b12538cc",
      "6a65a7a6-0a93-4127-b7df-d9488eeaf946",
      "2d307b56-7c11-4240-9ca2-aeede98fcd10",
      "f68e3812-9a67-4efd-80db-baeedc243e9f",
      "c295f9bf-d935-4da4-943e-b8d2ff34ce57",
      "7c6324e3-d5a9-48c5-b12d-3cbbc9eff617",
      "bb63e17e-257f-4b08-912a-033ac7c8ab8c"
    ],
    "name":"Round 1",
    "roundNumber":0,
    "special":false,
    "winnerSeeds":[0,4,1,2,0,4,1,2],
    "winners":[
      "747b8e4a-7e50-4638-a973-ea7950a3e739",
      "57ec08cc-0411-4643-b304-0e80dbc15ac7",
      "f02aeae2-5e6a-4098-9842-02d2273f25c7",
      "a37f9158-7f82-46bc-908c-c9e2dda7c33b",
      "23e4cbc1-e9cd-47fa-a35b-bfa06f726cb7",
      "bfd38797-8404-4b38-8b82-341da28b1f83",
      "979aee4a-6d80-4863-bf1c-ee1a78e06024",
      "105bc3ff-1320-4e37-8ef0-8d595cb95dd0"
    ]

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