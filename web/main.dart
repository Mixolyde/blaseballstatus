import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:blaseballstatus/calc_stats.dart';
import 'package:blaseballstatus/current_view.dart';
import 'package:blaseballstatus/database_api.dart';
import 'package:blaseballstatus/s3_api.dart' as s3;
import 'package:blaseballstatus/site_objects.dart';

import 'package:cron/cron.dart';

String aboutHTML;
String chancesNotesHTML;
String gamesbehindHTML;
String magicHTML;
String partytimeNotesHTML;
String postseasonHTML;
String winningNotesHTML;
SiteData sitedata;

CurrentView currentView = new CurrentView();

void main() {
  getContentPages().then((v) {
    print("Retrieved content pages and data");
    
    CurrentView loadedView = loadCurrentView();
    print("LoadedView: $loadedView");

    currentView.activeLeague = loadedView.activeLeague;
    selectLeagueButton(loadedView.activeLeague);
    
    currentView.groupByDiv = loadedView.groupByDiv;
    toggleGroupByDivision(loadedView.groupByDiv);
    
    clickView(loadedView.activeView);
    
    addListeners();
    
    //setup auto refresh
    var cron = new Cron();
    //Every five minutes from 20-50 after Mon - Sat
    cron.schedule(new Schedule.parse('1,21,26,31,36,41,46,51 * * * 1-6'), () async {
      if(!document.hidden && 
        currentView.activeView != View.about){
        refreshData();
      }
    });
  });
}

Future<void> getContentPages() async {
  sitedata = await s3.getSiteData();
  print("Initial sitedata: $sitedata");
  setSeasonDay(sitedata.season + 1, sitedata.day + 1);
  subStandings = await s3.getSubStandings(sitedata);
  
  querySelector('#lastUpdate').text = sitedata.lastUpdate;
  querySelector('#pickLeague1').text = sitedata.subnicknames[0];
  querySelector('#pickLeague2').text = sitedata.subnicknames[1];

  gamesbehindHTML = await HttpRequest.getString('gamesbehind.html');
  setMainContent(gamesbehindHTML);
  aboutHTML = await HttpRequest.getString('about.html');
  magicHTML = await HttpRequest.getString('magic.html');
  chancesNotesHTML = await HttpRequest.getString('chancesNotes.html');
  partytimeNotesHTML = await HttpRequest.getString('partytimeNotes.html');
  postseasonHTML = await HttpRequest.getString('postseason.html');
  winningNotesHTML = await HttpRequest.getString('winningNotes.html');
}

Future<void> refreshData() async{
  //get all data for displaying
  print('Refreshing data');
  sitedata = await s3.getSiteData();
  print("Updated sitedata: $sitedata");
  
  setSeasonDay(sitedata.season + 1, sitedata.day + 1);
  subStandings = await s3.getSubStandings(sitedata);
  
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
  case View.chances:
    populateChancesTable(subStandings[currentView.activeLeague]);
    break;    
  case View.postseason:
    populatePostseasonTable(subStandings);
    break; 
  }
  
  querySelector('#lastUpdate').text = sitedata.lastUpdate;

}

void setSeasonDay(int season, int day){
  if(day < 100){
    querySelector('.wkinfo').text = 
      "Season $season: Day $day";
  } else {
    querySelector('.wkinfo').text = 
      "Season $season: Postseason";    
  }
}

void addListeners(){
  querySelector('#pickLeague1').onClick.listen(selectLeague1);
  querySelector('#pickLeague2').onClick.listen(selectLeague2);
  
  querySelector('#viewGamesBehind').onClick.listen(selectViewGB);
  querySelector('#viewChances').onClick.listen(selectViewC);  
  querySelector('#viewWinningNumbers').onClick.listen(selectViewW);
  querySelector('#viewPartyTimeNumbers').onClick.listen(selectViewPT);
  querySelector('#viewAbout').onClick.listen(selectViewAbout);
  querySelector('#viewPostseasonChances').onClick.listen(selectViewPost);
  
  querySelector('#doGroup').onClick.listen(clickGroupByDivision);
}

void selectLeague1(MouseEvent event) => clickLeague(0);
void selectLeague2(MouseEvent event) => clickLeague(1);

void clickLeague(int league){
  if (league == currentView.activeLeague){
    return;
  }
  currentView.activeLeague = league;
  selectLeagueButton(league);

  saveCurrentView();
  redisplayData();
  
}

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


void selectViewAbout(MouseEvent event) => clickView(View.about);
void selectViewC(MouseEvent event) => clickView(View.chances);
void selectViewGB(MouseEvent event) => clickView(View.gamesbehind);
void selectViewPT(MouseEvent event) => clickView(View.partytimemagic);
void selectViewPost(MouseEvent event) => clickView(View.postseason);
void selectViewW(MouseEvent event) => clickView(View.winningmagic);

void clickView(View view){
  if(view == currentView.activeView){
    return;
  }
  currentView.activeView = view;
  switch(currentView.activeView){
    case View.about:
      querySelector('#viewAbout').classes
        .add('nav-button-active');
      querySelector('#viewChances').classes
        .remove('nav-button-active');        
      querySelector('#viewGamesBehind').classes
        .remove('nav-button-active');
      querySelector('#viewWinningNumbers').classes
        .remove('nav-button-active');
      querySelector('#viewPartyTimeNumbers').classes
        .remove('nav-button-active');
      querySelector('#viewPostseasonChances').classes
        .remove('nav-button-active');        

      break;    
    case View.chances:
      querySelector('#viewAbout').classes
        .remove('nav-button-active');
      querySelector('#viewChances').classes
        .add('nav-button-active');        
      querySelector('#viewGamesBehind').classes
        .remove('nav-button-active');
      querySelector('#viewWinningNumbers').classes
        .remove('nav-button-active');
      querySelector('#viewPartyTimeNumbers').classes
        .remove('nav-button-active');
      querySelector('#viewPostseasonChances').classes
        .remove('nav-button-active');        

      break;       
    case View.gamesbehind:
      querySelector('#viewAbout').classes
        .remove('nav-button-active');
      querySelector('#viewChances').classes
        .remove('nav-button-active'); 
      querySelector('#viewGamesBehind').classes
        .add('nav-button-active');
      querySelector('#viewWinningNumbers').classes
        .remove('nav-button-active');
      querySelector('#viewPartyTimeNumbers').classes
        .remove('nav-button-active');
      querySelector('#viewPostseasonChances').classes
        .remove('nav-button-active');        

      break;
    case View.winningmagic:
      querySelector('#viewAbout').classes
        .remove('nav-button-active');
      querySelector('#viewChances').classes
        .remove('nav-button-active');
      querySelector('#viewGamesBehind').classes
        .remove('nav-button-active');
      querySelector('#viewWinningNumbers').classes
        .add('nav-button-active');
      querySelector('#viewPartyTimeNumbers').classes
        .remove('nav-button-active');      
      querySelector('#viewPostseasonChances').classes
        .remove('nav-button-active');        
      
      break;
    case View.partytimemagic:
      querySelector('#viewAbout').classes
        .remove('nav-button-active');
      querySelector('#viewChances').classes
        .remove('nav-button-active');
      querySelector('#viewGamesBehind').classes
        .remove('nav-button-active');
      querySelector('#viewWinningNumbers').classes
        .remove('nav-button-active');
      querySelector('#viewPartyTimeNumbers').classes
        .add('nav-button-active');
      querySelector('#viewPostseasonChances').classes
        .remove('nav-button-active');        

      break;
    case View.postseason:
      querySelector('#viewAbout').classes
        .remove('nav-button-active');
      querySelector('#viewChances').classes
        .remove('nav-button-active');        
      querySelector('#viewGamesBehind').classes
        .remove('nav-button-active');
      querySelector('#viewWinningNumbers').classes
        .remove('nav-button-active');
      querySelector('#viewPartyTimeNumbers').classes
        .remove('nav-button-active');
      querySelector('#viewPostseasonChances').classes
        .add('nav-button-active');        
  }
  
  saveCurrentView();
  redisplayData();

}

void clickGroupByDivision(MouseEvent event) {

  if(currentView.groupByDiv){
    currentView.groupByDiv = false;
    toggleGroupByDivision(false);
  } else {
    currentView.groupByDiv = true;
    toggleGroupByDivision(true);
  }
  
  saveCurrentView();
  redisplayData();
}

void toggleGroupByDivision(bool groupByDiv){
  var groupButton = querySelector('#doGroup');
  if(groupByDiv){
    groupButton.classes.add('nav-button-active');
  } else {
    groupButton.classes.remove('nav-button-active');
  }
}

void redisplayData(){
  switch(currentView.activeView){
  case View.about:
    setMainContent(aboutHTML); 
    populateAboutPageData();
    break;
  case View.gamesbehind:
    setMainContent(gamesbehindHTML);
    querySelector('#leagueTitle').text = 
      sitedata.subnicknames[currentView.activeLeague]; 
    populateGamesBehindTable(subStandings[currentView.activeLeague]);
    break;
  case View.chances:
    setMainContent(magicHTML);
    querySelector('#leagueTitle').text = 
      "${sitedata.subnicknames[currentView.activeLeague]} League Playoff Chances";
    populateChancesTable(subStandings[currentView.activeLeague]);
    setNotes(chancesNotesHTML);
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
  case View.postseason:
    setMainContent(postseasonHTML);
    querySelector('#leagueTitle').text =
      "Internet League Blaseball Post Season Chances";
    populatePostseasonTable(subStandings);
    break;  
  }
}
  

void populateGamesBehindTable(List<TeamStandings> subStandings){
  TableElement table = querySelector("#standingsTable");
  List<TeamStandings> standings = subStandings.toList();
  if(currentView.groupByDiv == true){
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
      ..text = row.gbWc.toString();
  });
  
  if(currentView.groupByDiv == true){
    insertSeparatorRow(table, 7, 9); 
  } else {
    insertSeparatorRow(table, 6, 9); 
  }
  
}

void populateChancesTable(List<TeamStandings> subStandings){
  TableElement table = querySelector("#standingsTable");
  List<TeamStandings> standings = subStandings.toList();
  if(currentView.groupByDiv == true){
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
  
  if(currentView.groupByDiv == true){
    insertSeparatorRow(table, 7, 10); 
  } else {
    insertSeparatorRow(table, 6, 10); 
  }
}

void populatePostseasonTable(List<List<TeamStandings>> allStandings){
  TableElement table = querySelector("#standingsTable");
  List<TeamStandings> standings = new List<TeamStandings>();
  standings.addAll(allStandings[0]);
  standings.addAll(allStandings[1]);

  standings.sort((a, b) {
    if(currentView.groupByDiv){
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
  
  if(currentView.groupByDiv == true){
    insertSeparatorRow(table, 7, 11); 
    insertSeparatorRow(table, 13, 11); 
    insertSeparatorRow(table, 19, 11); 
  } 
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

void populateWinningTable(List<TeamStandings> subStandings){
  TableElement table = querySelector("#standingsTable");
  List<TeamStandings> standings = subStandings.toList();
  if(currentView.groupByDiv == true){
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
  
  if(currentView.groupByDiv == true){
    insertSeparatorRow(table, 7, 10); 
  } else {
    insertSeparatorRow(table, 6, 10); 
  }
}

void populatePartyTimeTable(List<TeamStandings> subStandings){
  TableElement table = querySelector("#standingsTable");
  List<TeamStandings> standings = subStandings.toList();
  if(currentView.groupByDiv == true){
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
  
  if(currentView.groupByDiv == true){
    insertSeparatorRow(table, 7, 10); 
  } else {
    insertSeparatorRow(table, 6, 10); 
  }
}

void populateAboutPageData(){
  OListElement tbList = querySelector('#tiebreakerlist');
  if(tbList.children != null){
    tbList.children.clear();
  }
  List<TeamStandings> allStandings = new List<TeamStandings>();
    allStandings.addAll(subStandings[0]);
    allStandings.addAll(subStandings[1]);      
  for(int favor = 0; favor < 20; favor++){
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
  trow.insertCell(4 + leagueAdjust)
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
    view.groupByDiv = false;
    return view;
  }
}

