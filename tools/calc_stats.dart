import 'dart:convert';
import 'dart:io';
import '../lib/database_api.dart';

List<Team> allTeams;
Tiebreakers tiebreakers;
List<String> dayOfWeek = ["", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
List<String> monthOfYear = ["", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul",
  "Aug", "Sep", "Oct", "Nov", "Dec"];

void main() async {
  print('Beginning stat calculations');
  
  League league = await getLeague();
  Subleague sub1 = await getSubleague(league.subleagueId1);
  Subleague sub2 = await getSubleague(league.subleagueId2);
  
  allTeams = await getTeams();
  tiebreakers = await getTiebreakers(league.tiebreakersId);

  calculateSubLeague(sub1);
  calculateSubLeague(sub2);
    

  print("Writing out site data info");
  var now = new DateTime.now();
  String lastUpdate = "${dayOfWeek[now.weekday]} ${monthOfYear[now.month]} " +
    "${now.day} ${now.hour}:${now.minute}";
  SiteData sitedata = new SiteData(lastUpdate, sub1, sub2);
  print(sitedata);
  
  final filenameJSON = 'web/sitedata.json';
  var sinkJSON = new File(filenameJSON).openWrite();
  sinkJSON.write(json.encode(sitedata));
  sinkJSON.close();
}

void calculateSubLeague(Subleague sub) async{
  print("Calculating status for $sub");
  Division div1 = await getDivision(sub.divisionId1);
  Division div2 = await getDivision(sub.divisionId2);
  List<Team> teams = allTeams.where((t) => 
    div1.teams.contains(t.id) ||
    div2.teams.contains(t.id)).toList();

  sortTeamsNotGrouped(teams);
  
  List<TeamStandings> teamStandings = new List<TeamStandings>();
  teams.forEach((team){
    TeamStandings standing = 
    new TeamStandings(team.id, team.nickname, team.wins, team.losses);
    if(div1.teams.contains(team.id)){
      standing.division = div1.name;
    } else {
      standing.division = div2.name;
    }
    teamStandings.add(standing);
  });

  final filenameJSON = 'web/${sub.id}.json';
  var sinkJSON = new File(filenameJSON).openWrite();
  sinkJSON.write(json.encode(teamStandings));
  sinkJSON.close();

}


void sortTeamsNotGrouped(List<Team> teams) {
  teams.sort((a, b) {
    if(b.wins != a.wins)
      return b.wins.compareTo(a.wins);
    else 
      return tiebreakers.order.indexOf(a.id)
        .compareTo(tiebreakers.order.indexOf(b.id));
  });
}

class SiteData {
  final String lastUpdate;
  final Subleague sub1;
  final Subleague sub2;

  List<List<String>> get subLists => 
    [[sub1.id, sub1.name], [sub2.id, sub2.name]];
  
  SiteData(this.lastUpdate, this.sub1, this.sub2);
  
  Map toJson() => {
      'lastUpdate': lastUpdate,
      'sub1': [sub1.id, sub1.name],
      'sub2': [sub2.id, sub2.name],
  };
  
  @override
  String toString() => "$lastUpdate $subLists";
}

class LeagueStandings {
  final String name;
  final List<TeamStandings> leagueStandings;
  
  LeagueStandings(this.name, this.leagueStandings);
  
  @override
  String toString() => "LeagueStandings: $name length: ${leagueStandings.length}";
}

class TeamStandings {
  final String id;
  final String nickname;
  String subleague;
  String division;
  final wins;
  final losses;
  
  TeamStandings(this.id, this.nickname, this.wins, this.losses);
    
  Map toJson() => {
    'nickname': nickname,
    'division': division,
    'wins': wins,
    'losses': losses,
    'gbLg': '-',
    'gbPo': '-',
    'po1': '-',
    'po2': '-',
    'po3': '-',
    'po4': '-',
    'po5': '-',
  };
  
  @override
  String toString() => "Standings: $nickname ($wins - $losses)";
  
}