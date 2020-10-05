import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:blaseballstatus/calc_stats.dart';
import 'package:blaseballstatus/current_view.dart';
import 'package:blaseballstatus/database_api.dart';

import 'package:cron/cron.dart';

String aboutHTML;
String gamesbehindHTML;
String magicHTML;
String winningNotesHTML;
String partytimeNotesHTML;
SimulationData simData;
SiteData sitedata;

CurrentView currentView = new CurrentView();

void main() {
  getContentPages().then((v) {
    print("Retrieved content pages and data");
    
    CurrentView loadedView = loadCurrentView();
    
    print("LoadedView: $loadedView");

    currentView.activeLeague = loadedView.activeLeague;
    selectLeagueButton(loadedView.activeLeague);
    
    clickView(loadedView.activeView);
    
    addListeners();
    
    //setup auto refresh
    var cron = new Cron();
    //Every five minutes from 20-50 after Mon - Sat
    cron.schedule(new Schedule.parse('20,25,30,35,40,45,50 * * * 1-6'), () async {
      if(!document.hidden && 
        currentView.activeView != View.about){
        refreshData();
      }
    });
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
  aboutHTML = await HttpRequest.getString('about.html');
  magicHTML = await HttpRequest.getString('magic.html');
  winningNotesHTML = await HttpRequest.getString('winningNotes.html');
  partytimeNotesHTML = await HttpRequest.getString('partytimeNotes.html');
}

Future<void> refreshData() async{
  //get all data for displaying
  String lastUpdate = getUpdateTime();
  print('Refreshing data at $lastUpdate');
  simData = await getSimulationData();
  sitedata = await calcSiteData();
  await calcStats(simData.season);
  
  TableElement standingsTable = querySelector('#standingsTable');
  while (standingsTable.rows.length > 2){
    standingsTable.deleteRow(2);
  }
  
  switch(currentView.activeView){
  case View.gamesbehind:
    populateGamesBehindTable(subStandings[currentView.activeLeague]);
    break;
  case View.winningmagic:
    populateWinningTable(subStandings[currentView.activeLeague]);
    break;
  case View.partytimemagic:
    populatePartyTimeTable(subStandings[currentView.activeLeague]);
    break;
  }
  
  querySelector('#lastUpdate').text = sitedata.lastUpdate;

}

void addListeners(){
  querySelector('#pickLeague1').onClick.listen(selectLeague1);
  querySelector('#pickLeague2').onClick.listen(selectLeague2);
  
  querySelector('#viewGamesBehind').onClick.listen(selectViewGB);
  querySelector('#viewWinningNumbers').onClick.listen(selectViewW);
  querySelector('#viewPartyTimeNumbers').onClick.listen(selectViewPT);
  querySelector('#viewAbout').onClick.listen(selectViewAbout);
}

void selectLeague1(MouseEvent event) => clickLeague(0);
void selectLeague2(MouseEvent event) => clickLeague(1);

void selectLeagueButton(int league) {
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
}

void clickLeague(int league){
  if (league == currentView.activeLeague){
    return;
  }
  currentView.activeLeague = league;
  saveCurrentView();
  selectLeagueButton(league);

  redisplayData();
  
}

void selectViewAbout(MouseEvent event) => clickView(View.about);
void selectViewGB(MouseEvent event) => clickView(View.gamesbehind);
void selectViewW(MouseEvent event) => clickView(View.winningmagic);
void selectViewPT(MouseEvent event) => clickView(View.partytimemagic);

void clickView(View view){
  if(view == currentView.activeView){
    return;
  }
  currentView.activeView = view;
  saveCurrentView();
  switch(currentView.activeView){
    case View.about:
      querySelector('#viewAbout').classes
        .add('nav-button-active');
      querySelector('#viewGamesBehind').classes
        .remove('nav-button-active');
      querySelector('#viewWinningNumbers').classes
        .remove('nav-button-active');
      querySelector('#viewPartyTimeNumbers').classes
        .remove('nav-button-active');
        
      // TODO: display tiebreakerlist
      //OListElement tbList = querySelector('#tiebreakerlist');
      

      break;    
    case View.gamesbehind:
      querySelector('#viewAbout').classes
        .remove('nav-button-active');
      querySelector('#viewGamesBehind').classes
        .add('nav-button-active');
      querySelector('#viewWinningNumbers').classes
        .remove('nav-button-active');
      querySelector('#viewPartyTimeNumbers').classes
        .remove('nav-button-active');

      break;
    case View.winningmagic:
      querySelector('#viewAbout').classes
        .remove('nav-button-active');
      querySelector('#viewGamesBehind').classes
        .remove('nav-button-active');
      querySelector('#viewWinningNumbers').classes
        .add('nav-button-active');
      querySelector('#viewPartyTimeNumbers').classes
        .remove('nav-button-active');      
      
      break;
    case View.partytimemagic:
      querySelector('#viewAbout').classes
        .remove('nav-button-active');
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
    switch(currentView.activeView){
    case View.about:
      setMainContent(aboutHTML); 
      break;
    case View.gamesbehind:
      setMainContent(gamesbehindHTML);
      querySelector('#leagueTitle').text = 
        sitedata.subnicknames[currentView.activeLeague]; 
      populateGamesBehindTable(subStandings[currentView.activeLeague]);
      break;
    case View.winningmagic:
      setMainContent(magicHTML);
      querySelector('#leagueTitle').text =
        "${sitedata.subnicknames[currentView.activeLeague]} League Winning Magic Numbers";
      populateWinningTable(subStandings[currentView.activeLeague]);
      setNotes(winningNotesHTML);
      break;
    case View.partytimemagic:
      setMainContent(magicHTML);
      querySelector('#leagueTitle').text =
        "${sitedata.subnicknames[currentView.activeLeague]} League Party Time Magic Numbers";
      populatePartyTimeTable(subStandings[currentView.activeLeague]);
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
        ..text = row.partytime[i];
      switch (row.partytime[i]){
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

void saveCurrentView(){
  window.localStorage['current_view'] = 
    json.encode(currentView.toJson());
    
  //print("Saved Local storage ${window.localStorage['current_view']}");
}

CurrentView loadCurrentView(){
  //print("Loading Local storage ${window.localStorage['current_view']}");
  if (window.localStorage.containsKey('current_view')){
    return CurrentView.fromJson(json.decode(
      window.localStorage['current_view']));
  } else {
    CurrentView view = new CurrentView();
    view.activeLeague = 0;
    view.activeView = View.gamesbehind;
    return view;
  }
}

