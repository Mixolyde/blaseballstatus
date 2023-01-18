part of database_api;

/*
  api2
  "currentLeagueData":{
      "id":"d3182b4d-91b6-4b4e-96a5-13d69e0043b7",
      "name":"Internet Blaseball League",
      "subLeagues":[{"id":"5335d626-db8c-4181-950a-e650f5f11d00",
        "divisions":[
          {"id":"8b22bdcf-8cf9-46d4-93da-bb75a6413786","name":"Awful Good"},
          {"id":"67a4acf7-60b6-463d-bcff-63fbf538b3d9","name":"Chaotic Good"}]},
        {"id":"226dc71f-b3a2-4d0d-814e-1b963781cda9",
        "divisions":[
          {"id":"b60a5664-66d8-462a-85ae-9da2d4d9c59e","name":"Awful Evil"},
          {"id":"0b684565-ecaf-4afc-96d2-f4100f127197","name":"Chaotic Evil"}]}]}
*/
class League {
  final String id;
  final String name;
  final String subleagueId1;
  final String subleagueId2;
  final String tiebreakersId;
  
  Subleague? subleague1;
  Subleague? subleague2;
  Tiebreakers? tiebreakers;

  League({this.id = '', this.name = '', this.subleagueId1 = '', this.subleagueId2 = '',
    this.tiebreakersId = ''});
    
  factory League.fromJson(Map<String, dynamic> json){
    List<dynamic> subLeagueJson = json['subLeagues'];
    return League(
      id: json['id'] as String,
      name: json['name'] as String,
      subleagueId1: (subLeagueJson[0] as Map<String, dynamic>)['id'],
      subleagueId2: (subLeagueJson[1] as Map<String, dynamic>)['id'],
      //tiebreakersId: json['tiebreakers'] as String,
      tiebreakersId: "",
    );
  }
  
  @override
  String toString() => '$name:$id';
}

/*
  'divisions': [
    'f711d960-dc28-4ae2-9249-e1f320fec7d7',
    '5eb2271a-3e49-48dc-b002-9cb615288836'
  ],
  'id':'7d3a3dd6-9ea1-4535-9d91-bde875c85e80',
  'name':'The Good League'
  */
class Subleague {
  final String id;
  final String name;
  final String divisionId1;
  final String divisionId2;
  
  Division? division1;
  Division? division2;

  Subleague({this.id = '', this.name = '', this.divisionId1 = '', this.divisionId2 = ''});
    
  factory Subleague.fromJson(Map<String, dynamic> json){
    return Subleague(
      id: json['id'] as String,
      name: json['name'] as String,
      divisionId1: (json['divisions'] as List)[0]['id'],
      divisionId2: (json['divisions'] as List)[1]['id'],
    );
  }  
  
  @override
  String toString() => '$name:$id';

}

/*
  'id': 'f711d960-dc28-4ae2-9249-e1f320fec7d7',
  'teams': [
    'b72f3061-f573-40d7-832a-5ad475bd7909',
    '878c1bf6-0d21-4659-bfee-916c8314d69c',
    'b024e975-1c4a-4575-8936-a3754a08806a',
    'adc5b394-8f76-416d-9ce9-813706877b84',
    'ca3f1c8c-c025-4d8e-8eef-5be6accbeb16'
  ],
  'name': 'Lawful Good'
  */
class Division{
  final String id;
  final String name;
  final List<String> teams;  
  
  Division({required this.id, required this.name, required this.teams});
    
  factory Division.fromJson(Map<String, dynamic> json){
    return Division(
      id: json['id'] as String,
      name: json['name'] as String,
      teams: (json['teams'] as List<dynamic>)
        .map((t) => t.toString()).toList(),
    );
  }  
  
  @override
  String toString() => '$name:$id';
  
}
