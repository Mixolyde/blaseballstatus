import 'dart:math';
import 'package:meta/meta.dart';
import 'database_api.dart';
import 'site_objects.dart';

late SimulationData simData;
late Season season;
List<Game> games = [];
Random rand = Random(0);

@visibleForTesting
Future<void> setLateData(SimulationData testSimData) async {
  simData = testSimData;
  season = await getSeason(simData.season);
}

Future<void> calculateChances(List<List<TeamStandings>> subStandings, int numSims, 
  List<PlayoffBracketEntry> entries) async {
  simData = await getSimulationData();
  season = await getSeason(simData.season);
  print('Getting game data');
  games = await getAllGames(simData.season);
  print('Getting postseason data');
    
  //print(games[0]);

  runSimulations(games, subStandings, numSims);
  
}

//Seeds are 1-indexed for display
// League 1
// 0 - Seed 4    4 - Seed 1
// 1 - Seed 5    5 - TBD   
//                         
//               6 - Seed 2
//               7 - Seed 3

// League 2
//               8 - Seed 2
//               9 - Seed 3
// 2 - Seed 4   10 - Seed 1
// 3 - Seed 5   11 - TBD

// 12, 13, 14, 15, 16, 17, 18 - TBD
Future<List<PlayoffBracketEntry>> calculatePlayoffBracketEntries(
  CompletePostseason? postSeason, List<List<TeamStandings>> subStandings) async {
    
  var league1 = subStandings[0][0].subleague;
  var league2 = subStandings[1][0].subleague;
  
  print('Leagues: $league1 $league2');
  
  print('$league1 Teams:');
  subStandings[0].forEach((stand){
    print('${stand}');
  });
  print('$league2 Teams:');
  subStandings[1].forEach((stand){
    print('${stand}');
  });
  
  //default entries for no post season data
  var entries = List.generate(19, (i) =>
    PlayoffBracketEntry(      
      position: i,
      seed: 0,
      teamID: '',
      teamNickname: 'TBD',
      subleague: 'TBD',
      wins: 0));
  
  // 1-indexed for display
  entries[0].seed = 4;
  entries[1].seed = 5;
  entries[2].seed = 4;
  entries[3].seed = 5;  
  entries[4].seed = 1;
  entries[6].seed = 2;
  entries[7].seed = 3;  
  entries[8].seed = 2;
  entries[9].seed = 3;    
  entries[10].seed = 1;
  
  entries[0].teamNickname = 'Seed';
  entries[1].teamNickname = 'Seed';
  entries[2].teamNickname = 'Seed';
  entries[3].teamNickname = 'Seed';  
  entries[4].teamNickname = 'Seed';
  entries[6].teamNickname = 'Seed';
  entries[7].teamNickname = 'Seed';  
  entries[8].teamNickname = 'Seed';
  entries[9].teamNickname = 'Seed';    
  entries[10].teamNickname = 'Seed';
  
  entries[0].subleague = league1;
  entries[1].subleague = league1;
  entries[2].subleague = league2;
  entries[3].subleague = league2;  
  entries[4].subleague = league1;
  entries[5].subleague = league1;
  entries[6].subleague = league1;
  entries[7].subleague = league1;  
  entries[8].subleague = league2;
  entries[9].subleague = league2;    
  entries[10].subleague = league2;  
  entries[11].subleague = league2; 
  entries[12].subleague = league1; 
  entries[13].subleague = league1; 
  entries[14].subleague = league2; 
  entries[15].subleague = league2; 
  entries[16].subleague = league1; 
  entries[17].subleague = league2; 
  
  if(postSeason == null){
    // not in postseason, yet, return defaults
    return entries;
  }
  
  print(postSeason);
  print(postSeason.playoffRounds.values);
  
  // Wild Card Round (2 wins needed)
  var round0 = postSeason.playoffRounds.values.firstWhere(
    (r) => r.roundNumber == 0);
  print ('Round0: $round0');
  
  //matchup seeds are 0-indexed, lower seed is always home
  var league1Matchup = locateMatchup(postSeason, round0, subStandings[0]);
  print ('league1Matchup: $league1Matchup');
  var homeStanding = subStandings[0].firstWhere((standing) => 
    standing.id == league1Matchup.homeTeam);
  var awayStanding = subStandings[0].firstWhere((standing) => 
    standing.id == league1Matchup.awayTeam);
  populatePlayoffMatchupEntries(entries[0], entries[1], 
    homeStanding, awayStanding, league1Matchup);

  var league2Matchup = locateMatchup(postSeason, round0, subStandings[1]);    
  print ('league2Matchup: $league2Matchup');
  homeStanding = subStandings[1].firstWhere((standing) => 
    standing.id == league2Matchup.homeTeam);
  awayStanding = subStandings[1].firstWhere((standing) => 
    standing.id == league2Matchup.awayTeam);
  populatePlayoffMatchupEntries(entries[2], entries[3], 
    homeStanding, awayStanding, league2Matchup);
  
  // Round 2 (3 wins needed)
  var round1 = postSeason.playoffRounds.values.firstWhere(
    (r) => r.roundNumber == 1);
  print ('Round1: $round1');
  if(round1.matchupIDs.isNotEmpty){
    var matchup = locateMatchup(postSeason, 
      round1, subStandings[0], seed: 0 );
    
    print ('league1 Matchup High Seed: $matchup');
    homeStanding = subStandings[0].firstWhere((standing) => 
      standing.id == matchup.homeTeam);
    awayStanding = subStandings[0].firstWhere((standing) => 
      standing.id == matchup.awayTeam);
    populatePlayoffMatchupEntries(entries[4], entries[5], 
      homeStanding, awayStanding, matchup);
      
    matchup = locateMatchup(postSeason, 
      round1, subStandings[0], seed: 1 );
    
    print ('league1 Matchup Low Seed: $matchup');
    homeStanding = subStandings[0].firstWhere((standing) => 
      standing.id == matchup.homeTeam);
    awayStanding = subStandings[0].firstWhere((standing) => 
      standing.id == matchup.awayTeam);
    populatePlayoffMatchupEntries(entries[6], entries[7], 
      homeStanding, awayStanding, matchup);

    matchup = locateMatchup(postSeason, 
      round1, subStandings[1], seed: 1 );
    
    print ('league2 Matchup Low Seed: $matchup');
    homeStanding = subStandings[1].firstWhere((standing) => 
      standing.id == matchup.homeTeam);
    awayStanding = subStandings[1].firstWhere((standing) => 
      standing.id == matchup.awayTeam);
    populatePlayoffMatchupEntries(entries[8], entries[9], 
      homeStanding, awayStanding, matchup);

      matchup = locateMatchup(postSeason, 
      round1, subStandings[1], seed: 0 );
    
    print ('league2 Matchup High Seed: $matchup');
    homeStanding = subStandings[1].firstWhere((standing) => 
      standing.id == matchup.homeTeam);
    awayStanding = subStandings[1].firstWhere((standing) => 
      standing.id == matchup.awayTeam);
    populatePlayoffMatchupEntries(entries[10], entries[11], 
      homeStanding, awayStanding, matchup);
  }
  
  // Subleague series (3 wins needed)
  var round2 = postSeason.playoffRounds.values.firstWhere(
    (r) => r.roundNumber == 2);
  //print ('Round2: $round2');

  if(round2.matchupIDs.isNotEmpty){
    var matchup = locateMatchup(postSeason, 
      round2, subStandings[0]);
    
    print ('league1 Finals Matchup: $matchup');
    homeStanding = subStandings[0].firstWhere((standing) => 
      standing.id == matchup.homeTeam);
    awayStanding = subStandings[0].firstWhere((standing) => 
      standing.id == matchup.awayTeam);
    populatePlayoffMatchupEntries(entries[12], entries[13], 
      homeStanding, awayStanding, matchup);
  
    matchup = locateMatchup(postSeason, 
      round2, subStandings[1]);
    
    print ('league2 Finals Matchup: $matchup');
    homeStanding = subStandings[1].firstWhere((standing) => 
      standing.id == matchup.homeTeam);
    awayStanding = subStandings[1].firstWhere((standing) => 
      standing.id == matchup.awayTeam);
    populatePlayoffMatchupEntries(entries[14], entries[15], 
      homeStanding, awayStanding, matchup);
  }
  
  // ILB Series (3 wins needed)
  var round3 = postSeason.playoffRounds.values.firstWhere(
    (r) => r.roundNumber == 3);
  //print ('Round3: $round3');
  if(round3.matchupIDs.isNotEmpty){
    var matchup = postSeason.playoffMatchups[round3.matchupIDs[0]]!;
    
    print ('ILB Finals Matchup: $matchup');
    var league1Standing = subStandings[0].firstWhere((standing) => 
      standing.id == matchup.homeTeam ||
      standing.id == matchup.awayTeam);
    var league2Standing = subStandings[1].firstWhere((standing) => 
      standing.id == matchup.awayTeam ||
      standing.id == matchup.homeTeam);

    //entry 15 is always the league1 seed, 16 is the league2 seed
    entries[16].teamID = league1Standing.id;
    entries[17].teamID = league2Standing.id;
    entries[16].teamNickname = league1Standing.nickname;
    entries[17].teamNickname = league2Standing.nickname;
    
    if(league1Standing.id == matchup.homeTeam){
      entries[16].wins = matchup.homeWins;
      entries[17].wins = matchup.awayWins;
      //convert to 1-index for display
      entries[16].seed = matchup.homeSeed + 1;
      entries[17].seed = (matchup.awaySeed ?? 0) + 1;
    } else {
      entries[16].wins = matchup.awayWins;
      entries[17].wins = matchup.homeWins;
      //convert to 1-index for display
      entries[16].seed = (matchup.awaySeed ?? 0) + 1;
      entries[17].seed = matchup.homeSeed + 1;
    }
    
    if(entries[16].wins >= 3){
      print('$league1 team won the ILB');
      entries[18].teamID = entries[16].teamID;
      entries[18].teamNickname = entries[16].teamNickname;
      entries[18].wins = entries[16].wins;
      entries[18].seed = entries[16].seed;
      entries[18].subleague = entries[16].subleague;
    } else if(entries[17].wins >= 3) {
      print('$league2 team won the ILB');
      entries[18].teamID = entries[17].teamID;
      entries[18].teamNickname = entries[17].teamNickname;
      entries[18].wins = entries[17].wins;
      entries[18].seed = entries[17].seed;
      entries[18].subleague = entries[17].subleague;
    }

      
  }
  
  return entries;
  
}

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

void populatePlayoffMatchupEntries(PlayoffBracketEntry homeEntry, 
    PlayoffBracketEntry awayEntry, TeamStandings homeStanding, 
    TeamStandings awayStanding, PlayoffMatchup matchup){
  homeEntry.teamID = matchup.homeTeam;
  awayEntry.teamID = matchup.awayTeam ?? 'Away Team';
  homeEntry.teamNickname = homeStanding.nickname;
  awayEntry.teamNickname = awayStanding.nickname;
  homeEntry.wins = matchup.homeWins;
  awayEntry.wins = matchup.awayWins;
  //convert to 1-index for display
  homeEntry.seed = matchup.homeSeed + 1;
  awayEntry.seed = (matchup.awaySeed ?? 0) + 1;
}

void runSimulations(List<Game> games, List<List<TeamStandings>> standings, 
  int numSims){
  var sims = mapTeamSims(standings, games);
  
  //simulate season X times and gather results
  var poCounts = <String, List<num>>{};
  var postCounts = <String, List<num>>{};
  // counts for each league playoff berth and no playoffs
  sims.keys.forEach((key) => poCounts[key] = [0, 0, 0, 0, 0]);
  // counts for ILB champ, ILB series, League series, Round 1, WC Round
  sims.keys.forEach((key) => postCounts[key] = [0, 0, 0, 0, 0]);
  var simsByLeague = <List<TeamSim>>[];
  standings.forEach((standingList) {
    var simList = <TeamSim>[];
    standingList.forEach((standing) {
      simList.add(sims[standing.id]!);
    });
    simsByLeague.add(simList);
  });
  
  for (var count = 0; count < numSims; count++){
    simulateSeason(games, sims);
    simulatePostSeason(simsByLeague);
    if (count % 1000 == 0){
      print('Completed simulation count $count');
    }
    
    //sort and count positions
    simsByLeague.forEach((simLeague) {
      sortTeamSims(simLeague);
      TeamSim sim;
      //print('Sorted simleague: $simLeague');
      for (var i = 0; i < simLeague.length; i++){
        sim = simLeague[i];
        switch(i){
          case 0:
          case 1:
          case 2:
          case 3:
            poCounts[sim.id]![i]++;
            break;
          default:
            poCounts[sim.id]![4]++;
            break;
        }
        if(sim.ilbChamp){
          postCounts[sim.id]![0]++;
        }
        if(sim.ilbSeries){
          postCounts[sim.id]![1]++;
        }
        if(sim.slSeries){
          postCounts[sim.id]![2]++;
        }  
        if(sim.r1Series){
          postCounts[sim.id]![3]++;
        }   
        if(sim.wcSeries){
          postCounts[sim.id]![4]++;
        }        
      }
    });
    
    sims.values.forEach((sim) => sim.load());
  }  
  
  //update standings with counts / numSims and formatted
  print('Completed $numSims simulations');
  print('poCounts $poCounts');
  print('postCounts $postCounts');
  print('League Wild Cards: ${simData.leagueWildCards}');
  standings.forEach((standingList) => standingList.forEach((standing) {
    var top3 = standing.winning.take(3).any((win) => win == '^');
    var top4 = top3 || standing.winning[3] == '^';
    
    for(var i = 0; i < 5; i++){
      switch(standing.winning[i]){
        case '^':
        case 'X':
        case 'PT':
          standing.po[i] = standing.winning[i];
          break;
        default:
          standing.po[i] = formatPercent(poCounts[standing.id]![i] / numSims);
          break;
      }
      
      //postseason percents
      //TODO handle ^ and X in i=3 and 4
      if(i == 3 && top3) {
        standing.post[i] = '^';
      } else if ( i == 3 && top4 && !simData.leagueWildCards){
        standing.post[i] = '^';
      } else if ( i == 4 && top4 && simData.leagueWildCards){
        standing.post[i] = '^';
      } else {
        if(simData.leagueWildCards){
          standing.post[i] = formatPercent(postCounts[standing.id]![i] / numSims);
        } else {
          if (standing.winning[4] == 'PT' && i < 4){
            standing.post[i] = 'X';
          } else if (i < 4){
            standing.post[i] = formatPercent(postCounts[standing.id]![i] / numSims);
          }
        }
      }
    }
    print('$standing Po ${standing.po} Post ${standing.post} Winning ${standing.winning}');
  }));
  
}

void simulateSeason(List<Game> games, Map<String, TeamSim> sims){
  print('SimulateSeason with TeamSim keys:');
  print(sims.keys.join(' ');
  //print(sims);
  //print(games[0]);
  //simulate unplayed games
  games.where((g) => !g.gameComplete).forEach((g) {
    //print("Sim game between ${g.awayTeam} and ${g.homeTeam}");
    //print('Simulate outcome of $g');
    var awaySim = sims[g.awayTeam]!;
    var homeSim = sims[g.homeTeam]!;
    var winner = simulateGame(awaySim, homeSim, sims.length);
    
    if(winner == awaySim){
      awaySim.notLosses++;
      awaySim.wins++;
      homeSim.losses++;
    } else {
      homeSim.notLosses++;
      homeSim.wins++;
      awaySim.losses++;        
    }    
  });
}
  
void simulatePostSeason(List<List<TeamSim>> simsByLeague){
  int teamCount = simsByLeague.fold(0, (sum, sub) => sum + sub.length);
  
  //simulate complete playoff run
  var leagueChampSims = <TeamSim>[];
  
  simsByLeague.forEach((simLeague) {
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
  });
  // ilb round
  leagueChampSims.forEach((sim) => sim.ilbSeries = true);
  var ilbWinner = simulateSeries(leagueChampSims[0], leagueChampSims[1], 3, teamCount);
  //print('ILBWinner: $ilbWinner');
  ilbWinner.ilbChamp = true;
  
}

TeamSim simulateGame(TeamSim awaySim, TeamSim homeSim, int teamCount){
  //default away chance
  num awayChance = .5;
  if(awaySim.notLosses_save != homeSim.notLosses_save ||
    awaySim.losses_save != homeSim.losses_save){
    //print('Uneven match: ${awaySim.actualWins_save}-${awaySim.losses_save} vs. ' +
    //  '${homeSim.actualWins_save}-${homeSim.losses_save}');
    //Pa = (WPa * (1 - WPh)) / 
    // ((WPa * (1 - WPh) + WPh * ( 1 - WPa)))
    num WPa = awaySim.notLosses_save / (awaySim.losses_save + awaySim.notLosses_save);
    num WPh = homeSim.notLosses_save / (homeSim.losses_save + homeSim.notLosses_save);
    awayChance = (WPa * (1 - WPh)) / 
      ((WPa * (1 - WPh) + WPh * ( 1 - WPa)));
    //adjust chance for N-team league average without this team
    //WP'(N) = WP - ((WP - .500) / (N - 1))
    awayChance = awayChance - ((awayChance - .5) / (teamCount - 1));
  }
  
  //print('Calculated away win chance: $awayChance');    
  if(rand.nextDouble() < awayChance){
    return awaySim;
  } else {
    return homeSim;        
  }    
  
}

TeamSim simulateSeries(TeamSim awaySim, TeamSim homeSim, int winsNeeded, int teamCount){
  var awayWins = 0;
  var homeWins = 0;
  TeamSim winner;
  while(awayWins < winsNeeded && homeWins < winsNeeded){
    winner = simulateGame(awaySim, homeSim, teamCount);
    if(winner == awaySim){
      awayWins++;
    } else {
      homeWins++;
    }
  }
  if(awayWins >= winsNeeded){
    return awaySim;
  } else {
    return homeSim;
  }
  
}

Map<String, TeamSim> mapTeamSims(List<List<TeamStandings>> standings, List<Game> games){
  var sims = <String, TeamSim>{};
  standings.forEach((standingsList) {
    standingsList.forEach((standing) {
      var actualWins = games.where((g) =>
        (g.awayTeam == standing.id && g.awayScore > g.homeScore) ||
        (g.homeTeam == standing.id && g.homeScore > g.awayScore)).length;
      var sim = TeamSim(standing.id, actualWins,
        standing.wins, standing.losses, standing.favor, standing.division);
      sim.save();
      sims[sim.id] = sim;
    });
  });
  return sims;
}

//sort teams by wins, divine favor
void sortTeamSims(List<TeamSim> teams) {
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
    //print('Top four teams are the same division');
    //find top of other division
    var otherLeader = teams.firstWhere((team) =>
      team.division != firstDiv);
    //print('Moving $otherLeader');
    teams.remove(otherLeader);
    teams.insert(3, otherLeader);
  }  
}

String formatPercent(num perc){
  perc *= 100;
  if(perc < 1){
    return '<1%';
  } else if (perc > 99){
    return '>99%';
  } else {
    return '${perc.floor().toString()}%';
  }
}

class TeamSim {
  String id;
  int notLosses;
  int wins;
  int losses;
  int favor;
  String division;
  
  int notLosses_save = 0;
  int wins_save = 0;
  int losses_save = 0;
  
  bool wcSeries = false;
  bool r1Series = false;
  bool slSeries = false;
  bool ilbSeries = false;
  bool ilbChamp = false;
  
  TeamSim(this.id, this.notLosses, this.wins, this.losses,
    this.favor, this.division);
  
  void save(){
    notLosses_save = notLosses;
    wins_save = wins;
    losses_save = losses;
  }
  
  void load(){
    notLosses = notLosses_save;
    wins = wins_save;
    losses = losses_save;
    wcSeries = false;
    r1Series = false;
    slSeries = false;
    ilbSeries = false;
    ilbChamp = false;
  }
  
  @override
  String toString() => '$id Wins $wins Record: ($notLosses - $losses) '
    'Saved: $notLosses_save $wins_save $losses_save';
  
}
