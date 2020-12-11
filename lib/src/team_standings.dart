part of site_objects;

class TeamStandings {
  final String id;
  final String fullName;
  final String nickname;
  final String emoji;
  final String division;
  int wins;
  int losses;
  final int gamesPlayed;
  final int favor;
  
  String gbDiv = '-';
  String gbWc = '-';
  final List<String> po = ['-', '-', '-', '-', '-'];
  final List<String> winning = ['-', '-', '-', '-', '-'];
  final List<String> partytime = ['-', '-', '-', '-', '-'];
  final List<String> post = ['-', '-', '-', '-', '-'];  
  
  TeamStandings(this.id, this.fullName, this.nickname, 
    this.emoji, this.division,
    this.wins, this.losses, this.gamesPlayed, this.favor);
    
  TeamStandings.fromMap({this.id, this.fullName,
    this.nickname, this.emoji, this.division,
    this.wins, this.losses,
    this.gamesPlayed, this.favor,
    this.gbDiv, this.gbWc,
    po, winning, partytime, post}){
    for(int i = 0; i < 5; i++){
      this.po[i] = po[i].toString();
      this.winning[i] = winning[i].toString();
      this.partytime[i] = partytime[i].toString();
      this.post[i] = post[i].toString();
    }
  }
    
  factory TeamStandings.fromJson(Map<String, dynamic> json){
    return TeamStandings.fromMap(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      nickname: json['nickname'] as String,
      emoji: json['emoji'] as String,
      division: json['division'] as String,
      wins: json['wins'] as int,
      losses: json['losses'] as int,
      gamesPlayed: json['gamesPlayed'] as int,
      favor: json['favor'] as int,
      gbDiv: json['gbDiv'] as String,
      gbWc: json['gbWc'] as String,
      po: json['po'] as List<dynamic>,
      winning: json['winning'] as List<dynamic>,
      partytime: json['partytime'] as List<dynamic>,
      post: json['post'] as List<dynamic>,
    );
  }
    
  Map toJson() => {
    'id': id,
    'fullName': fullName,
    'nickname': nickname,
    'emoji': emoji,
    'division': division,
    'wins': wins,
    'losses': losses,
    'gamesPlayed': gamesPlayed,
    'favor': favor,
    'gbDiv': gbDiv,
    'gbWc': gbWc,
    'po': po,
    'winning': winning,
    'partytime': partytime,
    'post': post,
  };
  
  @override
  String toString() => "Standings: $nickname - $division ($wins - $losses) Favor: #$favor";
  
}
