import 'dart:convert';
import 'package:intl/intl.dart';
import 'database_api.dart';

SiteData sitedata;
List<TeamStandings> sub1Standings;
List<TeamStandings> sub2Standings;

List<Team> _allTeams;
Tiebreakers _tiebreakers;
List<String> _dayOfWeek = ["", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
List<String> _monthOfYear = ["", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul",
  "Aug", "Sep", "Oct", "Nov", "Dec"];

Future<void> calcStats() async {
  print('Beginning stat calculations');
  
  League league = await getLeague();
  Subleague sub1 = await getSubleague(league.subleagueId1);
  Subleague sub2 = await getSubleague(league.subleagueId2);
  
  _allTeams = await getTeams();
  _tiebreakers = await getTiebreakers(league.tiebreakersId);

  sub1Standings = await calculateSubLeague(sub1);
  sub2Standings = await calculateSubLeague(sub2);
    
  var now = new DateTime.now();
  var f = new NumberFormat("#", "en_US");
  f.minimumIntegerDigits = 2;
  String lastUpdate = "${_dayOfWeek[now.weekday]} " + 
    "${_monthOfYear[now.month]} " +
    "${now.day} ${f.format(now.hour)}${f.format(now.minute)}";
  sitedata = new SiteData(lastUpdate, sub1.id, 
    sub1.name, sub2.id, sub2.name);
  print(sitedata);
}

Future<List<TeamStandings>> calculateSubLeague(Subleague sub) async{
  print("Calculating status for $sub");
  Division div1 = await getDivision(sub.divisionId1);
  Division div2 = await getDivision(sub.divisionId2);
  List<Team> teams = _allTeams.where((t) => 
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
  
  //compute games back from league leader
  int leagueLeaderDiff = teamStandings[0].wins - 
    teamStandings[0].losses;
  
  
  
  return teamStandings;

}


void sortTeamsNotGrouped(List<Team> teams) {
  teams.sort((a, b) {
    if(b.wins != a.wins)
      return b.wins.compareTo(a.wins);
    else 
      return _tiebreakers.order.indexOf(a.id)
        .compareTo(_tiebreakers.order.indexOf(b.id));
  });
}

class TeamStandings {
  final String id;
  final String nickname;
  String subleague;
  String division;
  final wins;
  final losses;
  
  final String gbLg = '-';
  final String gbPo = '-';
  final List<String> po = ['-', '-', '-', '-', '-'];
  
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