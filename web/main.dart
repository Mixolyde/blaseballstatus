import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:blaseballstatus/database_api.dart';
import 'package:blaseballstatus/calc_stats.dart';

enum View { gamesbehind, winningmagic, partytimemagic}

// 0 or 1;
int activeLeague;
String gamesbehindHTML;
String magicHTML;
String winningNotesHTML;
String partytimeNotesHTML;
View activeView = View.gamesbehind;
SimulationData simData;
SiteData sitedata;

void main() {
  getContentPages().then((v) {
    print("Retrieved content pages and data");

    clickLeague(0);
    
    addListeners();
  });
}

Future<void> getContentPages() async {
  simData = await getSimulationData();
  querySelector('.wkinfo').text = 
    "Season ${simData.season + 1}: " + 
    "Day ${simData.day + 1}";
  sitedata = await calcSiteData();
  querySelector('#lastUpdate').text = sitedata.lastUpdate;
  querySelector('#pickLeague1').text = sitedata.subnicknames[0];
  querySelector('#pickLeague2').text = sitedata.subnicknames[1];

  gamesbehindHTML = await HttpRequest.getString('gamesbehind.html');
  setMainContent(gamesbehindHTML);
  await calcStats(simData.season);
  magicHTML = await HttpRequest.getString('magic.html');
  winningNotesHTML = await HttpRequest.getString('winningNotes.html');
  partytimeNotesHTML = await HttpRequest.getString('partytimeNotes.html');
}

void addListeners(){
  querySelector('#pickLeague1').onClick.listen(selectLeague1);
  querySelector('#pickLeague2').onClick.listen(selectLeague2);
  
  querySelector('#viewGamesBehind').onClick.listen(selectViewGB);
  querySelector('#viewWinningNumbers').onClick.listen(selectViewW);
  querySelector('#viewPartyTimeNumbers').onClick.listen(selectViewPT);
}

void selectLeague1(MouseEvent event) => clickLeague(0);
void selectLeague2(MouseEvent event) => clickLeague(1);

void clickLeague(int league){
  if (league == activeLeague){
    return;
  }
  activeLeague = league;
  if(league == 0){
    querySelector('#pickLeague1').classes
      .add('nav-button-active');
    querySelector('#pickLeague2').classes
      .remove('nav-button-active');
  } else {
    querySelector('#pickLeague1').classes
      .remove('nav-button-active');
    querySelector('#pickLeague2').classes
      .add('nav-button-active');
  }

 
  redisplayData();
  
}

void selectViewGB(MouseEvent event) => clickView(View.gamesbehind);
void selectViewW(MouseEvent event) => clickView(View.winningmagic);
void selectViewPT(MouseEvent event) => clickView(View.partytimemagic);

void clickView(View view){
  if(view == activeView){
    return;
  }
  activeView = view;
  switch(activeView){
    case View.gamesbehind:
      print("Switch to gamesbehind");
      querySelector('#viewGamesBehind').classes
        .add('nav-button-active');
      querySelector('#viewWinningNumbers').classes
        .remove('nav-button-active');
      querySelector('#viewPartyTimeNumbers').classes
        .remove('nav-button-active');

      break;
    case View.winningmagic:
      print("Switch to winningmagic");
      querySelector('#viewGamesBehind').classes
        .remove('nav-button-active');
      querySelector('#viewWinningNumbers').classes
        .add('nav-button-active');
      querySelector('#viewPartyTimeNumbers').classes
        .remove('nav-button-active');      
      
      break;
    case View.partytimemagic:
      print("Switch to partytimemagic");
      querySelector('#viewGamesBehind').classes
        .remove('nav-button-active');
      querySelector('#viewWinningNumbers').classes
        .remove('nav-button-active');
      querySelector('#viewPartyTimeNumbers').classes
        .add('nav-button-active');

      break;
  }
  
  redisplayData();

}

void redisplayData(){
    switch(activeView){
    case View.gamesbehind:
      setMainContent(gamesbehindHTML);
      querySelector('#leagueTitle').text = 
        sitedata.subnicknames[activeLeague]; 
      populateGamesBehindTable(subStandings[activeLeague]);
      break;
    case View.winningmagic:
      setMainContent(magicHTML);
      querySelector('#leagueTitle').text =
        "${sitedata.subnicknames[activeLeague]} League Winning Magic Numbers";
      populateWinningTable(subStandings[activeLeague]);
      setNotes(winningNotesHTML);
      break;
    case View.partytimemagic:
      setMainContent(magicHTML);
      querySelector('#leagueTitle').text =
        "${sitedata.subnicknames[activeLeague]} League Party Time Magic Numbers";
      populatePartyTimeTable(subStandings[activeLeague]);
      setNotes(partytimeNotesHTML);
      break;
    }
      
}
  

void populateGamesBehindTable(List<TeamStandings> subStandings){
  TableElement table = querySelector("#standingsTable");
  subStandings.forEach((row){
    TableRowElement trow = insertCommonCells(table, row);
    trow.insertCell(5)
      ..text = (row.wins + row.losses).toString();    
    trow.insertCell(6)
      ..text = (99 - (row.wins + row.losses)).toString();       
    trow.insertCell(7)
      ..text = row.gbLg;        
    trow.insertCell(8)
      ..text = row.gbPo.toString();
  });
  
  insertSeparatorRow(table, 6, 9); 
  
}

void populateWinningTable(List<TeamStandings> subStandings){
  TableElement table = querySelector("#standingsTable");
  subStandings.forEach((row){
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
  
  insertSeparatorRow(table, 6, 10);   
}

void populatePartyTimeTable(List<TeamStandings> subStandings){
  TableElement table = querySelector("#standingsTable");
  subStandings.forEach((row){
    TableRowElement trow = insertCommonCells(table, row);     
    for(int i = 0; i < 5; i++){
      var cell = trow.insertCell(5 + i)
        ..text = row.losing[i];
      switch (row.losing[i]){
        case "PT":
        case "X":
        case "MW":
          cell.classes.add("redcell");
          break;
        default:
          cell.classes.add("greencell");
          break;
      }
    }
  });
  
  insertSeparatorRow(table, 6, 10);   
}

TableRowElement insertCommonCells(TableElement table, 
  TeamStandings row){
  TableRowElement trow = table.addRow();
  AnchorElement teamLink = new AnchorElement(
    href:"https://www.blaseball.com/team/${row.id}")
    ..text = row.nickname
    ..target = "_new";
  
  var cell = trow.insertCell(0);
  cell.classes.add('tblteam');
  cell.children.add(teamLink);
  
  trow.insertCell(1)
    ..text = row.division;
  trow.insertCell(2)
    ..text = (row.favor + 1).toString();
  trow.insertCell(3)
    ..text = row.wins.toString();
  trow.insertCell(4)
    ..text = row.losses.toString();   

  return trow;

}

void insertSeparatorRow(TableElement table, int row, int columns){
  var sepRow = table.insertRow(row);
  sepRow.insertCell(0)
    ..text = '&nbsp;'
    ..colSpan = columns
    ..classes.add('sepRow');  
}

void setMainContent(String html){
  querySelector('#mncntnt').children.clear();
  querySelector('#mncntnt').innerHtml = html;
}

void setNotes(String html){
  querySelector('#notes').children.clear();
  querySelector('#notes').innerHtml = html;  
}