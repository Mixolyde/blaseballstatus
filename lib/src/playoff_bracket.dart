part of site_objects;

class PlayoffBracketEntry{
  //position in display bracket [0-18]
  final int position;
  int seed;
  String teamID;
  String teamNickname;
  String subleague;
  int wins;

  PlayoffBracketEntry({this.position = 0, this.seed = 1, 
    this.teamID = '', this.teamNickname = '', this.subleague = '', this.wins = 0});
    
  factory PlayoffBracketEntry.fromJson(Map<String, dynamic> json){
    return PlayoffBracketEntry(
      position: json['position'] as int,
      seed: json['seed'] as int,
      teamID: json['teamID'] as String,
      teamNickname: json['teamNickname'] as String,
      subleague: json['subleague'] as String,
      wins: json['wins'] as int,  
    );
  }  
  
  Map toJson() => {
    'position': position,
    'seed': seed,
    'teamID': teamID,
    'teamNickname': teamNickname,
    'subleague': subleague,
    'wins': wins,
  };
    
  @override
  String toString() => 'Index:$position Seed:$seed Team:$teamNickname League:$subleague Wins:$wins';
  
}
