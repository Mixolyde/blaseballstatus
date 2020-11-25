part of database_api;

/*
  "subleagues": [
    "7d3a3dd6-9ea1-4535-9d91-bde875c85e80",
    "93e58443-9617-44d4-8561-e254a1dbd450"
  ],
  "id":"d8545021-e9fc-48a3-af74-48685950a183",
  "name":"Internet League Blaseball",
  "tiebreakers":"72a618ed-c61c-4162-a455-3959a2d0e738"
*/
class League {
  final String id;
  final String name;
  final String subleagueId1;
  final String subleagueId2;
  final String tiebreakersId;
  
  Subleague subleague1;
  Subleague subleague2;
  Tiebreakers tiebreakers;

  League({this.id, this.name, this.subleagueId1, this.subleagueId2,
    this.tiebreakersId});
    
  factory League.fromJson(Map<String, dynamic> json){
    return League(
      id: json['id'] as String,
      name: json['name'] as String,
      subleagueId1: (json['subleagues'] as List)[0],
      subleagueId2: (json['subleagues'] as List)[1],
      tiebreakersId: json['tiebreakers'] as String,
    );
  }
  
  @override
  String toString() => "$name:$id";
}

/*
  "divisions": [
    "f711d960-dc28-4ae2-9249-e1f320fec7d7",
    "5eb2271a-3e49-48dc-b002-9cb615288836"
  ],
  "id":"7d3a3dd6-9ea1-4535-9d91-bde875c85e80",
  "name":"The Good League"
  */
class Subleague {
  final String id;
  final String name;
  final String divisionId1;
  final String divisionId2;
  
  Division division1;
  Division division2;

  Subleague({this.id, this.name, this.divisionId1, this.divisionId2});
    
  factory Subleague.fromJson(Map<String, dynamic> json){
    return Subleague(
      id: json['id'] as String,
      name: json['name'] as String,
      divisionId1: (json['divisions'] as List)[0],
      divisionId2: (json['divisions'] as List)[1],
    );
  }  
  
  @override
  String toString() => "$name:$id";

}

/*
  "id": "f711d960-dc28-4ae2-9249-e1f320fec7d7",
  "teams": [
    "b72f3061-f573-40d7-832a-5ad475bd7909",
    "878c1bf6-0d21-4659-bfee-916c8314d69c",
    "b024e975-1c4a-4575-8936-a3754a08806a",
    "adc5b394-8f76-416d-9ce9-813706877b84",
    "ca3f1c8c-c025-4d8e-8eef-5be6accbeb16"
  ],
  "name": "Lawful Good"
  */
class Division{
  final String id;
  final String name;
  final List<String> teams;  
  
  Division({this.id, this.name, this.teams});
    
  factory Division.fromJson(Map<String, dynamic> json){
    return Division(
      id: json['id'] as String,
      name: json['name'] as String,
      teams: (json['teams'] as List<dynamic>)
        .map((t) => t.toString()).toList(),
    );
  }  
  
  @override
  String toString() => "$name:$id";
  
}