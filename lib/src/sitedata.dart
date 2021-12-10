part of site_objects;

class SiteData {
  final String lastUpdate;
  final int season;
  final int day;
  final String sub1id;
  final String sub1name;
  final String sub2id;
  final String sub2name;
  final List<String> attributes;
  final int daysInSeason;

  
  List<String> get subnicknames => 
    //[sub1name.split(' ')[1],
    //sub2name.split(' ')[1]];
    [sub1name, sub2name];
  
  SiteData.fromMap({this.lastUpdate = '', 
    this.season = 0, this.day = 0,
    this.sub1id = '', this.sub1name = '',
    this.sub2id = '', this.sub2name = '',
    this.attributes = const [],
    this.daysInSeason = 99});
  
  SiteData(this.lastUpdate, 
    this.season, this.day,
    this.sub1id, this.sub1name,
    this.sub2id, this.sub2name, 
    this.attributes, this.daysInSeason);
  
  factory SiteData.fromJson(Map<String, dynamic> json){
    return SiteData.fromMap(
      lastUpdate: json['lastUpdate'] as String,
      season: json['season'] as int,
      day: json['day'] as int,
      sub1id: json['sub1id'] as String,
      sub1name: json['sub1name'] as String,
      sub2id: json['sub2id'] as String,
      sub2name: json['sub2name'] as String,
      attributes: json['attributes'] == null ? [] :
        (json['attributes'] as List<dynamic>)
        .map((t) => t.toString()).toList() as List<String>,      
      daysInSeason: json['daysInSeason'] as int,
    );
  }
  
  Map toJson() => {
      'lastUpdate': lastUpdate,
      'season':     season,
      'day':        day,
      'sub1id':     sub1id,
      'sub1name':   sub1name,
      'sub2id':     sub2id,
      'sub2name':   sub2name,
      'attributes': attributes,
      'daysInSeason': daysInSeason,
  };
  
  @override
  String toString() => '$lastUpdate Season:$season Day:$day $sub1name $sub2name';
  
  bool get leagueWildCards => attributes.contains('WILD_CARDS');

}
