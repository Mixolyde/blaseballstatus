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
  group('math tests', () {
    test('Winning Magic Numbers', () {
      var standings = getTestTeamStandings();
      calculateWinningMagicNumbers(standings);
      
      standings.forEach((s) => 
        expect(s.winning[4], "0"));
        
      print("${standings[0]} ${standings[0].winning}");
      expect(standings[0].winning[0], "^");
      expect(standings[0].winning[1], "^");
      expect(standings[0].winning[2], "^");
      expect(standings[0].winning[3], "^");
      
      print("${standings[1]} ${standings[1].winning}");
      //expect(standings[1].winning[0], "X");
      expect(standings[1].winning[1], 
        (53 + 10 - 55 + 1).toString());
      expect(standings[1].winning[2], 
        (48 + 9 - 55 + 1).toString());
      expect(standings[1].winning[3], "^");
      
      print("${standings[2]} ${standings[2].winning}");
      //expect(standings[2].winning[0], "X");
      expect(standings[2].winning[1], "DNCD");
      expect(standings[2].winning[2], "4");
      expect(standings[2].winning[3], "^");      

      print("${standings[3]} ${standings[3].winning}");
      //expect(standings[3].winning[0], "X");
      expect(standings[3].winning[1], "DNCD");
      expect(standings[3].winning[2], "DNCD");
      expect(standings[3].winning[3], "6");   
      
      print("${standings[4]} ${standings[4].winning}");
      //expect(standings[4].winning[0], "X");
      //expect(standings[4].winning[1], "X");
      //expect(standings[4].winning[2], "X");
      expect(standings[4].winning[3], "DNCD");       

    });  
  });  

}

List<TeamStandings> getTestTeamStandings(){
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

List<List<dynamic>> standingsData = [
["Crabs",        "High", 18, 66, 24],
["Spies",         "Low", 20, 55, 35],
["Sunbeams",      "Low", 10, 53, 36],
["Flowers",       "Low", 14, 48, 42],
["Millenials",   "High", 12, 43, 46],
["Firefighters", "High", 17, 43, 47],
["Dale",          "Low", 11, 37, 53],
["Jazz Hands",   "High",  8, 36, 53],
["Lovers",       "High",  2, 35, 55],
["Tacos",         "Low",  1, 33, 56]];


