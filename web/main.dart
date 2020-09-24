import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:blaseballstatus/database_api.dart';
import 'package:blaseballstatus/calc_stats.dart';

enum View { gamesbehind, winningmagic, partytimemagic}


String gamesbehindHTML;
String winningHTML;
String partytimeHTML;
int activeLeague;
View activeView = View.gamesbehind;
SimulationData simData;
SiteData sitedata;

void main() {
  getContentPages().then((v) {
    print("Retrieved content pages and data");

    clickLeague(1);
    
    addListeners();
  });
}

Future<void> getContentPages() async {
  simData = await getSimulationData();
  querySelector('.wkinfo').text = "Season ${simData.season + 1}: "
    + "Day ${simData.day + 1}";
  sitedata = await calcSiteData();
  querySelector('#lastUpdate').text = sitedata.lastUpdate;
  querySelector('#pickLeague1').text = sitedata.sub1nickname;
  querySelector('#pickLeague2').text = sitedata.sub2nickname;

  gamesbehindHTML = await HttpRequest.getString('gamesbehind.html');
  setMainContent(gamesbehindHTML);
  await calcStats(simData.season);
  winningHTML = await HttpRequest.getString('winning.html');
  partytimeHTML = await HttpRequest.getString('winning.html');
}

void addListeners(){
  querySelector('#pickLeague1').onClick.listen(selectLeague1);
  querySelector('#pickLeague2').onClick.listen(selectLeague2);
  
  querySelector('#viewGamesBehind').onClick.listen(selectViewGB);
  querySelector('#viewWinningNumbers').onClick.listen(selectViewW);
  querySelector('#viewPartyTimeNumbers').onClick.listen(selectViewPT);
}

void selectLeague1(MouseEvent event) => clickLeague(1);
void selectLeague2(MouseEvent event) => clickLeague(2);

void clickLeague(int league){
  if (league == activeLeague){
    return;
  }
  activeLeague = league;
  setMainContent(gamesbehindHTML);
  if(league == 1){
    querySelector('#leagueTitle').text = sitedata.sub1nickname;
    querySelector('#pickLeague1').classes
      .add('nav-button-active');
    querySelector('#pickLeague2').classes
      .remove('nav-button-active');
    populateGamesBehindTable(sub1Standings);
  } else {
    querySelector('#leagueTitle').text = sitedata.sub2nickname;
    querySelector('#pickLeague1').classes
      .remove('nav-button-active');
    querySelector('#pickLeague2').classes
      .add('nav-button-active');
    populateGamesBehindTable(sub2Standings);
  }
  
  
}

void selectViewGB(MouseEvent event) => clickView(View.gamesbehind);
void selectViewW(MouseEvent event) => clickView(View.winningmagic);
void selectViewPT(MouseEvent event) => clickView(View.partytimemagic);

void clickView(View view){
  if(view == activeView){
    return;
  }
  String html;
  switch(view){
    case View.gamesbehind:
      print("Switch to gamesbehind");
      activeView = view;
      querySelector('#viewGamesBehind').classes
        .add('nav-button-active');
      querySelector('#viewWinningNumbers').classes
        .remove('nav-button-active');
      querySelector('#viewPartyTimeNumbers').classes
        .remove('nav-button-active');
      setMainContent(gamesbehindHTML);
      
      if(activeLeague == 1){
        querySelector('#leagueTitle').text = sitedata.sub1nickname;
        populateGamesBehindTable(sub1Standings);
      } else {
        querySelector('#leagueTitle').text = sitedata.sub2nickname;
        populateGamesBehindTable(sub2Standings);
      }

      break;
    case View.winningmagic:
      print("Switch to winningmagic");
      html = winningHTML;
      activeView = view;
      querySelector('#viewGamesBehind').classes
        .remove('nav-button-active');
      querySelector('#viewWinningNumbers').classes
        .add('nav-button-active');
      querySelector('#viewPartyTimeNumbers').classes
        .remove('nav-button-active');      
      setMainContent(winningHTML);
      
      if(activeLeague == 1){
        querySelector('#leagueTitle').text = sitedata.sub1nickname;
        populateWinningTable(sub1Standings);
      } else {
        querySelector('#leagueTitle').text = sitedata.sub2nickname;
        populateWinningTable(sub2Standings);
      }
      
      break;
    case View.partytimemagic:
      print("Switch to partytimemagic");
      activeView = view;
      querySelector('#viewGamesBehind').classes
        .remove('nav-button-active');
      querySelector('#viewWinningNumbers').classes
        .remove('nav-button-active');
      querySelector('#viewPartyTimeNumbers').classes
        .add('nav-button-active');
      setMainContent(partytimeHTML);
      if(activeLeague == 1){
        querySelector('#leagueTitle').text = sitedata.sub1nickname;
        populatePartyTimeTable(sub1Standings);
      } else {
        querySelector('#leagueTitle').text = sitedata.sub2nickname;
        populatePartyTimeTable(sub2Standings);
      }      
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
      trow.insertCell(5 + i)
        ..text = row.winning[i];
    }
  });
  
  insertSeparatorRow(table, 6, 10);   
}

void populatePartyTimeTable(List<TeamStandings> subStandings){
  TableElement table = querySelector("#standingsTable");
  subStandings.forEach((row){
    TableRowElement trow = insertCommonCells(table, row);     
    for(int i = 0; i < 5; i++){
      trow.insertCell(5 + i)
        ..text = row.losing[i];
    }
  });
  
  insertSeparatorRow(table, 6, 10);   
}

TableRowElement insertCommonCells(TableElement table, 
  TeamStandings row){
  TableRowElement trow = table.addRow();
  trow.insertCell(0)
    ..text = row.nickname
    ..classes.add('tblteam');
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