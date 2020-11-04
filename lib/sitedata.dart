part of site_objects;

class SiteData {
  final String lastUpdate;
  final int season;
  final int day;
  final String sub1id;
  final String sub1name;
  final String sub2id;
  final String sub2name;
  
  List<String> get subnicknames => 
    [sub1name.split(' ')[1],
    sub2name.split(' ')[1]];
  
  SiteData.fromMap({this.lastUpdate, 
    this.season, this.day,
    this.sub1id, this.sub1name,
    this.sub2id, this.sub2name});
  
  SiteData(this.lastUpdate, 
    this.season, this.day,
    this.sub1id, this.sub1name,
    this.sub2id, this.sub2name);
  
  factory SiteData.fromJson(Map<String, dynamic> json){
    return SiteData.fromMap(
      lastUpdate: json['lastUpdate'] as String,
      season: json['season'] as int,
      day: json['day'] as int,
      sub1id: json['sub1id'] as String,
      sub1name: json['sub1name'] as String,
      sub2id: json['sub2id'] as String,
      sub2name: json['sub2name'] as String,
    );
  }
  
  Map toJson() => {
      'lastUpdate': lastUpdate,
      'season':   season,
      'day':      day,
      'sub1id':   sub1id,
      'sub1name': sub1name,
      'sub2id':   sub2id,
      'sub2name': sub2name,
  };
  
  @override
  String toString() => "$lastUpdate $sub1name $sub2name";
}