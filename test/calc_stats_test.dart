import 'package:test/test.dart';

import '../lib/calc_stats.dart';

void main() {
  group('format tests', () {
    test('Format games behind', () {
      expect(formatGamesBehind(0), "0");
      expect(formatGamesBehind(1), "1");
      expect(formatGamesBehind(0.5), "½");
      expect(formatGamesBehind(1.5), "1½");
      expect(formatGamesBehind(2.5), "2½");
    });  
  });
  group('Winning magic number tests', () {
    test('Near season end Winning Magic Numbers', () {
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
    test('Near season beginning Winning Magic Numbers', () {
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
    test('New season Winning Magic Numbers', () {
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
    test('End of season Winning Magic Numbers', () {
      var standings = getEndOfSeasonStandings();
      calculateMagicNumbers(standings);
      for(int i = 0; i < standings.length; i++){
        print("${standings[i]} ${standings[i].winning}");
        for (int j = 0; j < 5; j++){
          if (i >= 4 && j == 4){
            expect(standings[i].winning[j], "PT");
            
          }

          if (i >= 4 && j < 4){
            expect(standings[i].winning[j], "X");
          }
          if (i < 4 && j == 4){
            expect(standings[i].winning[j], "X");
          }
        }
      }
    });      
    
  });  
  group('Party Time magic number tests', () {
    test('Near season end Party Time Magic Numbers', () {
      var standings = getLateSeasonStandings();
      calculateMagicNumbers(standings);
      
      for(int i = 0; i < 2; i++){
        print("${standings[i]} ${standings[i].partytime}");
        expect(standings[i].partytime[4], "X");
      }
        
      print("${standings[0]} ${standings[0].partytime}");
      expect(standings[0].partytime[0], "^");
      expect(standings[0].partytime[1], "X");
      expect(standings[0].partytime[2], "X");
      expect(standings[0].partytime[3], "X");
      
      
      print("${standings[1]} ${standings[1].partytime}");
      expect(standings[1].partytime[0], "X");
      //expect(standings[1].partytime[1], "9");
      //expect(standings[1].partytime[2], "3"));
      expect(standings[1].partytime[3], "^");
      
      print("${standings[2]} ${standings[2].partytime}");
      expect(standings[2].partytime[0], "X");
      //expect(standings[2].partytime[1], "DNCD");
      //expect(standings[2].partytime[2], "4");
      //expect(standings[2].partytime[3], "1");      

      print("${standings[3]} ${standings[3].partytime}");
      expect(standings[3].partytime[0], "X");
      //expect(standings[3].partytime[1], "DNCD");
      //expect(standings[3].partytime[2], "DNCD");
      //expect(standings[3].partytime[3], "6");   
      
      print("${standings[4]} ${standings[4].partytime}");
      expect(standings[4].partytime[0], "X");
      expect(standings[4].partytime[1], "X");
      //expect(standings[4].partytime[2], "DNCD");
      //expect(standings[4].partytime[3], "DNCD");  

      print("${standings[5]} ${standings[5].partytime}");
      expect(standings[5].partytime[0], "X");
      expect(standings[5].partytime[1], "X");
      expect(standings[5].partytime[2], "X");
      //expect(standings[5].partytime[3], "DNCD");  
      
      for (int i = 6; i < standings.length; i++){
        print("${standings[i]} ${standings[i].partytime}");
        expect(standings[i].partytime[0], "X");
        expect(standings[i].partytime[1], "X");
        expect(standings[i].partytime[2], "X");
        expect(standings[i].partytime[3], "X"); 
        expect(standings[i].partytime[4], "PT");
      }
    });  
    test('Near season beginning Party Time Magic Numbers', () {
      var standings = getEarlySeasonStandings();
      calculateMagicNumbers(standings);
      
      
      for(int i = 0; i < 10; i++){
        //print("${standings[i]} ${standings[i].partytime}");
        //expect(standings[i].partytime[4], "MW");
      }
        
      print("${standings[0]} ${standings[0].partytime}");
      //expect(standings[0].partytime[0], "63");
      //expect(standings[0].partytime[1], "59");
      //expect(standings[0].partytime[2], "56");
      //expect(standings[0].partytime[3], "53");
      
      
      print("${standings[1]} ${standings[1].partytime}");
      //expect(standings[1].partytime[0], "DNCD");
      //expect(standings[1].partytime[1], "62");
      //expect(standings[1].partytime[2], "59");
      //expect(standings[1].partytime[3], "56");
      
      print("${standings[2]} ${standings[2].partytime}");
      //expect(standings[2].partytime[0], "DNCD");
      //expect(standings[2].partytime[1], "DNCD");
      //expect(standings[2].partytime[2], "63");
      //expect(standings[2].partytime[3], "60");      

      print("${standings[3]} ${standings[3].partytime}");
      //expect(standings[3].partytime[0], "DNCD");
      //expect(standings[3].partytime[1], "DNCD");
      //expect(standings[3].partytime[2], "DNCD");
      //expect(standings[3].partytime[3], "62");   
      
      for (int i = 4; i < standings.length; i++){
        print("${standings[i]} ${standings[i].partytime}");
        //expect(standings[i].partytime[0], "DNCD");
        //expect(standings[i].partytime[1], "DNCD");
        //expect(standings[i].partytime[2], "DNCD");
        //expect(standings[i].partytime[3], "DNCD"); 
      }
    });  
    test('New season Party Time Magic Numbers', () {
      var standings = getNewSeasonStandings();
      calculateMagicNumbers(standings);
      
      for(int i = 0; i < 4; i++){
        print("${standings[i]} ${standings[i].partytime}");
        //expect(standings[i].partytime[4], "MW");
      }
      
      for (int i = 4; i < standings.length; i++){
        print("${standings[i]} ${standings[i].partytime}");
        //expect(standings[i].partytime[0], "-");
        //expect(standings[i].partytime[1], "-");
        //expect(standings[i].partytime[2], "-");
        //expect(standings[i].partytime[3], "-"); 
        //expect(standings[i].partytime[4], "MW");
      }
    });    
    test('End of season Party Time Magic Numbers', () {
      var standings = getEndOfSeasonStandings();
      calculateMagicNumbers(standings);
      
      for(int i = 0; i < standings.length; i++){
        print("${standings[i]} ${standings[i].partytime}");
        for (int j = 0; j < 5; j++){
          if (i >= 4 && j == 4){
            expect(standings[i].partytime[j], "PT");
            
          }
          if (i < 4 && j < 4){
            if (i != j){
              expect(standings[i].partytime[j], "X");
            } else {
              expect(standings[i].partytime[j], "^");
            }
          }
          if (i >= 4 && j < 4){
            expect(standings[i].partytime[j], "X");
          }
          if (i < 4 && j == 4){
            expect(standings[i].partytime[j], "X");
          }
        }
      }
    });      
    
  });  

}

List<TeamStandings> getEarlySeasonStandings(){
  List<TeamStandings> teamStandings = new List<TeamStandings>();
  for(int i = 0; i < standingsData.length; i++){
    teamStandings.add(new TeamStandings(
      i.toString(),
      standingsData[i][0],
      standingsData[i][1],
      i * 3,
      34 - (i * 3),
      standingsData[i][2],
    ));
  }
  
  sortTeamsNotGrouped(teamStandings);
  return teamStandings;
}

List<TeamStandings> getLateSeasonStandings(){
  List<TeamStandings> teamStandings = new List<TeamStandings>();
  for(int i = 0; i < standingsData.length; i++){
    teamStandings.add(new TeamStandings(
      i.toString(),
      standingsData[i][0],
      standingsData[i][1],
      standingsData[i][3],
      standingsData[i][4],
      standingsData[i][2],
    ));
  }
  
  return teamStandings;
}

List<TeamStandings> getNewSeasonStandings(){
  List<TeamStandings> teamStandings = new List<TeamStandings>();
  for(int i = 0; i < standingsData.length; i++){
    teamStandings.add(new TeamStandings(
      i.toString(),
      standingsData[i][0],
      standingsData[i][1],
      0,
      0,
      standingsData[i][2],
    ));
  }
  
  sortTeamsNotGrouped(teamStandings);
  return teamStandings;
  
}

List<TeamStandings> getEndOfSeasonStandings(){
  List<TeamStandings> teamStandings = new List<TeamStandings>();
  for(int i = 0; i < standingsData.length; i++){
    teamStandings.add(new TeamStandings(
      i.toString(),
      standingsData[i][0],
      standingsData[i][1],
      99 - i,
      i,
      standingsData[i][2],
    ));
  }
  
  sortTeamsNotGrouped(teamStandings);
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


