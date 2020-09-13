import 'dart:convert';
import 'package:http/http.dart';

final String _ilbId = "d8545021-e9fc-48a3-af74-48685950a183";

final String _allTeamsUrl = "https://www.blaseball.com/database/allTeams";
final String _divisionUrl = "https://www.blaseball.com/database/division?id=";
final String _gamesByDateUrl = "https://www.blaseball.com/database/games";
final String _leagueUrl = "https://www.blaseball.com/database/league?id=" 
  + _ilbId;
final String _seasonUrl = "https://www.blaseball.com/database/season?number=";
final String _standingsUrl = "https://www.blaseball.com/database/standings?id=";
final String _subleagueUrl = "https://www.blaseball.com/database/subleague?id=";
final String _tiebreakersUrl = "https://www.blaseball.com/database/tiebreakers?id="


int getCurrentSeasonNumber(){
  return 5;
}

Future<Season> getCurrentSeason() async {
  var response = await get(_seasonUrl + "${getCurrentSeasonNumber()}");
  //print('Response body: ${response.body}');
  return Season.fromJson(json.decode(response.body));
}

Future<Standings> getCurrentStandings() async {
  var season = await getCurrentSeason();
  var response = await get(_standingsUrl + season.standings);
  //print('Response body: ${response.body}');
  var parsed = json.decode(response.body);
  var standings = Standings.fromJson(parsed);
  //print('Season: $season');
  return standings;
}

Future<List<Team>> getTeams() async {
  Standings standings = await getCurrentStandings();
  var response = await get(_allTeamsUrl);
  List<dynamic> parsed = json.decode(response.body);
  List<Team> teams = parsed.map((json) => Team.fromJson(json)).toList();
  teams.forEach((team) {
    team.wins = standings.wins[team.id];
    team.losses = standings.losses[team.id];
  });
  return teams;
}

void sortTeamsNotGrouped(List<Team> teams) {
  teams.sort((a, b) => b.wins.compareTo(a.wins));
}

/*
    "id": "3310adb5-44ba-4a8c-8341-812362612798",
    "league": "d8545021-e9fc-48a3-af74-48685950a183",
    "rules": "4ae9d46a-5408-460a-84fb-cbd8d03fff6c",
    "schedule": "a257f609-9b2d-4617-b067-eec9a16403d5",
    "seasonNumber": 5,
    "standings": "fc2be6bf-cc49-4630-bfdd-712fd6b3e678",
    "stats": "fdc8ac83-6e88-4c3a-b103-3309e6dca3f1",
    "terminology": "b67e9bbb-1495-4e1b-b517-f1444b0a6c8b"
*/
class Season {
  final String id;
  final String league;
  final String rules;
  final String schedule;
  final int seasonNumber;
  final String standings;
  final String stats;
  final String terminology;
  
  Season({this.id, this.league, this.rules, this.schedule, this.seasonNumber, 
  this.standings, this.stats, this.terminology});

  factory Season.fromJson(Map<String, dynamic> json){
    return Season(
      id: json['id'] as String,
      league: json['league'] as String,
      rules: json['rules'] as String,
      schedule: json['schedule'] as String,
      seasonNumber: json['seasonNumber'] as int,
      standings: json['standings'] as String,
      stats: json['stats'] as String,
      terminology: json['terminology'] as String,
    );
  }
    
  @override
  String toString() => "Season #$seasonNumber";
}

/*
    "id": "fc2be6bf-cc49-4630-bfdd-712fd6b3e678",
    "losses": {
        "b72f3061-f573-40d7-832a-5ad475bd7909": 34,
        "8d87c468-699a-47a8-b40d-cfb73a5660ad": 12,
        "36569151-a2fb-43c1-9df7-2df512424c82": 39,
        "ca3f1c8c-c025-4d8e-8eef-5be6accbeb16": 40,
        "a37f9158-7f82-46bc-908c-c9e2dda7c33b": 30,
        "9debc64f-74b7-4ae1-a4d6-fce0144b6ea5": 45,
        "3f8bbb15-61c0-4e3f-8e4a-907a5fb1565e": 38,
        "b63be8c2-576a-4d6e-8daf-814f8bcea96f": 48,
        "f02aeae2-5e6a-4098-9842-02d2273f25c7": 41,
        "878c1bf6-0d21-4659-bfee-916c8314d69c": 52,
        "747b8e4a-7e50-4638-a973-ea7950a3e739": 33,
        "eb67ae5e-c4bf-46ca-bbbc-425cd34182ff": 42,
        "105bc3ff-1320-4e37-8ef0-8d595cb95dd0": 38,
        "b024e975-1c4a-4575-8936-a3754a08806a": 40,
        "adc5b394-8f76-416d-9ce9-813706877b84": 33,
        "57ec08cc-0411-4643-b304-0e80dbc15ac7": 42,
        "979aee4a-6d80-4863-bf1c-ee1a78e06024": 52,
        "23e4cbc1-e9cd-47fa-a35b-bfa06f726cb7": 30,
        "bfd38797-8404-4b38-8b82-341da28b1f83": 41,
        "7966eb04-efcc-499b-8f03-d13916330531": 40
    },
    "wins": {
        "b72f3061-f573-40d7-832a-5ad475bd7909": 43,
        "8d87c468-699a-47a8-b40d-cfb73a5660ad": 65,
        "36569151-a2fb-43c1-9df7-2df512424c82": 38,
        "ca3f1c8c-c025-4d8e-8eef-5be6accbeb16": 37,
        "a37f9158-7f82-46bc-908c-c9e2dda7c33b": 47,
        "9debc64f-74b7-4ae1-a4d6-fce0144b6ea5": 32,
        "3f8bbb15-61c0-4e3f-8e4a-907a5fb1565e": 39,
        "b63be8c2-576a-4d6e-8daf-814f8bcea96f": 29,
        "f02aeae2-5e6a-4098-9842-02d2273f25c7": 36,
        "878c1bf6-0d21-4659-bfee-916c8314d69c": 25,
        "747b8e4a-7e50-4638-a973-ea7950a3e739": 44,
        "eb67ae5e-c4bf-46ca-bbbc-425cd34182ff": 35,
        "105bc3ff-1320-4e37-8ef0-8d595cb95dd0": 39,
        "b024e975-1c4a-4575-8936-a3754a08806a": 37,
        "adc5b394-8f76-416d-9ce9-813706877b84": 44,
        "57ec08cc-0411-4643-b304-0e80dbc15ac7": 35,
        "979aee4a-6d80-4863-bf1c-ee1a78e06024": 25,
        "23e4cbc1-e9cd-47fa-a35b-bfa06f726cb7": 47,
        "bfd38797-8404-4b38-8b82-341da28b1f83": 36,
        "7966eb04-efcc-499b-8f03-d13916330531": 37
    }
*/

class Standings {
  final String id;
  final Map<String, int> losses;
  final Map<String, int> wins;
  
  Standings({this.id, this.losses, this.wins});
  
  factory Standings.fromJson(Map<String, dynamic> json){
    var lossesMap = json['losses'] as Map<String, dynamic>;
    Map<String, int> losses = lossesMap.map(
      (k, v) { return new MapEntry(k.toString(), int.parse(v.toString())); });
    var winsMap = json['wins'] as Map<String, dynamic>;  
    Map<String, int> wins = winsMap.map(
      (k, v) { return new MapEntry(k.toString(), int.parse(v.toString())); });
    return Standings(
      id: json['id'] as String,
      losses: losses,
      wins: wins,
    );
  }
  
  @override
  String toString() => "Standings: $id";

}

class Team {
  final String id;
  final String division = "High";
  final String fullName;
  final String nickname;
  final String shorthand;
  final String emoji;
  int wins;
  int losses;
  
  Team({this.id, this.fullName, this.nickname, this.shorthand,
    this.emoji});
  
  factory Team.fromJson(Map<String, dynamic> json){
    return Team(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      nickname: json['nickname'] as String,
      shorthand: json['shorthand'] as String,
      emoji: json['emoji'] as String,
    );
  }
  
    Map toJson() => {
      'nickname': nickname,
      'division': division,
      'wins': wins,
      'losses': losses,
      'gbLg': '-',
      'gbPo': '-',
      'po1': '-',
      'po2': '-',
      'po3': '-',
      'po4': '-',
      'po5': '-',
    };
  
  @override
  String toString() => "$fullName ($wins - $losses)";
  
}

void main() {
  getCurrentSeason()
    .then((s) { 
      print(s);
    });
    
  getCurrentStandings()
    .then((s) { 
      print(s);
    });
  getTeams()
    .then((s) { 
      print(s);
    });  
    
}
