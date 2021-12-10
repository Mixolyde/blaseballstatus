import 'database_api.dart';
import 'site_objects.dart';
import 'sim_season.dart';

PlayoffMatchup locateMatchup(CompletePostseason postSeason, PlayoffRound round,
  List<TeamStandings> subStandings, {int? seed} ){
  print('Searching for matchup with seed: $seed');
  if(seed != null){
    return postSeason.playoffMatchups.values.firstWhere(
      (matchup) => round.matchupIDs.contains(matchup.id) &&
      matchup.homeSeed == seed && 
      subStandings.any((standing) => standing.id == matchup.awayTeam)
    );
  } else {
    return postSeason.playoffMatchups.values.firstWhere(
      (matchup) => round.matchupIDs.contains(matchup.id) &&
      subStandings.any((standing) => standing.id == matchup.awayTeam)
    );
    
  }
}

void setCompletedPostSeasonStandings(List<List<TeamStandings>> standings, 
  CompletePostseason currentPostSeason){
  var allStandings = <TeamStandings>[];
  allStandings.addAll(standings[0]);
  allStandings.addAll(standings[1]);
  var leagueWildCards = (currentPostSeason.playoffs.numberOfRounds == 4);
  print("Setting completed PostSeason Standing data");
  var teamsInPlayoffs = <String>[];
  for(var matchup in currentPostSeason.playoffMatchups.values) {
    if(matchup.awayTeam !=null && !teamsInPlayoffs.contains(matchup.awayTeam)){
      teamsInPlayoffs.add(matchup.awayTeam!);
    }
    if(matchup.homeTeam !=null && !teamsInPlayoffs.contains(matchup.homeTeam)){
      teamsInPlayoffs.add(matchup.homeTeam!);
    } 
  }

  print("Teams in playoffs: $teamsInPlayoffs");
  //for all teams not in a matchup
  for(var standingList in standings){
    for(var standing in standingList){
      if(leagueWildCards){
        if(teamsInPlayoffs.contains(standing.id)){
          // all teams in playoffs make the wild card round
          standing.post[4] = '^';
        } else {
          // teams not in playoffs didn't make the wild card round
          standing.post[4] = 'X';
        }
      } else {
        //if no wild card round, X it out
        standing.post[4] = 'X';
      }
      if(!teamsInPlayoffs.contains(standing.id)){
        //team is not in any matchups at all
        print("${standing.id} is not in playoffs, X out all post spots");
        for(var i = 0; i < 5; i++){
          standing.post[i] = 'X';
        }
      } 
    }
  }
  
  var currentRound = currentPostSeason.playoffs.round;
  var completedRoundCount = 0;
  if(currentPostSeason.playoffs.currentRoundComplete){
    completedRoundCount = currentPostSeason.playoffs.round + 1;
  } else {
    completedRoundCount = currentPostSeason.playoffs.round;
  }
  
  if(completedRoundCount > 0){
    print("$completedRoundCount rounds have been completed.");
    var teamsInRound = <String>[];    
    for(int completedRound = 0; completedRound < completedRoundCount; completedRound++){
      teamsInRound.clear();
      var postIndex = currentPostSeason.playoffs.numberOfRounds - completedRound;

      var playoffRound = currentPostSeason.playoffRounds.values.firstWhere(
        (r) => r.roundNumber == completedRound);
      for(var matchupId in playoffRound.matchupIDs){
        var matchup = currentPostSeason.playoffMatchups[matchupId]!;
        if(matchup.homeTeam != null){
          teamsInRound.add(matchup.homeTeam!);
          var standing = allStandings.firstWhere((s) => s.id == matchup.homeTeam);
          standing.post[postIndex] = '^';          
        }
        
        if(matchup.awayTeam != null){
          teamsInRound.add(matchup.awayTeam!);
          var standing = allStandings.firstWhere((s) => s.id == matchup.awayTeam);
          standing.post[postIndex] = '^';
        }
      }

      
      for(var team in teamsInPlayoffs){
        if(!teamsInRound.contains(team)){
          print("$team eliminated in Round $completedRound");
          var standing = allStandings.firstWhere((s) => s.id == team);
          standing.post[postIndex] = 'X';
        }
      }
    }
    
    if(completedRoundCount == currentPostSeason.playoffs.numberOfRounds){
      print("PostSeason completed, mark winner");
      var playoffRound = currentPostSeason.playoffRounds.values.firstWhere(
        (r) => r.roundNumber == currentPostSeason.playoffs.numberOfRounds - 1);
      print("Get winner of round $playoffRound");
      var winningTeam = playoffRound.winnerIDs[0];
      for(var standing in allStandings){
        if(standing.id == winningTeam){
          standing.post[0] = '^';
        } else {
          standing.post[0] = 'X';
        }
      }

    }
    
  }
  
  
    
}

void simulateStartedPostSeason(List<List<TeamSim>> simsByLeague, 
  CompletePostseason postSeason) {

  int teamCount = simsByLeague.fold(0, (sum, sub) => sum + sub.length);
  
  
}

void simulateUnstartedPostSeason(List<List<TeamSim>> simsByLeague){
  int teamCount = simsByLeague.fold(0, (sum, sub) => sum + sub.length);
  
  //simulate complete playoff run
  var leagueChampSims = <TeamSim>[];
  
  for (var simLeague in simsByLeague) {
    sortTeamSims(simLeague);
    
    var round1Sims = <TeamSim>[];
    round1Sims.add(simLeague[0]);
    round1Sims.add(simLeague[1]);
    round1Sims.add(simLeague[2]);
    
    if (simData.leagueWildCards){
    
      // wild card round
      // pick a random team not in playoffs and simulate
      var nonPlayoffCount = simLeague.length - 4;
      var wildCardIndex = rand.nextInt(nonPlayoffCount) + 4;
      var wildCard = simLeague[wildCardIndex];
      simLeague.take(4).forEach((sim) => sim.wcSeries = true);
      wildCard.wcSeries = true;
      //print('WildCard pick $wildCardIndex $wildCard');
      //simulate 3 win series with wild card pic
      var wildSeriesWinner = simulateSeries(simLeague[3], wildCard, 2, teamCount);
      round1Sims.add(wildSeriesWinner);
      //print('WildCard pick $wildCardIndex $wildCard WildSeriesWinner $wildSeriesWinner');
      
    } else {
      round1Sims.add(simLeague[3]);
    }
    
    round1Sims.forEach((sim) => sim.r1Series = true);
    
    // round 1
    var r1SeriesWinnerA = simulateSeries(round1Sims[0], round1Sims[3], 3, teamCount);
    var r1SeriesWinnerB = simulateSeries(round1Sims[1], round1Sims[2], 3, teamCount);
    
    // subleague round
    var slRoundSims = [r1SeriesWinnerA, r1SeriesWinnerB];
    slRoundSims.forEach((sim) => sim.slSeries = true);
    
    var slWinner = simulateSeries(slRoundSims[0], slRoundSims[1], 3, teamCount);
    leagueChampSims.add(slWinner);
  }
  // ilb round
  leagueChampSims.forEach((sim) => sim.ilbSeries = true);
  var ilbWinner = simulateSeries(leagueChampSims[0], leagueChampSims[1], 3, teamCount);
  //print('ILBWinner: $ilbWinner');
  ilbWinner.ilbChamp = true;
  
}