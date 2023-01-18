import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'chronicler_api.dart';
import 'database_api.dart';
import 'site_objects.dart';

late League _league;
late Subleague _sub1;
late Subleague _sub2;
Map<String, String> divNicknames = {};

List<List<TeamStandings>> subStandings = [];

Map<String,List<Team>> _allTeams = {};
late Tiebreakers _tiebreakers;

List<String> _dayOfWeek = ['', 'Mon', 'Tue', 'Wed',
  'Thu', 'Fri', 'Sat', 'Sun'];
List<String> _monthOfYear = ['', 'Jan', 'Feb', 'Mar',
  'Apr', 'May', 'Jun', 'Jul',
  'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

NumberFormat f = NumberFormat('#', 'en_US');

int divSplit = 0;
int gamesInRegularSeason = 99;
  
Future<SiteData> calcSiteData(SimulationData simData) async {
  _league = await getLeague(deep:true);
  print(_league);
  _sub1 = _league.subleague1!;
  _sub2 = _league.subleague2!;
  divNicknames[_sub1.divisionId1] = _sub1.division1!.name.split(' ')[divSplit];
  divNicknames[_sub1.divisionId2] = _sub1.division2!.name.split(' ')[divSplit];
  divNicknames[_sub2.divisionId1] = _sub2.division1!.name.split(' ')[divSplit];
  divNicknames[_sub2.divisionId2] = _sub2.division2!.name.split(' ')[divSplit];
  
  gamesInRegularSeason = SimulationData.gamesInRegularSeason(simData.currentSeasonId);
  
  var lastUpdate = getUpdateTime();
  
  var sitedata = SiteData(lastUpdate, 
    simData.season, simData.day,
    _sub1.id, _sub1.name, 
    _sub2.id, _sub2.name,
    simData.attributes,
    SimulationData.daysInRegularSeason(simData.currentSeasonId),
    SimulationData.gamesInRegularSeason(simData.currentSeasonId));
  //print(sitedata);

  return sitedata;
}  

String getUpdateTime(){
  var now = DateTime.now();
  print("IsoString: ${now.toIso8601String()}");
  return now.toIso8601String();
}

Future<List<List<TeamStandings>>> calcStats(SimulationData simData) async {
  print('Beginning stat calculations for current season: ${simData.season + 1}');
 
  _allTeams = await 
    getTeamsByDivision(simData.currentSeasonId, simData.day);
    
  //_tiebreakers = await getTiebreakers(_league.tiebreakersId);
  _tiebreakers = getAlphaTiebreakers();

  var sub1Standings = 
    await calculateSubLeague(_sub1, simData);
  var sub2Standings = 
    await calculateSubLeague(_sub2, simData);
  
  return [sub1Standings, sub2Standings];
    
}

Future<List<TeamStandings>> calculateSubLeague(Subleague sub, 
    SimulationData simData) async{
  print('Day ${simData.day + 1} $sub');
  //var div1 = await getDivision(sub.divisionId1);
  //var div2 = await getDivision(sub.divisionId2);
  var teams = [];
  teams.addAll(_allTeams[sub.divisionId1]!);
  teams.addAll(_allTeams[sub.divisionId2]!);
  print("SubLeague Teams Length: {$teams.length}");

  
  var teamStandings = <TeamStandings>[];
  for (var team in teams) {

    var gamesPlayed = gamesInRegularSeason;
    if (!simData.inPostSeason){
      gamesPlayed = team.wins + team.losses;
    }
    
    var standing = 
      TeamStandings(team.id, 
      team.fullName, team.nickname, team.emoji,
      sub.name,
      divNicknames[team.divisionId]!,
      team.wins, 
      team.losses,
      gamesPlayed,
      _tiebreakers.order.indexOf(team.id));
    teamStandings.add(standing);
  }
  
  print("SubLeague TeamStandings Length: ${teamStandings.length}");

  //sort first then calculate
  sortTeamsNotGrouped(teamStandings);


  calculateGamesBehind(teamStandings);
  calculateMagicNumbers(teamStandings);
  
  return teamStandings;

}

void calculateGamesBehind(List<TeamStandings> teamStandings) {
  //compute games back from Division leaders and Wild Card spot
  var divLeaders = <String, List<int>>{};
  var firstDiv = teamStandings[0].division;
  divLeaders[firstDiv] = [
    teamStandings[0].wins - 
      (teamStandings[0].gamesPlayed - teamStandings[0].wins),
    teamStandings[0].favor];
    
  var secondDivLeader = teamStandings.firstWhere((team) =>
    team.division != firstDiv);
  divLeaders[secondDivLeader.division] = [
    secondDivLeader.wins - 
      (secondDivLeader.gamesPlayed - secondDivLeader.wins),
    secondDivLeader.favor];

  var wcLeaders = <String, List<int>>{};
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
  
  for (var i = 1; i < teamStandings.length; i++){
    if(teamStandings[i] != secondDivLeader){
      var teamDiff = teamStandings[i].wins - 
        (teamStandings[i].gamesPlayed - teamStandings[i].wins);
      var divLeader = divLeaders[teamStandings[i].division] ?? <int>[];
      num gbDiv = ( divLeader[0] - teamDiff ) / 2;
      if (divLeader[1] < teamStandings[i].favor){
        gbDiv += 1;
      }
      teamStandings[i].gbDiv = formatGamesBehind(gbDiv);
      
      if(i > 3) {
        var wcLeader = wcLeaders[teamStandings[i].division] ?? <int>[];
        num gbWc = ( wcLeader[0] - teamDiff ) / 2;
        if (wcLeader[1] < teamStandings[i].favor){
          gbWc += 1;
        }
        teamStandings[i].gbWc = formatGamesBehind(gbWc);
      }
      
      //print('GbDiv ${teamStandings[i].gbDiv} GbWc ${teamStandings[i].gbWc}');

    }
  }  
}

void calculateMagicNumbers(List<TeamStandings> teamStandings){
  calculateWinningMagicNumbers(teamStandings);
  _calculatePartyTimeMagicNumbers(teamStandings);
}

@visibleForTesting
void calculateWinningMagicNumbers(List<TeamStandings> teamStandings) {
  var firstDiv = teamStandings[0].division;
  var secondDiv = teamStandings.firstWhere((team) =>
    team.division != firstDiv).division;
  var top3Same = teamStandings.take(3).every((team) =>
    team.division == firstDiv);
  for (var i = 0; i < teamStandings.length; i++){
    var maxWins = (gamesInRegularSeason - teamStandings[i].gamesPlayed) +
      teamStandings[i].wins;

    print('${teamStandings[i]} maxWins: $maxWins');
    for (var j = 0; j < i && j < 4; j++){
      teamStandings[i].winning[j] = 'DNCD';
      if( maxWins < teamStandings[j].wins ||
        (maxWins == teamStandings[j].wins &&
        teamStandings[i].favor > teamStandings[j].favor)){
        teamStandings[i].winning[j] = 'X';
      } else if (top3Same && j == 3 && 
        teamStandings[i].winning[2] == 'X' &&
        teamStandings[i].division == firstDiv){
        //if top3 are the same, and you can't make 3rd
        // and you aren't in secondDiv, you can't make 4th either
        teamStandings[i].winning[j] = 'X';
      }
    }
    
    for (var b = i + 1; b < 5; b++){
      if (!top3Same || b < 3){
        setWinningMagicNumber(teamStandings[i], 
          teamStandings[b], b - 1);
      } else if (b == 3){
        //top3 are the same so the 3rd target is 
        //the 4th team in the top3 division
        var target = teamStandings.where((team) =>
          team.division == firstDiv).take(4).last;
        setWinningMagicNumber(teamStandings[i], 
          target, b - 1);
      } else if (teamStandings[i].division == firstDiv) {
        //top3 are the same, so the 4th spot is taken by
        //other div leader and is not winnable
        if(teamStandings[i].winning.any((s) => s == '^')){
          teamStandings[i].winning[3] = 'X';
        } else {
          teamStandings[i].winning[3] = 'DNCD';
        }
      } else {
        //top3 are the same, so the 4th spot of the 4th team
        //targets the 2nd team in its div
        var target = teamStandings.where((team) =>
          team.division == secondDiv).take(2).last;
        setWinningMagicNumber(teamStandings[i], 
          target, b - 1);  
      }
    }
        
    if(teamStandings[i].winning.any((s) => s == '^')){
      teamStandings[i].winning[4] = 'X';
    } else {
      teamStandings[i].winning[4] = '0';
    }
    
    if(teamStandings[i].winning[0] == 'X' &&
      teamStandings[i].winning[1] == 'X' &&
      teamStandings[i].winning[2] == 'X' &&
      teamStandings[i].winning[3] == 'X'){
      teamStandings[i].winning[4] = 'PT';
    }
    
  }
}

void setWinningMagicNumber(TeamStandings standing, TeamStandings target,
  int winningIndex){
  //Wb + GRb - Wa + 1
  var magic = target.wins +
    (gamesInRegularSeason - target.gamesPlayed) -
    standing.wins;
  if (standing.favor > target.favor) {
    //team b wins ties
    magic += 1;
  }
  //print('WinMN for ${teamStandings[i]} vs. ${teamStandings[b]}: $magic');
  if (magic > 0){
    //set magic number
    standing.winning[winningIndex] = '$magic';
  } else if (winningIndex > 0 && 
    standing.winning.any((s) => s == '^')) {
    //previous spot guaranteed, so this one can't
    standing.winning[winningIndex] = 'X';
  } else {
    //this spot or better guaranteed
    standing.winning[winningIndex] = '^';
  }
    
}

void _calculatePartyTimeMagicNumbers(List<TeamStandings> teamStandings) {
  var firstDiv = teamStandings[0].division;
  var top3Same = teamStandings.take(3).every((team) =>
    team.division == firstDiv);
    
  for (var i = 0; i < teamStandings.length; i++){
    var stand = teamStandings[i];
    var maxWins = (gamesInRegularSeason - stand.gamesPlayed) + stand.wins;
    for(var k = 0; k < 5; k++){
      switch(stand.winning[k]){
        case '^':
        case 'X':
        case 'PT':
          stand.partytime[k] = stand.winning[k];
          break;
        default:
          if(i <= k) {
            stand.partytime[k] = 'MW';
          } else if (k == 4) {
            stand.partytime[k] = 'MW';
          } else if (top3Same && k == 3 && 
            stand.division == firstDiv) {
            //party time losses for 4th are the same as 3rd
            
            stand.partytime[k] = stand.partytime[k - 1];
            //print('Adjust for top 3 same ${stand.partytime[k]} ${stand.partytime[k - 1]}');
          } else {
            //maxWinsi - Wk
            //print('Find Elim: $stand Berth: $k');
            var magic = maxWins - teamStandings[k].wins;
            //if we don't have favor, elim is one lower
            if(stand.favor < teamStandings[k].favor) {
              magic += 1;
            }
            stand.partytime[k] = '$magic';
          }
          
          break;
      } 
    }
  }
}

//sort teams by wins, divine favor, resort by division
void sortTeamsNotGrouped(List<TeamStandings> teams) {
  teams.sort((a, b) {
    if(b.wins != a.wins){
      return b.wins.compareTo(a.wins);
    } else {
      return a.favor.compareTo(b.favor);
    }
  });
  //if the first four teams are the same division, move
  //the other div leader into 4th
  var firstDiv = teams.first.division;
  if(teams.take(4).every((team) =>
    team.division == firstDiv) ||
    teams.take(4).every((team) =>
    team.division != firstDiv)){
    print('Top four teams are the same division: $firstDiv');
    //find top of other division
    var otherLeader = teams.firstWhere((team) =>
      team.division != firstDiv);
    print('Moving $otherLeader');
    teams.remove(otherLeader);
    teams.insert(3, otherLeader);
  }  
}

String formatGamesBehind(num gb){
  if(gb == gb.toInt()){
    return gb.toInt().toString();
  } else if (gb < 1 ) {
    return '½';
  } else {
    return '${gb.toInt()}½';
  }
}

Tiebreakers getAlphaTiebreakers(){
  String id = "AlphaTiebreakers";
  //expand each teamlist into a list of id strings and flatmap them
  List<String> teamIds = 
    _allTeams.values.expand<String>((teamList) => 
      teamList.map((team) => team.id)).toList();
  //print("TeamIds: $teamIds");
  teamIds.sort();
  return Tiebreakers(id: id, order: teamIds);
  
}
