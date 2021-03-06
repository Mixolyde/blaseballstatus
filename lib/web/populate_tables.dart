import 'dart:html';

import 'package:blaseballstatus/site_objects.dart';

void populateGamesBehindTable(List<TeamStandings> subStandings, bool groupByDiv){
  TableElement table = querySelector("#standingsTable");
  List<TeamStandings> standings = subStandings.toList();
  if(groupByDiv == true){
    String firstDiv = subStandings[0].division;
    standings = subStandings.where((t) => t.division == firstDiv).toList();
    standings.addAll(subStandings.where((t) => 
      t.division != firstDiv).toList());
  }
  
  standings.forEach((row){
    TableRowElement trow = insertCommonCells(table, row);
    trow.insertCell(5)
      ..text = row.gamesPlayed.toString();    
    trow.insertCell(6)
      ..text = (99 - row.gamesPlayed).toString();       
    trow.insertCell(7)
      ..text = row.gbDiv;        
    trow.insertCell(8)
      ..text = row.gbWc;
  });
  
  if(groupByDiv == true){
    insertSeparatorRow(table, 8, 9); 
  } else {
    insertSeparatorRow(table, 6, 9); 
  }
  
}

void populateChancesTable(List<TeamStandings> subStandings, bool groupByDiv){
  TableElement table = querySelector("#standingsTable");
  List<TeamStandings> standings = subStandings.toList();
  if(groupByDiv == true){
    String firstDiv = subStandings[0].division;
    standings = subStandings.where((t) => t.division == firstDiv).toList();
    standings.addAll(subStandings.where((t) => 
      t.division != firstDiv).toList());
  }
  
  standings.forEach((row){
    TableRowElement trow = insertCommonCells(table, row);
    for(int i = 0; i < 5; i++){
      var cell = trow.insertCell(5 + i)
        ..text = row.po[i];
      switch (row.po[i]){
        case "PT":
        case "X":
          cell.classes.add("redcell");
          break;
        default:
          if(row.winning[i] == "DNCD") {
            cell.classes.add("redcell");
          } else {
            cell.classes.add("greencell");
          }
          break;
      }
    }
  });
  
  if(groupByDiv == true){
    insertSeparatorRow(table, 8, 10); 
  } else {
    insertSeparatorRow(table, 6, 10); 
  }
}

void populatePostseasonTable(List<List<TeamStandings>> allStandings, bool groupByDiv){
  TableElement table = querySelector("#standingsTable");
  List<TeamStandings> standings = new List<TeamStandings>();
  standings.addAll(allStandings[0]);
  standings.addAll(allStandings[1]);

  standings.sort((a, b) {
    if(groupByDiv){
      if(a.subleague != b.subleague){
        return a.subleague.compareTo(b.subleague);
      } else if (a.division != b.division){
        return a.division.compareTo(b.division);
      }
    }
    for(int i = 0; i < 5; i++){
      if(b.post[i] != a.post[i]){
        return getOrderValue(b.post[i]).compareTo(getOrderValue(a.post[i]));
      }
    }
    return 0;
  });
  
  standings.forEach((row){
    TableRowElement trow = insertCommonCells(table, row, showLeague: true);
    for(int i = 0; i < 5; i++){
      var cell = trow.insertCell(6 + i)
        ..text = row.post[i];
      if(row.winning[4] == "PT" || row.winning[3] == "DNCD" ){
        cell.classes.add("redcell");
      } else {
        cell.classes.add("greencell");
      }

    }
  });
  
  if(groupByDiv == true){
    insertSeparatorRow(table, 7, 11); 
    insertSeparatorRow(table, 14, 11); 
    insertSeparatorRow(table, 21, 11); 
  } 
}

void populateWinningTable(List<TeamStandings> subStandings, bool groupByDiv){
  TableElement table = querySelector("#standingsTable");
  List<TeamStandings> standings = subStandings.toList();
  if(groupByDiv == true){
    String firstDiv = subStandings[0].division;
    standings = subStandings.where((t) => t.division == firstDiv).toList();
    standings.addAll(subStandings.where((t) => 
      t.division != firstDiv).toList());
  }
  
  standings.forEach((row){
    TableRowElement trow = insertCommonCells(table, row);
    for(int i = 0; i < 5; i++){
      var cell = trow.insertCell(5 + i)
        ..text = row.winning[i];
      switch (row.winning[i]){
        case "PT":
        case "X":
        case "DNCD":
          cell.classes.add("redcell");
          break;
        default:
          cell.classes.add("greencell");
          break;
      }
    }
  });
  
  if(groupByDiv == true){
    insertSeparatorRow(table, 8, 10); 
  } else {
    insertSeparatorRow(table, 6, 10); 
  }
}

void populatePartyTimeTable(List<TeamStandings> subStandings, bool groupByDiv){
  TableElement table = querySelector("#standingsTable");
  List<TeamStandings> standings = subStandings.toList();
  if(groupByDiv == true){
    String firstDiv = subStandings[0].division;
    standings = subStandings.where((t) => t.division == firstDiv).toList();
    standings.addAll(subStandings.where((t) => 
      t.division != firstDiv).toList());
  }
  
  standings.forEach((row){
    TableRowElement trow = insertCommonCells(table, row);     
    for(int i = 0; i < 5; i++){
      var cell = trow.insertCell(5 + i)
        ..text = row.partytime[i];
      switch (row.partytime[i]){
        case "PT":
        case "X":
          cell.classes.add("redcell");
          break;
        default:
          cell.classes.add("greencell");
          break;
      }
    }
  });
  
  if(groupByDiv == true){
    insertSeparatorRow(table, 8, 10); 
  } else {
    insertSeparatorRow(table, 6, 10); 
  }
}

void populateAboutPageData(List<List<TeamStandings>> subStandings){
  OListElement tbList = querySelector('#tiebreakerlist');
  if(tbList.children != null){
    tbList.children.clear();
  }
  List<TeamStandings> allStandings = new List<TeamStandings>();
    allStandings.addAll(subStandings[0]);
    allStandings.addAll(subStandings[1]);      
  for(int favor = 0; favor < allStandings.length; favor++){
    TeamStandings stand = allStandings.firstWhere((team) =>
      team.favor == favor);
    LIElement item = new LIElement();
    item.text = stand.nickname;
    tbList.children.add(item);
  }
      
}

TableRowElement insertCommonCells(TableElement table, 
  TeamStandings row, {showLeague = false} ){
  TableRowElement trow = table.addRow();
  AnchorElement shortTeamLink = new AnchorElement(
    href:"https://www.blaseball.com/team/${row.id}")
    ..text = row.nickname
    ..target = "_new";
  AnchorElement longTeamLink = new AnchorElement(
    href:"https://www.blaseball.com/team/${row.id}")
    ..text = row.fullName
    ..target = "_new";  
  SpanElement emojiSpan = new SpanElement();
  //print("Emoji string: ${row.emoji}");
  if(row.emoji.startsWith("0")){
    emojiSpan.innerHtml = " &#${row.emoji.substring(1, row.emoji.length)};";
  } else if (row.nickname == "Lift") {
    emojiSpan.innerHtml = " &#x1F3CB;";
  } else {
    emojiSpan.innerHtml = "  ";
  }
  
  var cell = trow.insertCell(0);
  cell.classes.add('tblteam');
  SpanElement wideSpan = new SpanElement();
  wideSpan.classes.add('wide');
  SpanElement narrowSpan = new SpanElement();
  narrowSpan.classes.add('narrow');
  wideSpan.children.add(longTeamLink);
  narrowSpan.children.add(shortTeamLink);
  
  cell.children.add(wideSpan);
  cell.children.add(narrowSpan);
  cell.children.add(emojiSpan);
  
  int leagueAdjust = 0;
  if(showLeague){
    leagueAdjust = 1;
    trow.insertCell(1)
      ..text = row.subleague;    
  }
  trow.insertCell(1 + leagueAdjust)
    ..text = row.division;
  trow.insertCell(2 + leagueAdjust)
    ..text = (row.favor + 1).toString();
  trow.insertCell(3 + leagueAdjust)
    ..text = row.wins.toString();
  String record = "${row.gamesPlayed - row.losses} - ${row.losses}";
  trow.insertCell(4 + leagueAdjust)
    ..text = record;   

  return trow;

}

void insertSeparatorRow(TableElement table, int row, int columns){
  var sepRow = table.insertRow(row);
  sepRow.insertCell(0)
    ..text = '&nbsp;'
    ..colSpan = columns
    ..classes.add('sepRow');  
}

int getOrderValue(String percent){
  if(percent == "<1%"){
    return 0;
  } else if(percent == ">99%"){
    return 100;
  } else if(percent == "^"){
    return 101;
  } else {
    String digits = percent.replaceAll("%", "");
    return int.parse(digits);
  }
}