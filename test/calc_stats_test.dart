import 'package:test/test.dart';

import '../lib/calc_stats.dart';
import '../lib/database_api.dart';
import '../lib/site_objects.dart';

void main() {
  apiUrl = "https://blaseball.com/database/";
  group('get site data', () {
    test('fake attributes', () async {
      SimulationData simData = await getSimulationData();
      SimulationData oldSimData = new SimulationData(
        id: simData.id,
        day: 113,
        league: "d8545021-e9fc-48a3-af74-48685950a183",
        playOffRound: 3,
        season: 14,
        seasonId: "645cdd84-175f-42f1-a9f3-d9014d97ae3b",
        eraTitle: simData.eraTitle,
        subEraTitle: simData.subEraTitle,
        attributes: ["TEST_ATTR1", "TEST_ATTR2", "TEST_ATTR3"],
      );
      
      SiteData result = await calcSiteData(oldSimData);
      expect(result.season, 14);
      expect(result.day, 113);
      expect(result.sub1id, '943dd53f-fd89-45c3-9a56-78ac1088f57d');
      expect(result.sub1name, "The Levil League");
      expect(result.sub2id, '5945c7db-c097-4eb7-967f-11c5bbef5c25');
      expect(result.sub2name, "The Glood League");
      expect(result.simWildCards, false);
      
    });
    test('real attributes', () async {
      SimulationData simData = await getSimulationData();
      SimulationData oldSimData = new SimulationData(
        id: simData.id,
        day: 113,
        league: "d8545021-e9fc-48a3-af74-48685950a183",
        playOffRound: 3,
        season: 14,
        seasonId: "645cdd84-175f-42f1-a9f3-d9014d97ae3b",
        eraTitle: simData.eraTitle,
        subEraTitle: simData.subEraTitle,
        attributes: ["SIM_PARTY_TIME", "WILD_CARDS", "OPENED_BOOK"],
      );
      
      SiteData result = await calcSiteData(oldSimData);
      expect(result.simWildCards, true);
      
    });    
  });
  group('Sort div leader tests', () {
    test('No resort needed', () {
      var standings = getLateSeasonStandings();
      List<TeamStandings> top6 = standings.take(6).toList();
      sortTeamsNotGrouped(standings);
      expect(standings[0], top6[0]);
      expect(standings[1], top6[1]);
      expect(standings[2], top6[2]);
      expect(standings[3], top6[3]);
      expect(standings[4], top6[4]);
      expect(standings[5], top6[5]);
    });  
    test('Resort needed', () {
      var standings = getLateSeasonResortNeededStandings();
      List<TeamStandings> top6 = standings.take(6).toList();
      sortTeamsNotGrouped(standings);
      expect(standings[0], top6[0]);
      expect(standings[1], top6[1]);
      expect(standings[2], top6[2]);
      expect(standings[3], top6[5]);
      expect(standings[4], top6[3]);
      expect(standings[5], top6[4]);
    });     
  });
  group('format tests', () {
    test('Format games behind', () {
      expect(formatGamesBehind(0), "0");
      expect(formatGamesBehind(1), "1");
      expect(formatGamesBehind(0.5), "½");
      expect(formatGamesBehind(1.5), "1½");
      expect(formatGamesBehind(2.5), "2½");
    });  
  });
  group('Games Behind number tests', () {
    test('Near season end', () {
      var standings = getLateSeasonStandings();
      calculateGamesBehind(standings);
      
      expect(standings[0].gbDiv, "-");
      expect(standings[0].gbWc, "-");
      
      expect(standings[1].gbDiv, "-");
      expect(standings[1].gbWc, "-");
      
      expect(standings[2].gbDiv, "1½");
      expect(standings[2].gbWc, "-");
      
      expect(standings[3].gbDiv, "7");
      expect(standings[3].gbWc, "-");
      
      expect(standings[4].gbDiv, "22½");
      expect(standings[4].gbWc, "4½");
      
    });  
    test('Near season end resort needed', () {
      var standings = getLateSeasonResortNeededStandings();
      sortTeamsNotGrouped(standings);
      calculateGamesBehind(standings);
      
      int i = 0;
      print("${standings[i]} ${standings[i].gbDiv} ${standings[i].gbWc}");
      expect(standings[i].gbDiv, "-");
      expect(standings[i].gbWc, "-");
      
      i = 1;
      print("${standings[i]} ${standings[i].gbDiv} ${standings[i].gbWc}");
      expect(standings[i].gbDiv, "12");
      expect(standings[i].gbWc, "-");
      
      i = 2;
      print("${standings[i]} ${standings[i].gbDiv} ${standings[i].gbWc}");
      expect(standings[i].gbDiv, "12½");
      expect(standings[i].gbWc, "-");
      
      i = 3;
      print("${standings[i]} ${standings[i].gbDiv} ${standings[i].gbWc}");
      expect(standings[i].gbDiv, "-");
      expect(standings[i].gbWc, "-");
      
      i = 4;
      print("${standings[i]} ${standings[i].gbDiv} ${standings[i].gbWc}");
      expect(standings[i].gbDiv, "18");
      expect(standings[i].gbWc, "6½");
      
      i = 5;
      print("${standings[i]} ${standings[i].gbDiv} ${standings[i].gbWc}");
      expect(standings[i].gbDiv, "22½");
      expect(standings[i].gbWc, "10");
      
      i = 6;
      print("${standings[i]} ${standings[i].gbDiv} ${standings[i].gbWc}");
      expect(standings[i].gbDiv, "6½");
      expect(standings[i].gbWc, "6½");
      
    });      
  });      
  group('Winning magic number tests', () {
    test('Near season end', () {
      var standings = getLateSeasonStandings();
      calculateMagicNumbers(standings);
      
      
      for(int i = 0; i < 2; i++){
        print("${standings[i]} ${standings[i].winning}");
        expect(standings[i].winning[4], "X");
      }
        
      print("${standings[0]} ${standings[0].winning}");
      expect(standings[0].winning[0], "^");
      expect(standings[0].winning[1], "X");
      expect(standings[0].winning[2], "X");
      expect(standings[0].winning[3], "X");
      
      
      print("${standings[1]} ${standings[1].winning}");
      expect(standings[1].winning[0], "X");
      expect(standings[1].winning[1], 
        (53 + 10 - 55 + 1).toString());
      expect(standings[1].winning[2], 
        (48 + 9 - 55 + 1).toString());
      expect(standings[1].winning[3], "^");
      
      print("${standings[2]} ${standings[2].winning}");
      expect(standings[2].winning[0], "X");
      expect(standings[2].winning[1], "DNCD");
      expect(standings[2].winning[2], "4");
      expect(standings[2].winning[3], "1");      

      print("${standings[3]} ${standings[3].winning}");
      expect(standings[3].winning[0], "X");
      expect(standings[3].winning[1], "DNCD");
      expect(standings[3].winning[2], "DNCD");
      expect(standings[3].winning[3], "6");   
      
      print("${standings[4]} ${standings[4].winning}");
      expect(standings[4].winning[0], "X");
      expect(standings[4].winning[1], "X");
      expect(standings[4].winning[2], "DNCD");
      expect(standings[4].winning[3], "DNCD");  

      print("${standings[5]} ${standings[5].winning}");
      expect(standings[5].winning[0], "X");
      expect(standings[5].winning[1], "X");
      expect(standings[5].winning[2], "X");
      expect(standings[5].winning[3], "DNCD");  
      
      for (int i = 6; i < standings.length; i++){
        print("${standings[i]} ${standings[i].winning}");
        expect(standings[i].winning[0], "X");
        expect(standings[i].winning[1], "X");
        expect(standings[i].winning[2], "X");
        expect(standings[i].winning[3], "X"); 
        expect(standings[i].winning[4], "PT");
      }
    });  
    test('Near season beginning', () {
      var standings = getEarlySeasonStandings();
      calculateMagicNumbers(standings);
      
      
      for(int i = 0; i < 10; i++){
        //print("${standings[i]} ${standings[i].winning}");
        expect(standings[i].winning[4], "0");
      }
        
      print("${standings[0]} ${standings[0].winning}");
      expect(standings[0].winning[0], "63");
      expect(standings[0].winning[1], "59");
      expect(standings[0].winning[2], "56");
      expect(standings[0].winning[3], "53");
      
      
      print("${standings[1]} ${standings[1].winning}");
      expect(standings[1].winning[0], "DNCD");
      expect(standings[1].winning[1], "62");
      expect(standings[1].winning[2], "59");
      expect(standings[1].winning[3], "56");
      
      print("${standings[2]} ${standings[2].winning}");
      expect(standings[2].winning[0], "DNCD");
      expect(standings[2].winning[1], "DNCD");
      expect(standings[2].winning[2], "63");
      expect(standings[2].winning[3], "60");      

      print("${standings[3]} ${standings[3].winning}");
      expect(standings[3].winning[0], "DNCD");
      expect(standings[3].winning[1], "DNCD");
      expect(standings[3].winning[2], "DNCD");
      expect(standings[3].winning[3], "62");   
      
      for (int i = 4; i < standings.length; i++){
        print("${standings[i]} ${standings[i].winning}");
        expect(standings[i].winning[0], "DNCD");
        expect(standings[i].winning[1], "DNCD");
        expect(standings[i].winning[2], "DNCD");
        expect(standings[i].winning[3], "DNCD"); 
      }
    });  
    test('Near season beginning ReSort Needed', () {
      var standings = getEarlySeasonResortNeededStandings();
      sortTeamsNotGrouped(standings);
      calculateMagicNumbers(standings);
      
      
      for(int i = 0; i < 10; i++){
        //print("${standings[i]} ${standings[i].winning}");
        expect(standings[i].winning[4], "0");
      }
      
      for(int i = 0; i < 7; i++){
        //printing top table to view data
        print("${standings[i]} ${standings[i].winning}");
      }
      // 34 played 65 left
      // 77 vs 62 15 left
        
      print("${standings[0]} ${standings[0].winning}");
      expect(standings[0].winning[0], "63");
      expect(standings[0].winning[1], "59");
      expect(standings[0].winning[2], "56");
      expect(standings[0].winning[3], "DNCD");
      
      
      print("${standings[1]} ${standings[1].winning}");
      expect(standings[1].winning[0], "DNCD");
      expect(standings[1].winning[1], "62");
      expect(standings[1].winning[2], "59");
      expect(standings[1].winning[3], "DNCD");
      
      print("${standings[2]} ${standings[2].winning}");
      expect(standings[2].winning[0], "DNCD");
      expect(standings[2].winning[1], "DNCD");
      expect(standings[2].winning[2], "63");
      expect(standings[2].winning[3], "DNCD");      

      print("${standings[3]} ${standings[3].winning}");
      expect(standings[3].winning[0], "DNCD");
      expect(standings[3].winning[1], "DNCD");
      expect(standings[3].winning[2], "DNCD");
      expect(standings[3].winning[3], "62");   
      
      for (int i = 4; i < standings.length; i++){
        print("${standings[i]} ${standings[i].winning}");
        expect(standings[i].winning[0], "DNCD");
        expect(standings[i].winning[1], "DNCD");
        expect(standings[i].winning[2], "DNCD");
        expect(standings[i].winning[3], "DNCD"); 
      }
    });  
    test('New season', () {
      var standings = getNewSeasonStandings();
      calculateMagicNumbers(standings);
      
      for(int i = 0; i < 4; i++){
        print("${standings[i]} ${standings[i].winning}");
        expect(standings[i].winning[4], "0");
      }
      
      for (int i = 4; i < standings.length; i++){
        print("${standings[i]} ${standings[i].winning}");
        expect(standings[i].winning[0], "DNCD");
        expect(standings[i].winning[1], "DNCD");
        expect(standings[i].winning[2], "DNCD");
        expect(standings[i].winning[3], "DNCD"); 
        expect(standings[i].winning[4], "0");
      }
    });    
    test('End of season', () {
      var standings = getEndOfSeasonStandings();
      calculateMagicNumbers(standings);
      for(int i = 0; i < standings.length; i++){
        print("${standings[i]} ${standings[i].winning}");
        for (int j = 0; j < 5; j++){
          if (i >= 4 && j == 4){
            expect(standings[i].winning[j], "PT");
          } else if (i == j && j < 4){
            expect(standings[i].winning[j], "^");
          } else {
            expect(standings[i].winning[j], "X");
          }
        }
      }
    });      
    test('End of season with resort', () {
      var standings = getEndOfSeasonResortNeededStandings();
      sortTeamsNotGrouped(standings);
      calculateMagicNumbers(standings);
      for(int i = 0; i < standings.length; i++){
        print("${standings[i]} ${standings[i].winning}");
        for (int j = 0; j < 5; j++){
          if (i >= 4 && j == 4){
            expect(standings[i].winning[j], "PT");
          } else if (i == j && j < 4){
            expect(standings[i].winning[j], "^");
          } else {
            expect(standings[i].winning[j], "X");
          }
        }
      }
    });      
  });  
  group('Party Time magic number tests', () {
    test('Near season end', () {
      var standings = getLateSeasonStandings();
      calculateMagicNumbers(standings);
        
      print("${standings[0]} ${standings[0].partytime}");
      expect(standings[0].partytime[0], "^");
      expect(standings[0].partytime[1], "X");
      expect(standings[0].partytime[2], "X");
      expect(standings[0].partytime[3], "X");
      expect(standings[0].partytime[4], "X");
      
      print("${standings[1]} ${standings[1].partytime}");
      expect(standings[1].partytime[0], "X");
      expect(standings[1].partytime[1], "MW");
      expect(standings[1].partytime[2], "MW");
      expect(standings[1].partytime[3], "^");
      expect(standings[1].partytime[4], "X");
      
      print("${standings[2]} ${standings[2].partytime}");
      expect(standings[2].partytime[0], "X");
      expect(standings[2].partytime[1], "9");
      expect(standings[2].partytime[2], "MW");
      expect(standings[2].partytime[3], "MW");  
      expect(standings[2].partytime[4], "MW");      

      print("${standings[3]} ${standings[3].partytime}");
      expect(standings[3].partytime[0], "X");
      expect(standings[3].partytime[1], "3");
      expect(standings[3].partytime[2], "4");
      expect(standings[3].partytime[3], "MW");   
      expect(standings[3].partytime[4], "MW");
      
      print("${standings[4]} ${standings[4].partytime}");
      expect(standings[4].partytime[0], "X");
      expect(standings[4].partytime[1], "X");
      expect(standings[4].partytime[2], "1");
      expect(standings[4].partytime[3], "6");
      expect(standings[4].partytime[4], "MW");      

      print("${standings[5]} ${standings[5].partytime}");
      expect(standings[5].partytime[0], "X");
      expect(standings[5].partytime[1], "X");
      expect(standings[5].partytime[2], "X");
      expect(standings[5].partytime[3], "6");  
      expect(standings[5].partytime[4], "MW"); 
      
      for (int i = 6; i < standings.length; i++){
        print("${standings[i]} ${standings[i].partytime}");
        expect(standings[i].partytime[0], "X");
        expect(standings[i].partytime[1], "X");
        expect(standings[i].partytime[2], "X");
        expect(standings[i].partytime[3], "X"); 
        expect(standings[i].partytime[4], "PT");
      }
    });  
    test('Near season beginning', () {
      var standings = getEarlySeasonStandings();
      calculateMagicNumbers(standings);
      
      
      for(int i = 0; i < 10; i++){
        expect(standings[i].partytime[4], "MW");
      }
        
      print("${standings[0]} ${standings[0].partytime}");
      expect(standings[0].partytime[0], "MW");
      expect(standings[0].partytime[1], "MW");
      expect(standings[0].partytime[2], "MW");
      expect(standings[0].partytime[3], "MW");
      
      
      print("${standings[1]} ${standings[1].partytime}");
      expect(standings[1].partytime[0], "63");
      expect(standings[1].partytime[1], "MW");
      expect(standings[1].partytime[2], "MW");
      expect(standings[1].partytime[3], "MW");
      
      print("${standings[2]} ${standings[2].partytime}");
      expect(standings[2].partytime[0], "59");
      expect(standings[2].partytime[1], "62");
      expect(standings[2].partytime[2], "MW");
      expect(standings[2].partytime[3], "MW");      

      print("${standings[3]} ${standings[3].partytime}");
      expect(standings[3].partytime[0], "56");
      expect(standings[3].partytime[1], "59");
      expect(standings[3].partytime[2], "63");
      expect(standings[3].partytime[3], "MW");   
      
      print("${standings[4]} ${standings[4].partytime}");
      expect(standings[4].partytime[0], "53");
      expect(standings[4].partytime[1], "56");
      expect(standings[4].partytime[2], "60");
      expect(standings[4].partytime[3], "62"); 

      print("${standings[5]} ${standings[5].partytime}");
      expect(standings[5].partytime[0], "50");
      expect(standings[5].partytime[1], "53");
      expect(standings[5].partytime[2], "57");
      expect(standings[5].partytime[3], "60"); 

      for (int i = 6; i < standings.length; i++){
        print("${standings[i]} ${standings[i].partytime}");
        //expect(standings[i].partytime[0], "DNCD");
        //expect(standings[i].partytime[1], "DNCD");
        //expect(standings[i].partytime[2], "DNCD");
        //expect(standings[i].partytime[3], "DNCD"); 
      }
    });  
    test('Near season beginning ReSort Needed', () {
      var standings = getEarlySeasonResortNeededStandings();
      sortTeamsNotGrouped(standings);
      calculateMagicNumbers(standings);
      
      
      for(int i = 0; i < 10; i++){
        expect(standings[i].partytime[4], "MW");
      }
        
      print("${standings[0]} ${standings[0].partytime}");
      expect(standings[0].partytime[0], "MW");
      expect(standings[0].partytime[1], "MW");
      expect(standings[0].partytime[2], "MW");
      expect(standings[0].partytime[3], "MW");
      
      
      print("${standings[1]} ${standings[1].partytime}");
      expect(standings[1].partytime[0], "63");
      expect(standings[1].partytime[1], "MW");
      expect(standings[1].partytime[2], "MW");
      expect(standings[1].partytime[3], "MW");
      
      print("${standings[2]} ${standings[2].partytime}");
      expect(standings[2].partytime[0], "59");
      expect(standings[2].partytime[1], "62");
      expect(standings[2].partytime[2], "MW");
      expect(standings[2].partytime[3], "MW");      

      print("${standings[3]} ${standings[3].partytime}");
      expect(standings[3].partytime[0], "50");
      expect(standings[3].partytime[1], "53");
      expect(standings[3].partytime[2], "57");
      expect(standings[3].partytime[3], "MW");   
      
      print("${standings[4]} ${standings[4].partytime}");
      expect(standings[4].partytime[0], "56");
      expect(standings[4].partytime[1], "59");
      expect(standings[4].partytime[2], "63");
      expect(standings[4].partytime[3], "63"); 

      print("${standings[5]} ${standings[5].partytime}");
      expect(standings[5].partytime[0], "53");
      expect(standings[5].partytime[1], "56");
      expect(standings[5].partytime[2], "60");
      expect(standings[5].partytime[3], "60"); 

      for (int i = 6; i < standings.length; i++){
        print("${standings[i]} ${standings[i].partytime}");
        //expect(standings[i].partytime[0], "DNCD");
        //expect(standings[i].partytime[1], "DNCD");
        //expect(standings[i].partytime[2], "DNCD");
        //expect(standings[i].partytime[3], "DNCD"); 
      }
    });  
    test('New season', () {
      var standings = getNewSeasonStandings();
      calculateMagicNumbers(standings);
      
      for(int i = 0; i < standings.length; i++){
        print("${standings[i]} ${standings[i].partytime}");
        expect(standings[i].partytime[4], "MW");
      }
      
      print("${standings[0]} ${standings[0].partytime}");
      expect(standings[0].partytime[0], "MW");
      expect(standings[0].partytime[1], "MW");
      expect(standings[0].partytime[2], "MW");
      expect(standings[0].partytime[3], "MW");
      
      print("${standings[1]} ${standings[1].partytime}");
      expect(standings[1].partytime[0], "99");
      expect(standings[1].partytime[1], "MW");
      expect(standings[1].partytime[2], "MW");
      expect(standings[1].partytime[3], "MW");
      
      for (int i = 4; i < standings.length; i++){
        print("${standings[i]} ${standings[i].partytime}");
        expect(standings[i].partytime[0], "99");
        expect(standings[i].partytime[1], "99");
        expect(standings[i].partytime[2], "99");
        expect(standings[i].partytime[3], "99"); 
      }
    });    
    test('End of season', () {
      var standings = getEndOfSeasonStandings();
      calculateMagicNumbers(standings);
      
      for(int i = 0; i < standings.length; i++){
        print("${standings[i]} ${standings[i].partytime}");
        for (int j = 0; j < 5; j++){
          if (i >= 4 && j == 4){
            expect(standings[i].partytime[j], "PT");
          } else if (i == j && j < 4){
            expect(standings[i].partytime[j], "^");
          } else {
            expect(standings[i].partytime[j], "X");
          }
        }
      }
    });      
    test('End of season, resort needed', () {
      var standings = getEndOfSeasonResortNeededStandings();
      sortTeamsNotGrouped(standings);
      calculateMagicNumbers(standings);
      
      for(int i = 0; i < standings.length; i++){
        print("${standings[i]} ${standings[i].partytime}");
        for (int j = 0; j < 5; j++){
          if (i >= 4 && j == 4){
            expect(standings[i].partytime[j], "PT");
          } else if (i == j && j < 4){
            expect(standings[i].partytime[j], "^");
          } else {
            expect(standings[i].partytime[j], "X");
          }
        }
      }
    });     
  });  

}

List<TeamStandings> getEarlySeasonStandings(){
  List<TeamStandings> teamStandings = [];
  for(int i = 0; i < standingsData.length; i++){
    teamStandings.add(new TeamStandings(
      i.toString(),
      standingsData[i][0],
      standingsData[i][0],
      "emoji $i",
      "League 0",
      standingsData[i][1],
      i * 3,
      34 - (i * 3),
      34,
      standingsData[i][2],
    ));
  }
  
  sortTeamsNotGrouped(teamStandings);
  return teamStandings;
}

List<TeamStandings> getEarlySeasonResortNeededStandings(){
  List<TeamStandings> teamStandings = [];
  String div;
  for(int i = 0; i < standingsData.length; i++){
    if(i < 5) {
      div = "High";
    } else {
      div = "Low";
    }
    teamStandings.add(new TeamStandings(
      i.toString(),
      standingsData[i][0],
      standingsData[i][0],
      "emoji $i",
      "League 0",
      div,
      i * 3,
      34 - (i * 3),
      34,
      standingsData[i][2],
    ));
  }
  
  sortTeamsNotGrouped(teamStandings);
  return teamStandings;
}

List<TeamStandings> getLateSeasonStandings(){
  List<TeamStandings> teamStandings = [];
  for(int i = 0; i < standingsData.length; i++){
    teamStandings.add(new TeamStandings(
      i.toString(),
      standingsData[i][0],
      standingsData[i][0],
      "emoji $i",
      "League 0",
      standingsData[i][1],
      standingsData[i][3],
      standingsData[i][4],
      standingsData[i][3] + standingsData[i][4],
      standingsData[i][2],
    ));
  }
  
  return teamStandings;
}

List<TeamStandings> getLateSeasonResortNeededStandings(){
  List<TeamStandings> teamStandings = [];
  String div;
  for(int i = 0; i < standingsData.length; i++){
    if(i < 5) {
      div = "High";
    } else {
      div = "Low";
    }
    teamStandings.add(new TeamStandings(
      i.toString(),
      standingsData[i][0],
      standingsData[i][0],
      "emoji $i",
      "League 0",
      div,
      standingsData[i][3],
      standingsData[i][4],
      standingsData[i][3] + standingsData[i][4],
      standingsData[i][2],
    ));
  }
  
  return teamStandings;
}

List<TeamStandings> getNewSeasonStandings(){
  List<TeamStandings> teamStandings = [];
  for(int i = 0; i < standingsData.length; i++){
    teamStandings.add(new TeamStandings(
      i.toString(),
      standingsData[i][0],
      standingsData[i][0],
      "emoji $i",
      "League 0",
      standingsData[i][1],
      0,
      0,
      0,
      standingsData[i][2],
    ));
  }
  
  sortTeamsNotGrouped(teamStandings);
  return teamStandings;
  
}

List<TeamStandings> getEndOfSeasonStandings(){
  List<TeamStandings> teamStandings = [];
  for(int i = 0; i < standingsData.length; i++){
    teamStandings.add(new TeamStandings(
      i.toString(),
      standingsData[i][0],
      standingsData[i][0],
      "emoji $i",
      "League 0",
      standingsData[i][1],
      99 - i,
      i,
      99,
      standingsData[i][2],
    ));
  }
  
  sortTeamsNotGrouped(teamStandings);
  return teamStandings;
}

List<TeamStandings> getEndOfSeasonResortNeededStandings(){
  List<TeamStandings> teamStandings = [];
  String div;
  for(int i = 0; i < standingsData.length; i++){
    if(i < 5) {
      div = "High";
    } else {
      div = "Low";
    }
    teamStandings.add(new TeamStandings(
      i.toString(),
      standingsData[i][0],
      standingsData[i][0],
      "emoji $i",
      "League 0",
      div,
      99 - i,
      i,
      99,
      standingsData[i][2],
    ));
  }

  return teamStandings;
}

List<List<dynamic>> standingsData = [
["Crabs",        "High", 18, 66, 24],
["Spies",         "Low", 20, 55, 35],
["Sunbeams",      "Low", 10, 53, 36],
["Flowers",       "Low", 14, 48, 42],
["Firefighters", "High",  7, 43, 46],
["Millenials",   "High", 12, 43, 46],
["Dale",          "Low", 11, 37, 53],
["Jazz Hands",   "High", 13, 36, 53],
["Lovers",       "High",  2, 35, 55],
["Tacos",         "Low",  3, 33, 56]];


