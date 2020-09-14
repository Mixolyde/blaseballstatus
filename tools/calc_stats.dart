import 'dart:convert';
import 'dart:io';
import '../lib/database_api.dart';

void main() async {
  print('Beginning stat calculations');
  
  League league = await getLeague();
  Subleague sub1 = await getSubleague(league.subleagueId1);
  Subleague sub2 = await getSubleague(league.subleagueId2);
  
  List<Team> teams = await getTeams();

  calculateSubLeague(sub1, teams);
  calculateSubLeague(sub2, teams);
    
  
}

void calculateSubLeague(Subleague sub, List<Team> allTeams) async{
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