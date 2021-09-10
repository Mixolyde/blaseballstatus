part of database_api;

/*
    'id': '3310adb5-44ba-4a8c-8341-812362612798',
    'league': 'd8545021-e9fc-48a3-af74-48685950a183',
    'rules': '4ae9d46a-5408-460a-84fb-cbd8d03fff6c',
    'schedule': 'a257f609-9b2d-4617-b067-eec9a16403d5',
    'seasonNumber': 5,
    'standings': 'fc2be6bf-cc49-4630-bfdd-712fd6b3e678',
    'stats': 'fdc8ac83-6e88-4c3a-b103-3309e6dca3f1',
    'terminology': 'b67e9bbb-1495-4e1b-b517-f1444b0a6c8b'
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
  
  Season({required this.id, required this.league, required this.rules, 
    required this.schedule, required this.seasonNumber, required this.standings, 
    required this.stats, required this.terminology});

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
  String toString() => 'Season #$seasonNumber';
}
