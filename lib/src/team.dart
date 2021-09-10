part of database_api;

class Team {
  final String id;
  final String fullName;
  final String nickname;
  final String shorthand;
  final String emoji;
  
  Team({this.id = '', this.fullName = '', this.nickname = '', 
    this.shorthand = '', this.emoji = ''});
  
  factory Team.fromJson(Map<String, dynamic> json){
    return Team(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      nickname: json['nickname'] as String,
      shorthand: json['shorthand'] as String,
      emoji: json['emoji'] as String,
    );
  }
  
  @override
  String toString() => '$fullName';
  
}
