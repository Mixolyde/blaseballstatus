import 'dart:convert';
import 'dart:math';
import 'package:intl/intl.dart';
import 'calc_stats.dart';
import 'database_api.dart';
import 'site_objects.dart';

SimulationData simData;
Season season;
List<Game> games;
Random rand = new Random(0);

Future<void> calculateChances(List<List<TeamStandings>> subStandings, int numSims) async {
  simData = await getSimulationData();
  season = await getSeason(simData.season);
  print("Getting game data");
  games = await getAllGames(simData.season);
  //CompletePostseason postSeason = await getCompletePostseason(simData.season);
    
  //print(games[0]);

  runSimulations(games, subStandings, numSims);
  
}

void runSimulations(List<Game> games, List<List<TeamStandings>> standings, 
  int numSims){
  Map<String, TeamSim> sims = mapTeamSims(standings, games);
  
  //simulate season X times and gather results
  Map<String, List<num>> poCounts = new Map<String, List<num>>();
  Map<String, List<num>> postCounts = new Map<String, List<num>>();
  // counts for each league playoff berth and no playoffs
  sims.keys.forEach((key) => poCounts[key] = [0, 0, 0, 0, 0]);
  // counts for ILB champ, ILB series, League series, Round 1, WC Round
  sims.keys.forEach((key) => postCounts[key] = [0, 0, 0, 0, 0]);
  List<List<TeamSim>> simsByLeague = new List<List<TeamSim>>();
  standings.forEach((standingList) {
    List<TeamSim> simList = new List<TeamSim>();
    standingList.forEach((standing) {
      simList.add(sims[standing.id]);
    });
    simsByLeague.add(simList);
  });
  
  for (int count = 0; count < numSims; count++){
    simulateSeason(games, sims);
    simulatePostSeason(simsByLeague);
    if (count % 1000 == 0){
      print("Completed simulation count $count");
    }
    
    //sort and count positions
    simsByLeague.forEach((simLeague) {
      sortTeamSims(simLeague);
      TeamSim sim;
      //print("Sorted simleague: $simLeague");
      for (int i = 0; i < simLeague.length; i++){
        sim = simLeague[i];
        switch(i){
          case 0:
          case 1:
          case 2:
          case 3:
            poCounts[sim.id][i]++;
            break;
          default:
            poCounts[sim.id][4]++;
            break;
        }
        if(sim.ilbChamp){
          postCounts[sim.id][0]++;
        }
        if(sim.ilbSeries){
          postCounts[sim.id][1]++;
        }
        if(sim.slSeries){
          postCounts[sim.id][2]++;
        }  
        if(sim.r1Series){
          postCounts[sim.id][3]++;
        }   
        if(sim.wcSeries){
          postCounts[sim.id][4]++;
        }        
      }
    });
    
    sims.values.forEach((sim) => sim.load());
  }  
  
  //update standings with counts / numSims and formatted
  print("Completed $numSims simulations");
  print("poCounts $poCounts");
  print("postCounts $postCounts");
  standings.forEach((standingList) => standingList.forEach((standing) {
    bool top3 = standing.winning.take(3).any((win) => win == "^");
    bool top4 = top3 || standing.winning[3] == "^";
    
    for(int i = 0; i < 5; i++){
      switch(standing.winning[i]){
        case '^':
        case 'X':
        case 'PT':
          standing.po[i] = standing.winning[i];
          break;
        default:
          standing.po[i] = formatPercent(poCounts[standing.id][i] / numSims);
          break;
      }
      
      //postseason percents
      //TODO handle ^ and X in i=3 and 4
      if(i == 3 && top3) {
        standing.post[i] = "^";
      } else if ( i == 4 && top4){
        standing.post[i] = "^";
      } else {
        standing.post[i] = formatPercent(postCounts[standing.id][i] / numSims);
      }
    }
    print("$standing Po ${standing.po} Post ${standing.post}");
  }));
  
}

void simulateSeason(List<Game> games, Map<String, TeamSim> sims){
  //simulate unplayed games
  games.where((g) => !g.gameComplete).forEach((g) {
    TeamSim awaySim = sims[g.awayTeam];
    TeamSim homeSim = sims[g.homeTeam];
    //print("Simulate outcome of $g");
    TeamSim winner = simulateGame(awaySim, homeSim, sims.length);
    
    if(winner == awaySim){
      awaySim.actualWins++;
      awaySim.wins++;
      homeSim.losses++;
    } else {
      homeSim.actualWins++;
      homeSim.wins++;
      awaySim.losses++;        
    }    
  });
}
  
void simulatePostSeason(List<List<TeamSim>> simsByLeague){
  int teamCount = simsByLeague.fold(0, (sum, sub) => sum + sub.length);
  
  //simulate complete playoff run
  List<TeamSim> leagueChampSims = new List<TeamSim>();
  
  simsByLeague.forEach((simLeague) {
    sortTeamSims(simLeague);
    
    List<TeamSim> round1Sims = new List<TeamSim>(4);
    round1Sims[0] = simLeague[0];
    round1Sims[1] = simLeague[1];
    round1Sims[2] = simLeague[2];
    
    List<TeamSim> round2Sims = new List<TeamSim>(2);
    
    // wild card round
    // pick a random team not in playoffs and simulate
    int nonPlayoffCount = simLeague.length - 4;
    int wildCardIndex = rand.nextInt(nonPlayoffCount) + 4;
    TeamSim wildCard = simLeague[wildCardIndex];
    simLeague.take(4).forEach((sim) => sim.wcSeries = true);
    wildCard.wcSeries = true;
    //print("WildCard pick $wildCardIndex $wildCard");
    //simulate 3 win series with wild card pic
    TeamSim wildSeriesWinner = simulateSeries(simLeague[3], wildCard, 2, teamCount);
    round1Sims[3] = wildSeriesWinner;
    //print("WildCard pick $wildCardIndex $wildCard WildSeriesWinner $wildSeriesWinner");
    round1Sims.forEach((sim) => sim.r1Series = true);
    
    // round 1
    TeamSim r1SeriesWinnerA = simulateSeries(round1Sims[0], round1Sims[3], 3, teamCount);
    TeamSim r1SeriesWinnerB = simulateSeries(round1Sims[1], round1Sims[2], 3, teamCount);
    
    // subleague round
    List<TeamSim> slRoundSims = new List<TeamSim>(2);
    slRoundSims[0] = r1SeriesWinnerA;
    slRoundSims[1] = r1SeriesWinnerB;
    slRoundSims.forEach((sim) => sim.slSeries = true);
    
    TeamSim slWinner = simulateSeries(slRoundSims[0], slRoundSims[1], 3, teamCount);
    leagueChampSims.add(slWinner);
  });
  // ilb round
  leagueChampSims.forEach((sim) => sim.ilbSeries = true);
  TeamSim ilbWinner = simulateSeries(leagueChampSims[0], leagueChampSims[1], 3, teamCount);
  //print("ILBWinner: $ilbWinner");
  ilbWinner.ilbChamp = true;
  
}

TeamSim simulateGame(TeamSim awaySim, TeamSim homeSim, int teamCount){
  //default away chance
  num awayChance = .5;
  if(awaySim.actualWins_save != homeSim.actualWins_save ||
    awaySim.losses_save != homeSim.losses_save){
    //print("Uneven match: ${awaySim.actualWins_save}-${awaySim.losses_save} vs. " +
    //  "${homeSim.actualWins_save}-${homeSim.losses_save}");
    //Pa = (WPa * (1 - WPh)) / 
    // ((WPa * (1 - WPh) + WPh * ( 1 - WPa)))
    num WPa = awaySim.actualWins_save / (awaySim.losses_save + awaySim.actualWins_save);
    num WPh = homeSim.actualWins_save / (homeSim.losses_save + homeSim.actualWins_save);
    awayChance = (WPa * (1 - WPh)) / 
      ((WPa * (1 - WPh) + WPh * ( 1 - WPa)));
    //adjust chance for N-team league average without this team
    //WP'(N) = WP - ((WP - .500) / (N - 1))
    awayChance = awayChance - ((awayChance - .5) / (teamCount - 1));
  }
  
  //print("Calculated away win chance: $awayChance");    
  if(rand.nextDouble() < awayChance){
    return awaySim;
  } else {
    return homeSim;        
  }    
  
}

TeamSim simulateSeries(TeamSim awaySim, TeamSim homeSim, int winsNeeded, int teamCount){
  int awayWins = 0;
  int homeWins = 0;
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
  Map<String, TeamSim> sims = new Map<String, TeamSim>();
  standings.forEach((standingsList) {
    standingsList.forEach((standing) {
      int actualWins = games.where((g) =>
        (g.awayTeam == standing.id && g.awayScore > g.homeScore) ||
        (g.homeTeam == standing.id && g.homeScore > g.awayScore)).length;
      TeamSim sim = new TeamSim(standing.id, actualWins,
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
  String firstDiv = teams.first.division;
  if(teams.take(4).every((team) =>
    team.division == firstDiv) ||
    teams.take(4).every((team) =>
    team.division != firstDiv)){
    //print("Top four teams are the same division");
    //find top of other division
    TeamSim otherLeader = teams.firstWhere((team) =>
      team.division != firstDiv);
    //print("Moving $otherLeader");
    teams.remove(otherLeader);
    teams.insert(3, otherLeader);
  }  
}

String formatPercent(num perc){
  perc *= 100;
  if(perc < 1){
    return "<1%";
  } else if (perc > 99){
    return ">99%";
  } else {
    return "${perc.floor().toString()}%";
  }
}

class TeamSim {
  String id;
  int actualWins;
  int wins;
  int losses;
  int favor;
  String division;
  
  int actualWins_save;
  int wins_save;
  int losses_save;
  
  bool wcSeries = false;
  bool r1Series = false;
  bool slSeries = false;
  bool ilbSeries = false;
  bool ilbChamp = false;
  
  TeamSim(this.id, this.actualWins, this.wins, this.losses,
    this.favor, this.division);
  
  void save(){
    actualWins_save = actualWins;
    wins_save = wins;
    losses_save = losses;
  }
  
  void load(){
    actualWins = actualWins_save;
    wins = wins_save;
    losses = losses_save;
    wcSeries = false;
    r1Series = false;
    slSeries = false;
    ilbSeries = false;
    ilbChamp = false;
  }
  
  String toString() => "$id Wins $wins Record: ($actualWins - $losses) " +
    "Saved: $actualWins_save $wins_save $losses_save";
  
}
