part of database_api;

class Team {
  final String id;
  final String fullName;
  final String nickname;
  final String shorthand;
  final String emoji;
  final String divisionId;
  final String divisionName;
  int wins;
  int losses;
  
  Team({this.id = '', this.fullName = '', this.nickname = '', 
    this.shorthand = '', this.emoji = '',
    this.divisionId = '', this.divisionName = '',
    this.wins = 0, this.losses = 0});
  
  factory Team.fromJson(Map<String, dynamic> json){ 
    Map<String,dynamic> divisionMap = json['division'];
    return Team(
      id: json['id'] as String,
      fullName: json['name'] as String,
      nickname: json['nickname'] as String,
      shorthand: json['shorthand'] as String,
      emoji: json['emoji'] as String,
      divisionId: divisionMap['id'] as String,
      divisionName: divisionMap['name'] as String,
    );
  }
  
  @override
  String toString() => "$fullName ($shorthand) ($wins - $losses)";
  
}
