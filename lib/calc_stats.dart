import 'dart:convert';
import 'package:intl/intl.dart';
import 'database_api.dart';

League _league;
Subleague _sub1;
Subleague _sub2;

List<List<TeamStandings>> subStandings;

List<Team> _allTeams;
SimulationData _simData;
Season _season;
Standings _standings;
Tiebreakers _tiebreakers;
List<String> _dayOfWeek = ["", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
List<String> _monthOfYear = ["", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul",
  "Aug", "Sep", "Oct", "Nov", "Dec"];

NumberFormat f = new NumberFormat("#", "en_US");
  
Future<SiteData> calcSiteData(SimulationData simData) async {
  _league = await getLeague();
  _sub1 = await getSubleague(_league.subleagueId1);
  _sub2 = await getSubleague(_league.subleagueId2);
  
  String lastUpdate = getUpdateTime();
  
  SiteData sitedata = new SiteData(lastUpdate, 
    simData.season, simData.day,
    _sub1.id, _sub1.name, 
    _sub2.id, _sub2.name);
  print(sitedata);

  return sitedata;
}  

String getUpdateTime(){
  var now = new DateTime.now();
  f.minimumIntegerDigits = 2;
  return "${_dayOfWeek[now.weekday]} " + 
    "${_monthOfYear[now.month]} " +
    "${now.day} ${f.format(now.hour)}${f.format(now.minute)}";
}

Future<void> calcStats(SimulationData simData) async {
  print('Beginning stat calculations for season: ${simData.season + 1}');
  _season = await getSeason(simData.season);
  
  List<Game> games;
  if (simData.day < 99){
    games = await getGames(simData.season, simData.day);
  } else {
    games = await getGames(simData.season, 98);
  }
  _standings = await getStandings(_season.standings);

  _allTeams = await getTeams();
  _tiebreakers = await getTiebreakers(_league.tiebreakersId);

  List<TeamStandings> sub1Standings = 
    await calculateSubLeague(_sub1, games);
  List<TeamStandings> sub2Standings = 
    await calculateSubLeague(_sub2, games);
  
  subStandings = [sub1Standings, sub2Standings];
    
}

Future<List<TeamStandings>> calculateSubLeague(Subleague sub, List<Game> games) async{
  int day = games[0].day;
  print("Day ${day + 1} $sub");
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
    
    int gamesPlayed = 99;
    if (day < 99){
      //regular season
      Game todayGame = games.firstWhere((g) =>
        g.awayTeam == team.id || g.homeTeam == team.id);
      gamesPlayed = todayGame.gameComplete ?
        day + 1 : day;
    }
    
    TeamStandings standing = 
      new TeamStandings(team.id, team.nickname, divName,
      _standings.wins[team.id], 
      _standings.losses[team.id],
      gamesPlayed,
      _tiebreakers.order.indexOf(team.id));
    teamStandings.add(standing);
  });

  //sort first then calculate
  sortTeamsNotGrouped(teamStandings);
  reSortDivLeader(teamStandings);

  calculateGamesBehind(teamStandings);
  calculateMagicNumbers(teamStandings);
  
  return teamStandings;

}

void reSortDivLeader(List<TeamStandings> teamStandings){
  //if the first four teams are the same division, move
  //the other div leader into 4th
  String firstDiv = teamStandings.first.division;
  if(teamStandings.take(4).every((team) =>
    team.division == firstDiv) ||
    teamStandings.take(4).every((team) =>
    team.division != firstDiv)){
    print("Top four teams are the same division");
    //find top of other division
    TeamStandings otherLeader = teamStandings.firstWhere((team) =>
      team.division != firstDiv);
    print("Moving $otherLeader");
    teamStandings.remove(otherLeader);
    teamStandings.insert(3, otherLeader);
  }
    
}

void calculateGamesBehind(List<TeamStandings> teamStandings) {
  //compute games back from Division leaders and Wild Card spot
  Map<String, List<int>> divLeaders = new Map<String, List<int>>();
  String firstDiv = teamStandings[0].division;
  divLeaders[firstDiv] = [
    teamStandings[0].wins - 
      (teamStandings[0].gamesPlayed - teamStandings[0].wins),
    teamStandings[0].favor];
    
  TeamStandings secondDivLeader = teamStandings.firstWhere((team) =>
    team.division != firstDiv);
  divLeaders[secondDivLeader.division] = [
    secondDivLeader.wins - 
      (secondDivLeader.gamesPlayed - secondDivLeader.wins),
    secondDivLeader.favor];

  Map<String, List<int>> wcLeaders = new Map<String, List<int>>();
  //calculate the wild card leader for each division
  //if the top three teams are all the same division, then each
  //division will have a different WC team to beat
  if(teamStandings.take(3).every((team) => 
    team.division == firstDiv)){
    // high, high, high, low
    wcLeaders[firstDiv] = [
      teamStandings[2].wins - 
        (teamStandings[2].gamesPlayed - teamStandings[2].wins),
      teamStandings[2].favor];
    wcLeaders[secondDivLeader.division] = [
      secondDivLeader.wins - 
        (secondDivLeader.gamesPlayed - secondDivLeader.wins),
      secondDivLeader.favor];
  } else {
    //both teams have the same Wild Card leader, 4th place
    // high, low, high, low, etc..
    wcLeaders[firstDiv] = [
      teamStandings[3].wins - 
        (teamStandings[3].gamesPlayed - teamStandings[3].wins),
      teamStandings[3].favor];
    wcLeaders[secondDivLeader.division] = [
      teamStandings[3].wins - 
        (teamStandings[3].gamesPlayed - teamStandings[3].wins),
      teamStandings[3].favor];
  }
  
  for (int i = 1; i < teamStandings.length; i++){
    if(teamStandings[i] != secondDivLeader){
      int teamDiff = teamStandings[i].wins - 
        (teamStandings[i].gamesPlayed - teamStandings[i].wins);
      List divLeader = divLeaders[teamStandings[i].division];
      num gbDiv = ( divLeader[0] - teamDiff ) / 2;
      if (divLeader[1] < teamStandings[i].favor){
        gbDiv += 1;
      }
      teamStandings[i].gbDiv = formatGamesBehind(gbDiv);
      
      if(i > 3) {
        List wcLeader = wcLeaders[teamStandings[i].division];
        num gbWc = ( wcLeader[0] - teamDiff ) / 2;
        if (wcLeader[1] < teamStandings[i].favor){
          gbWc += 1;
        }
        teamStandings[i].gbWc = formatGamesBehind(gbWc);
      }
      
      //print("GbDiv ${teamStandings[i].gbDiv} GbWc ${teamStandings[i].gbWc}");

    }
  }  
}

void calculateMagicNumbers(List<TeamStandings> teamStandings){
  _calculateWinningMagicNumbers(teamStandings);
  _calculatePartyTimeMagicNumbers(teamStandings);
}

void _calculateWinningMagicNumbers(List<TeamStandings> teamStandings) {
  String firstDiv = teamStandings[0].division;
  String secondDiv = teamStandings.firstWhere((team) =>
    team.division != firstDiv).division;
  bool top3Same = teamStandings.take(3).every((team) =>
    team.division == firstDiv);
  for (int i = 0; i < teamStandings.length; i++){
    int maxWins = (99 - teamStandings[i].gamesPlayed) +
      teamStandings[i].wins;

    //print("${teamStandings[i]} maxWins: $maxWins");
    for (int j = 0; j < i && j < 4; j++){
      teamStandings[i].winning[j] = "DNCD";
      if( maxWins < teamStandings[j].wins ||
        (maxWins == teamStandings[j].wins &&
        teamStandings[i].favor > teamStandings[j].favor)){
        teamStandings[i].winning[j] = "X";
      } else if (top3Same && j == 3 && 
        teamStandings[i].winning[2] == "X" &&
        teamStandings[i].division == firstDiv){
        //if top3 are the same, and you can't make 3rd
        // and you aren't in secondDiv, you can't make 4th either
        teamStandings[i].winning[j] = "X";
      }
    }
    
    for (int b = i + 1; b < 5; b++){
      if (!top3Same || b < 3){
        setWinningMagicNumber(teamStandings[i], 
          teamStandings[b], b - 1);
      } else if (b == 3){
        //top3 are the same so the 3rd target is 
        //the 4th team in the top3 division
        TeamStandings target = teamStandings.where((team) =>
          team.division == firstDiv).take(4).last;
        setWinningMagicNumber(teamStandings[i], 
          target, b - 1);
      } else if (teamStandings[i].division == firstDiv) {
        //top3 are the same, so the 4th spot is taken by
        //other div leader and is not winnable
        teamStandings[i].winning[3] = "DNCD";
      } else {
        //top3 are the same, so the 4th spot of the 4th team
        //targets the 2nd team in its div
        TeamStandings target = teamStandings.where((team) =>
          team.division == secondDiv).take(2).last;
        setWinningMagicNumber(teamStandings[i], 
          target, b - 1);  
      }
    }
        
    if(teamStandings[i].winning.any((s) => s == "^")){
      teamStandings[i].winning[4] = "X";
    } else {
      teamStandings[i].winning[4] = "0";
    }
    
    if(teamStandings[i].winning[0] == "X" &&
      teamStandings[i].winning[1] == "X" &&
      teamStandings[i].winning[2] == "X" &&
      teamStandings[i].winning[3] == "X"){
      teamStandings[i].winning[4] = "PT";
    }
    
  }
}

void setWinningMagicNumber(TeamStandings standing, TeamStandings target,
  int winningIndex){
  //Wb + GRb - Wa + 1
  int magic = target.wins +
    (99 - target.gamesPlayed) -
    standing.wins;
  if (standing.favor > target.favor) {
    //team b wins ties
    magic += 1;
  }
  //print("WinMN for ${teamStandings[i]} vs. ${teamStandings[b]}: $magic");
  if (magic > 0){
    //set magic number
    standing.winning[winningIndex] = "$magic";
  } else if (winningIndex > 0 && 
    standing.winning.any((s) => s == "^")) {
    //previous spot guaranteed, so this one can't
    standing.winning[winningIndex] = "X";
  } else {
    //this spot or better guaranteed
    standing.winning[winningIndex] = "^";
  }
    
}

void _calculatePartyTimeMagicNumbers(List<TeamStandings> teamStandings) {
  String firstDiv = teamStandings[0].division;
  String secondDiv = teamStandings.firstWhere((team) =>
    team.division != firstDiv).division;
  bool top3Same = teamStandings.take(3).every((team) =>
    team.division == firstDiv);
    
  for (int i = 0; i < teamStandings.length; i++){
    var stand = teamStandings[i];
    int maxWins = (99 - stand.gamesPlayed) + stand.wins;
    for(int k = 0; k < 5; k++){
      switch(stand.winning[k]){
        case '^':
        case 'X':
        case 'PT':
          stand.partytime[k] = stand.winning[k];
          break;
        default:
          if(i <= k) {
            stand.partytime[k] = "MW";
          } else if (k == 4) {
            stand.partytime[k] = "MW";
          } else if (top3Same && k == 3 && 
            stand.division == firstDiv) {
            //party time losses for 4th are the same as 3rd
            
            stand.partytime[k] = stand.partytime[k - 1];
            //print("Adjust for top 3 same ${stand.partytime[k]} ${stand.partytime[k - 1]}");
          } else {
            //maxWinsi - Wk
            //print("Find Elim: $stand Berth: $k");
            int magic = maxWins - teamStandings[k].wins;
            //if we don't have favor, elim is one lower
            if(stand.favor < teamStandings[k].favor) {
              magic += 1;
            }
            stand.partytime[k] = "$magic";
          }
          
          break;
      } 
    }
  }
}

//sort teams by wins, divine favor
void sortTeamsNotGrouped(List<TeamStandings> teams) {
  teams.sort((a, b) {
    if(b.wins != a.wins){
      return b.wins.compareTo(a.wins);
    } else {
      return a.favor.compareTo(b.favor);
    }
  });
}

String formatGamesBehind(num gb){
  if(gb == gb.toInt()){
    return gb.toInt().toString();
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
  final int wins;
  final int losses;
  final int gamesPlayed;
  final int favor;
  
  String gbDiv = '-';
  String gbWc = '-';
  final List<String> po = ['-', '-', '-', '-', '-'];
  final List<String> winning = ['-', '-', '-', '-', '-'];
  final List<String> partytime = ['-', '-', '-', '-', '-'];
  
  TeamStandings(this.id, this.nickname, this.division,
    this.wins, this.losses, this.gamesPlayed, this.favor);
    
  TeamStandings.fromMap({this.id, 
    this.nickname, this.division,
    this.wins, this.losses,
    this.gamesPlayed, this.favor,
    this.gbDiv, this.gbWc,
    po, winning, partytime}){
    for(int i = 0; i < 5; i++){
      this.po[i] = po[i].toString();
      this.winning[i] = winning[i].toString();
      this.partytime[i] = partytime[i].toString();
    }
  }
    
    
  factory TeamStandings.fromJson(Map<String, dynamic> json){
    return TeamStandings.fromMap(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      division: json['division'] as String,
      wins: json['wins'] as int,
      losses: json['losses'] as int,
      gamesPlayed: json['gamesPlayed'] as int,
      favor: json['favor'] as int,
      gbDiv: json['gbDiv'] as String,
      gbWc: json['gbWc'] as String,
      po: json['po'] as List<dynamic>,
      winning: json['winning'] as List<dynamic>,
      partytime: json['partytime'] as List<dynamic>,
    );
  }
    
  Map toJson() => {
    'id': id,
    'nickname': nickname,
    'division': division,
    'wins': wins,
    'losses': losses,
    'gamesPlayed': gamesPlayed,
    'favor': favor,
    'gbDiv': gbDiv,
    'gbWc': gbWc,
    'po': po,
    'winning': winning,
    'partytime': partytime,
  };
  
  @override
  String toString() => "Standings: $nickname - $division ($wins - $losses) #$favor";
  
}
