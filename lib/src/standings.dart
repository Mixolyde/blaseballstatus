part of database_api;

/*
    
{"Uptempo":
  {"Bop":[
    {"id":"43a27ded-3229-49b5-9e44-2213d946588e","emoji":"0x1F36C","mainColor":"#178f55","secondaryColor":"#178f55","fullName":"Kansas City Breath Mints","wins":49,"losses":35,"partyTime":false,"deceased":false,"scattered":false},
    {"id":"266c8526-9961-4679-883a-6f14b40b1fc3","emoji":"0x1F6A4","mainColor":"#9141ba","secondaryColor":"#cd76fa","fullName":"Miami Dale","wins":41,"losses":43,"partyTime":false,"deceased":false,"scattered":false},
    {"id":"5cd141a6-3885-47f1-9e76-3ac108e51578","emoji":"0x1F3DD","mainColor":"#3ee652","secondaryColor":"#3ee652","fullName":"Hawai'i Fridays","wins":41,"losses":43,"partyTime":false,"deceased":false,"scattered":false},
    {"id":"7e89ab0c-e63e-44e2-8c9d-689ad30cc5b3","emoji":"0x1F4F1","mainColor":"#ffd4d8","secondaryColor":"#ffd4d8","fullName":"New York Millennials","wins":37,"losses":47,"partyTime":false,"deceased":false,"scattered":false},
    {"id":"af191af8-f0c1-4aac-9fb5-aed18f39a126","emoji":"0x1F450","mainColor":"#6388ad","secondaryColor":"#7ba9d7","fullName":"Breckenridge Jazz Hands","wins":31,"losses":53,"partyTime":false,"deceased":false,"scattered":false},
    {"id":"2447e81d-aa1f-4085-a236-a332dc6cc852","emoji":"0x1F5E3","mainColor":"#f5feff","secondaryColor":"#f5feff","fullName":"Canada Moist Talkers","wins":25,"losses":59,"partyTime":false,"deceased":false,"scattered":false}],
  "Jam":[{"id":"51acdb7f-7cb9-44a0-8045-28c0d4b93c97","emoji":"0x1F339","mainColor":"#f7d1ff","secondaryColor":"#f7d1ff","fullName":"Boston Flowers","wins":59,"losses":25,"partyTime":false,"deceased":false,"scattered":false},{"id":"5ca18590-fa0e-4d48-ba83-499807627175","emoji":"0x1F40C","mainColor":"#5c4822","secondaryColor":"#ba9c65","fullName":"Ohio Worms","wins":52,"losses":32,"partyTime":false,"deceased":false,"scattered":false},{"id":"2036a676-afd7-4693-91e0-d1839f23089a","emoji":"0x1F405","mainColor":"#5c1c1c","secondaryColor":"#e83622","fullName":"Hades Tigers","wins":45,"losses":39,"partyTime":false,"deceased":false,"scattered":false},{"id":"d5ba891d-5c45-4580-bbbc-9df0a98828e8","emoji":"0x2728","mainColor":"#bf0043","secondaryColor":"#f60f63","fullName":"Yellowstone Magic","wins":45,"losses":39,"partyTime":false,"deceased":false,"scattered":false},{"id":"c151c964-3d5c-41b6-8416-2a97f913742e","emoji":"0x1F6E0","mainColor":"#d13100","secondaryColor":"#ff5b29","fullName":"Core Mechanics","wins":40,"losses":44,"partyTime":false,"deceased":false,"scattered":false},{"id":"47eab5f7-f0bc-4c8a-8064-adcae710c8e4","emoji":"0x1F32E","mainColor":"#64376e","secondaryColor":"#b063c1","fullName":"LA Unlimited Tacos","wins":38,"losses":46,"partyTime":false,"deceased":false,"scattered":false}]},
"Downtempo":
  {"Dirge":[{"id":"4ac1b94f-a3f6-4650-ade9-1fd8ced20e18","emoji":"0x1F531","mainColor":"#00dbc2","secondaryColor":"#5cffec","fullName":"Atlantis Georgias","wins":57,"losses":27,"partyTime":false,"deceased":false,"scattered":false},{"id":"232bce91-2309-428e-94e1-b8db04ac21dc","emoji":"0x1F45F","mainColor":"#ffce0a","secondaryColor":"#ffce0a","fullName":"Charleston Shoe Thieves","wins":43,"losses":41,"partyTime":false,"deceased":false,"scattered":false},{"id":"db2dee1e-9f7c-4b08-a30d-3d31286122df","emoji":"0x1F525","mainColor":"#8c2a3e","secondaryColor":"#d13757","fullName":"Chicago Firefighters","wins":42,"losses":42,"partyTime":false,"deceased":false,"scattered":false},{"id":"745ff28d-c557-4862-8f66-9775de881b67","emoji":"0x1F575","mainColor":"#67556b","secondaryColor":"#9e82a4","fullName":"Houston Spies","wins":40,"losses":44,"partyTime":false,"deceased":false,"scattered":false},{"id":"ffd22be8-35a9-4424-95ea-4287798fa9f9","emoji":"0x1F31E","mainColor":"#fffbab","secondaryColor":"#fffbab","fullName":"Hellmouth Sunbeams","wins":40,"losses":44,"partyTime":false,"deceased":false,"scattered":false},{"id":"8300554b-15cc-467f-bfa5-28e02024d59f","emoji":"0x1F3B8","mainColor":"#2b4075","secondaryColor":"#5a83ea","fullName":"Seattle Garages","wins":31,"losses":53,"partyTime":false,"deceased":false,"scattered":false}],
  "Ballad":[{"id":"2f90c5e3-21fe-4842-b89a-c00c14bc4d5a","emoji":"0x1F357","mainColor":"#883c17","secondaryColor":"#ee6300","fullName":"Mexico City Wild Wings","wins":53,"losses":31,"partyTime":false,"deceased":false,"scattered":false},{"id":"b9e5f7df-1455-44b0-a659-65fa96bee48e","emoji":"0x1f3cb","mainColor":"#821f60","secondaryColor":"#e830ab","fullName":"Tokyo Lift","wins":45,"losses":39,"partyTime":false,"deceased":false,"scattered":false},{"id":"4ad4b645-80eb-4375-80cd-6ab227c5894b","emoji":"0x1F969","mainColor":"#8c8d8f","secondaryColor":"#b2b3b5","fullName":"Dallas Steaks","wins":40,"losses":44,"partyTime":false,"deceased":false,"scattered":false},{"id":"537cf346-533e-4f8d-92e6-54a43b285e18","emoji":"0x1F48B","mainColor":"#780018","secondaryColor":"#da0000","fullName":"San Francisco Lovers","wins":40,"losses":44,"partyTime":false,"deceased":false,"scattered":false},{"id":"fa3b11e7-5321-485f-bdbd-355af10cce11","emoji":"0x1F967","mainColor":"#399d8f","secondaryColor":"#58c3b4","fullName":"Philly Pies","wins":38,"losses":46,"partyTime":false,"deceased":false,"scattered":false},{"id":"e09e5d91-dd07-4551-abb8-e527f59361a8","emoji":"0x1F980","mainColor":"#593037","secondaryColor":"#b05c6b","fullName":"Baltimore Crabs","wins":36,"losses":48,"partyTime":false,"deceased":false,"scattered":false}]}}    
*/

class Standings {
  final Map<String, Standing> standings;
  
  Standings(this.standings);
  
  factory Standings.fromJson(Map<String, dynamic> json){
    //var standingsMap = json as Map<String, Map<String, List<Map<String, dynamic>>>>;
    Map<String, Standing> result = <String, Standing>{};
    json.values.forEach( (leagueMap) =>
      leagueMap.values.forEach( (subleagueList) =>
        subleagueList.forEach((stand){
          //print(stand);
          result[stand['id'] as String] = Standing(
            id: stand['id'] as String,
            emoji: stand['emoji'] as String,
            mainColor: stand['mainColor'] as String,
            secondaryColor: stand['secondaryColor'] as String,
            fullName: stand['fullName'] as String,
            wins: stand['wins'] as int,
            losses: stand['losses'] as int,
            partyTime: stand['partyTime'] as bool,
            deceased: stand['deceased'] as bool,
            scattered: stand['scattered'] as bool,
          );
        }))
    );
      
    return Standings(result);
  }
  
  @override
  String toString() => 'Standings: $standings';

}

/*
  {"id":"43a27ded-3229-49b5-9e44-2213d946588e",
  "emoji":"0x1F36C",
  "mainColor":"#178f55",
  "secondaryColor":"#178f55",
  "fullName":"Kansas City Breath Mints",
  "wins":49,"losses":35,
  "partyTime":false,
  "deceased":false,
  "scattered":false},
*/

class Standing {
  final String id;
  final String emoji;
  final String mainColor;
  final String secondaryColor;
  final String fullName;
  final int wins;
  final int losses;
  final bool partyTime;
  final bool deceased;
  final bool scattered; 
  
  Standing({required this.id, required this.emoji, required this.mainColor,
    required this.secondaryColor, required this.fullName,
    required this.wins, required this.losses,
    required this.partyTime, required this.deceased,
    required this.scattered});
    
  @override
  String toString() => 'Standing: $id $fullName ($wins-$losses)';    
}
