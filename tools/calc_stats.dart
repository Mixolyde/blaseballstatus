import 'dart:convert';
import 'dart:io';
import '../lib/database_api.dart';

void main() async {
  print('Beginning stat calculations');
  
  List<Team> teams = await getTeams();
  sortTeamsNotGrouped(teams);
  print('Got team records');
  List<TeamStandings> teamStandings = new List<TeamStandings>();
  teams.forEach((team){
    TeamStandings standing = 
    new TeamStandings(team.id, team.nickname, team.wins, team.losses)
      ..division = 'High';
    teamStandings.add(standing);
  });

  final filenameJSON = 'web/wildstandings.json';
  var sinkJSON = new File(filenameJSON).openWrite();
  sinkJSON.write(json.encode(teamStandings));
  sinkJSON.close();
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