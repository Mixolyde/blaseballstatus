import 'dart:convert';
import 'package:intl/intl.dart';
import 'database_api.dart';

League _league;
Subleague _sub1;
Subleague _sub2;

List<TeamStandings> sub1Standings;
List<TeamStandings> sub2Standings;

List<Team> _allTeams;
Season _season;
Standings _standings;
Tiebreakers _tiebreakers;
List<String> _dayOfWeek = ["", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
List<String> _monthOfYear = ["", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul",
  "Aug", "Sep", "Oct", "Nov", "Dec"];

Future<SiteData> calcSiteData() async {
  
  _league = await getLeague();
  _sub1 = await getSubleague(_league.subleagueId1);
  _sub2 = await getSubleague(_league.subleagueId2);
  
  var now = new DateTime.now();
  var f = new NumberFormat("#", "en_US");
  f.minimumIntegerDigits = 2;
  String lastUpdate = "${_dayOfWeek[now.weekday]} " + 
    "${_monthOfYear[now.month]} " +
    "${now.day} ${f.format(now.hour)}${f.format(now.minute)}";
  SiteData sitedata = new SiteData(lastUpdate, 
    _sub1.id, _sub1.name, 
    _sub2.id, _sub2.name);
  print(sitedata);

  return sitedata;
}  

Future<void> calcStats(int season) async {
  print('Beginning stat calculations');
  _season = await getSeason(season);
  _standings = await getStandings(_season.standings);

  _allTeams = await getTeams();
  _tiebreakers = await getTiebreakers(_league.tiebreakersId);

  sub1Standings = await calculateSubLeague(_sub1);
  sub2Standings = await calculateSubLeague(_sub2);
    
}

Future<List<TeamStandings>> calculateSubLeague(Subleague sub) async{
  print("Calculating status for $sub");
  Division div1 = await getDivision(sub.divisionId1);
  Division div2 = await getDivision(sub.divisionId2);
  List<Team> teams = _allTeams.where((t) => 
    div1.teams.contains(t.id) ||
    div2.teams.contains(t.id)).toList();

  
  List<TeamStandings> teamStandings = new List<TeamStandings>();
  teams.forEach((team){
    String divName;
    if(div1.teams.contains(team.id)){
      divName = div1.name.split(' ')[1];
    } else {
      divName = div2.name.split(' ')[1];
    }
    
    TeamStandings standing = 
    new TeamStandings(team.id, team.nickname, divName,
      _standings.wins[team.id], 
      _standings.losses[team.id],
      _tiebreakers.order.indexOf(team.id));
    teamStandings.add(standing);
  });

  //sort first then calculate
  sortTeamsNotGrouped(teamStandings);

  calculateGamesBehind(teamStandings);
  calculateWinningMagicNumbers(teamStandings);
  
  return teamStandings;

}

void calculateGamesBehind(List<TeamStandings> teamStandings) {
  //compute games back from league leader
  int leagueLeaderDiff = teamStandings[0].wins - 
    teamStandings[0].losses;
  int leagueLeaderOrder = _tiebreakers.order
    .indexOf(teamStandings[0].id);
  int lastPlayoffDiff = teamStandings[3].wins - 
    teamStandings[3].losses;  
  int lastPlayoffOrder = _tiebreakers.order
    .indexOf(teamStandings[3].id);
    
  for (int i = 1; i < teamStandings.length; i++){
    int teamDiff = teamStandings[i].wins - 
    teamStandings[i].losses;
    num gbLg = ( leagueLeaderDiff - teamDiff ) / 2;
    if (leagueLeaderOrder < _tiebreakers.order
      .indexOf(teamStandings[i].id)){
      gbLg += 1;
    }
    teamStandings[i].gbLg = formatGamesBehind(gbLg);
    
    if(i > 3) {
      num gbPo = ( lastPlayoffDiff - teamDiff ) / 2;
      if (lastPlayoffOrder < _tiebreakers.order
        .indexOf(teamStandings[i].id)){
        gbPo += 1;
      }
      teamStandings[i].gbPo = formatGamesBehind(gbPo);
    }
  }  
}

void calculateWinningMagicNumbers(List<TeamStandings> teamStandings) {
  for (int i = 0; i < teamStandings.length; i++){
    for (int j = 0; j < i && j < 4; j++){
      teamStandings[i].winning[j] = "DNCD";
    }
    for (int k = i; k < 4; k++){
      //Wb + GRb - Wa + 1
      int b = i + k + 1;
      int magic = teamStandings[b].wins +
        (99 - (teamStandings[b].wins + teamStandings[b].losses)) -
        teamStandings[i].wins;
      if (teamStandings[i].favor > teamStandings[b].favor) {
        //team b wins ties
        magic += 1;
      }
      teamStandings[i].winning[k] = "$magic";
      
    }
    
    teamStandings[i].winning[4] = "0";
    
  }
  
}

//sort teams by wins, losses, divine favor
void sortTeamsNotGrouped(List<TeamStandings> teams) {
  teams.sort((a, b) {
    if(b.wins != a.wins){
      return b.wins.compareTo(a.wins);
    } else if (b.losses != a.losses){
      return a.losses.compareTo(b.losses);
    } else {
      return _tiebreakers.order.indexOf(a.id)
        .compareTo(_tiebreakers.order.indexOf(b.id));
    }
  });
}

String formatGamesBehind(num gb){
  if(gb == gb.toInt()){
    return gb.toString();
  } else if (gb < 1 ) {
    return "½";
  } else {
    return "${gb.toInt()}½";
  }
}

class TeamStandings {
  final String id;
  final String nickname;
  final String division;
  final wins;
  final losses;
  final int favor;
  
  String gbLg = '-';
  String gbPo = '-';
  final List<String> po = ['-', '-', '-', '-', '-'];
  final List<String> winning = ['-', '-', '-', '-', '-'];
  final List<String> losing = ['-', '-', '-', '-', '-'];
  
  TeamStandings(this.id, this.nickname, this.division,
    this.wins, this.losses, this.favor);
    
  Map toJson() => {
    'nickname': nickname,
    'division': division,
    'wins': wins,
    'losses': losses,
    'favor': favor,
    'gbLg': '-',
    'gbPo': '-',
  };
  
  @override
  String toString() => "Standings: $nickname ($wins - $losses)";
  
}