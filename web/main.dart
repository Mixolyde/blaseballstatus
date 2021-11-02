import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:blaseballstatus/calc_stats.dart';
import 'package:blaseballstatus/current_view.dart';
import 'package:blaseballstatus/database_api.dart';
import 'package:blaseballstatus/s3_api.dart' as s3;
import 'package:blaseballstatus/site_objects.dart';
import 'package:blaseballstatus/html/populate_tables.dart';

import 'package:cron/cron.dart';

late String aboutHTML;
late String bracketHTML;
late String chancesNotesHTML;
late String winsbehindHTML;
late String magicHTML;
late String partytimeNotesHTML;
late String postseasonHTML;
late String winningNotesHTML;
late SiteData sitedata;

CurrentView currentView = CurrentView();
List<PlayoffBracketEntry> entries = [];

void main() {
  apiUrl = 'https://cors-proxy.blaseball-reference.com/';
  getContentPages().then((v) {
    print('Retrieved content pages and data');
    
    if(window.location.hash.length > 2){
      currentView = CurrentView.fromHash(window.location.hash);
      print('Loaded view from hash: $currentView');
      replaceViewState();
    } else {
      // else, load from disk if it exists
      currentView = loadCurrentView();
      print('Loaded view from storage: $currentView');
      replaceViewState();
    }

    selectLeagueButton();
    selectGroupByDivision();
    selectViewButton();
    redisplayData();
    
    addListeners();
    
    //setup auto refresh
    var cron = Cron();
    //Every five minutes from 20-50 after Mon - Sat
    cron.schedule(Schedule.parse('1,21,26,31,36,41,46,51 * * * 1-6'), () async {
      if(!(document.hidden ?? true) && 
        currentView.activeView != View.about){
        await refreshData();
      }
    });
  });
}

Future<void> getContentPages() async {
  sitedata = await s3.getSiteData();
  
  print('Initial sitedata: $sitedata');
  setSeasonDay(sitedata.season + 1, sitedata.day + 1);
  subStandings = await s3.getSubStandings(sitedata);

  entries = await s3.getPlayoffBracketEntries();
  
  querySelector('#lastUpdate')!.text = sitedata.lastUpdate;
  querySelector('#pickLeague1')!.text = sitedata.subnicknames[0];
  querySelector('#pickLeague2')!.text = sitedata.subnicknames[1];

  if(sitedata.leagueWildCards){
    winsbehindHTML = await HttpRequest.getString('winsbehind_wc.html');
    setMainContent(winsbehindHTML);
    magicHTML = await HttpRequest.getString('magic_wc.html');
    postseasonHTML = await HttpRequest.getString('postseason_wc.html');
  } else {
    winsbehindHTML = await HttpRequest.getString('winsbehind.html');
    setMainContent(winsbehindHTML);
    magicHTML = await HttpRequest.getString('magic.html');
    postseasonHTML = await HttpRequest.getString('postseason.html');
  }
  aboutHTML = await HttpRequest.getString('about.html');
  bracketHTML = await HttpRequest.getString('bracket.html');
  chancesNotesHTML = await HttpRequest.getString('chancesNotes.html');
  partytimeNotesHTML = await HttpRequest.getString('partytimeNotes.html');
  winningNotesHTML = await HttpRequest.getString('winningNotes.html');
}

Future<void> refreshData() async{
  //get all data for displaying
  print('Refreshing data');
  sitedata = await s3.getSiteData();
  print('Updated sitedata: $sitedata');
  
  setSeasonDay(sitedata.season + 1, sitedata.day + 1);
  subStandings = await s3.getSubStandings(sitedata);
  
  entries = await s3.getPlayoffBracketEntries();
  
  var standingsTable = querySelector('#standingsTable') as TableElement?;
  if(standingsTable != null){
    while (standingsTable.rows.length > 2){
      standingsTable.deleteRow(2);
    }
  }
  
  switch(currentView.activeView){
  case View.winsbehind:
    populateWinsBehindTable(subStandings[currentView.activeLeague], currentView.groupByDiv);
    break;
  case View.winningmagic:
    populateWinningTable(subStandings[currentView.activeLeague], currentView.groupByDiv);
    break;
  case View.partytimemagic:
    populatePartyTimeTable(subStandings[currentView.activeLeague], currentView.groupByDiv);
    break;
  case View.chances:
    populateChancesTable(subStandings[currentView.activeLeague], currentView.groupByDiv);
    break;    
  case View.postseason:
    populatePostseasonTable(subStandings, currentView.groupByDiv, sitedata);
    break; 
  case View.bracket:
    populatePlayoffBracket(entries);
    break;    
  default:
    break;
  }
  
  querySelector('#lastUpdate')!.text = sitedata.lastUpdate;

}

void setSeasonDay(int season, int day){
  if(day < 100){
    querySelector('.wkinfo')!.text = 
      'Season $season: Day $day';
  } else {
    querySelector('.wkinfo')!.text = 
      'Season $season: Day $day (Postseason)';    
  }
}

void addListeners(){
  window.onPopState.listen(handlePopState);
  
  querySelector('#pickLeague1')!.onClick.listen(selectLeague1);
  querySelector('#pickLeague2')!.onClick.listen(selectLeague2);
  
  querySelector('#viewWinsBehind')!.onClick.listen(selectViewGB);
  querySelector('#viewChances')!.onClick.listen(selectViewC);  
  querySelector('#viewWinningNumbers')!.onClick.listen(selectViewW);
  querySelector('#viewPartyTimeNumbers')!.onClick.listen(selectViewPT);
  querySelector('#viewAbout')!.onClick.listen(selectViewAbout);
  querySelector('#viewPostseasonChances')!.onClick.listen(selectViewPost);
  //querySelector('#viewPlayoffBracket')!.onClick.listen(selectViewBracket);
  
  querySelector('#doGroup')!.onClick.listen(clickGroupByDivision);
}

void handlePopState(PopStateEvent event){
  //print("PopStateEvent: ${event.toString()} ${event.type.toString()} ${event.timeStamp.toString()} ");
  if(event.state != null){
    print('State: ${event.state}');
    var jsonState = Map.from(event.state).map((k, v) => MapEntry<String, dynamic>(k.toString(), v));
    currentView = CurrentView.fromJson(jsonState);
    selectLeagueButton();
    selectGroupByDivision();
    selectViewButton();
    redisplayData();
  }
}

void selectLeague1(MouseEvent event) => clickLeague(0);
void selectLeague2(MouseEvent event) => clickLeague(1);

void clickLeague(int league){
  if (league == currentView.activeLeague){
    return;
  }
  currentView.activeLeague = league;
  selectLeagueButton();

  saveCurrentView();
  pushViewState();
  redisplayData();
  
}

void selectLeagueButton() {
  if(currentView.activeLeague == 0){
    querySelector('#pickLeague1')!.classes
      .add('nav-button-active');
    querySelector('#pickLeague2')!.classes
      .remove('nav-button-active');
  } else {
    querySelector('#pickLeague1')!.classes
      .remove('nav-button-active');
    querySelector('#pickLeague2')!.classes
      .add('nav-button-active');
  }
}


void selectViewAbout(MouseEvent event) => clickView(View.about);
void selectViewC(MouseEvent event) => clickView(View.chances);
void selectViewGB(MouseEvent event) => clickView(View.winsbehind);
void selectViewPT(MouseEvent event) => clickView(View.partytimemagic);
void selectViewPost(MouseEvent event) => clickView(View.postseason);
void selectViewW(MouseEvent event) => clickView(View.winningmagic);
void selectViewBracket(MouseEvent event) => clickView(View.bracket);

void clickView(View view){
  if(view == currentView.activeView){
    return;
  }
  currentView.activeView = view;
  selectViewButton();

  saveCurrentView();
  pushViewState();
  redisplayData();

}

void selectViewButton(){
  switch(currentView.activeView){
    case View.about:
      querySelector('#viewAbout')!.classes
        .add('nav-button-active');
      querySelector('#viewChances')!.classes
        .remove('nav-button-active');        
      querySelector('#viewWinsBehind')!.classes
        .remove('nav-button-active');
      querySelector('#viewWinningNumbers')!.classes
        .remove('nav-button-active');
      querySelector('#viewPartyTimeNumbers')!.classes
        .remove('nav-button-active');
      querySelector('#viewPostseasonChances')!.classes
        .remove('nav-button-active');        
      //querySelector('#viewPlayoffBracket')!.classes
      //  .remove('nav-button-active');

      break;    
    case View.chances:
      querySelector('#viewAbout')!.classes
        .remove('nav-button-active');
      querySelector('#viewChances')!.classes
        .add('nav-button-active');        
      querySelector('#viewWinsBehind')!.classes
        .remove('nav-button-active');
      querySelector('#viewWinningNumbers')!.classes
        .remove('nav-button-active');
      querySelector('#viewPartyTimeNumbers')!.classes
        .remove('nav-button-active');
      querySelector('#viewPostseasonChances')!.classes
        .remove('nav-button-active');        
      //querySelector('#viewPlayoffBracket')!.classes
      //  .remove('nav-button-active');

      break;       
    case View.winsbehind:
      querySelector('#viewAbout')!.classes
        .remove('nav-button-active');
      querySelector('#viewChances')!.classes
        .remove('nav-button-active'); 
      querySelector('#viewWinsBehind')!.classes
        .add('nav-button-active');
      querySelector('#viewWinningNumbers')!.classes
        .remove('nav-button-active');
      querySelector('#viewPartyTimeNumbers')!.classes
        .remove('nav-button-active');
      querySelector('#viewPostseasonChances')!.classes
        .remove('nav-button-active');        
      //querySelector('#viewPlayoffBracket')!.classes
      //  .remove('nav-button-active');

      break;
    case View.winningmagic:
      querySelector('#viewAbout')!.classes
        .remove('nav-button-active');
      querySelector('#viewChances')!.classes
        .remove('nav-button-active');
      querySelector('#viewWinsBehind')!.classes
        .remove('nav-button-active');
      querySelector('#viewWinningNumbers')!.classes
        .add('nav-button-active');
      querySelector('#viewPartyTimeNumbers')!.classes
        .remove('nav-button-active');      
      querySelector('#viewPostseasonChances')!.classes
        .remove('nav-button-active');        
      //querySelector('#viewPlayoffBracket')!.classes
      //  .remove('nav-button-active');
      
      break;
    case View.partytimemagic:
      querySelector('#viewAbout')!.classes
        .remove('nav-button-active');
      querySelector('#viewChances')!.classes
        .remove('nav-button-active');
      querySelector('#viewWinsBehind')!.classes
        .remove('nav-button-active');
      querySelector('#viewWinningNumbers')!.classes
        .remove('nav-button-active');
      querySelector('#viewPartyTimeNumbers')!.classes
        .add('nav-button-active');
      querySelector('#viewPostseasonChances')!.classes
        .remove('nav-button-active');        
      //querySelector('#viewPlayoffBracket')!.classes
      //  .remove('nav-button-active');

      break;
    case View.postseason:
      querySelector('#viewAbout')!.classes
        .remove('nav-button-active');
      querySelector('#viewChances')!.classes
        .remove('nav-button-active');        
      querySelector('#viewWinsBehind')!.classes
        .remove('nav-button-active');
      querySelector('#viewWinningNumbers')!.classes
        .remove('nav-button-active');
      querySelector('#viewPartyTimeNumbers')!.classes
        .remove('nav-button-active');
      querySelector('#viewPostseasonChances')!.classes
        .add('nav-button-active');
      //querySelector('#viewPlayoffBracket')!.classes
      //  .remove('nav-button-active');
      
      break;
    case View.bracket:
      querySelector('#viewAbout')!.classes
        .remove('nav-button-active');
      querySelector('#viewChances')!.classes
        .remove('nav-button-active');        
      querySelector('#viewWinsBehind')!.classes
        .remove('nav-button-active');
      querySelector('#viewWinningNumbers')!.classes
        .remove('nav-button-active');
      querySelector('#viewPartyTimeNumbers')!.classes
        .remove('nav-button-active');
      querySelector('#viewPostseasonChances')!.classes
        .remove('nav-button-active');
      //querySelector('#viewPlayoffBracket')!.classes
      //  .add('nav-button-active');
      
      break;
  }  
}

void clickGroupByDivision(MouseEvent event) {

  if(currentView.groupByDiv){
    currentView.groupByDiv = false;
    selectGroupByDivision();
  } else {
    currentView.groupByDiv = true;
    selectGroupByDivision();
  }
  
  saveCurrentView();
  pushViewState();
  redisplayData();
}

void selectGroupByDivision(){
  var groupButton = querySelector('#doGroup')!;
  if(currentView.groupByDiv){
    groupButton.classes.add('nav-button-active');
  } else {
    groupButton.classes.remove('nav-button-active');
  }
}

void redisplayData(){
  switch(currentView.activeView){
  case View.about:
    setMainContent(aboutHTML); 
    populateAboutPageData(subStandings);
    break;
  case View.winsbehind:
    setMainContent(winsbehindHTML);
    querySelector('#leagueTitle')!.text = 
      sitedata.subnicknames[currentView.activeLeague]; 
    populateWinsBehindTable(subStandings[currentView.activeLeague], currentView.groupByDiv);
    break;
  case View.chances:
    setMainContent(magicHTML);
    querySelector('#leagueTitle')!.text = 
      '${sitedata.subnicknames[currentView.activeLeague]} League Playoff Chances';
    populateChancesTable(subStandings[currentView.activeLeague], currentView.groupByDiv);
    setNotes(chancesNotesHTML);
    break;    
  case View.winningmagic:
    setMainContent(magicHTML);
    querySelector('#leagueTitle')!.text =
      '${sitedata.subnicknames[currentView.activeLeague]} League Winning Magic Numbers';
    populateWinningTable(subStandings[currentView.activeLeague], currentView.groupByDiv);
    setNotes(winningNotesHTML);
    break;
  case View.partytimemagic:
    setMainContent(magicHTML);
    querySelector('#leagueTitle')!.text =
      '${sitedata.subnicknames[currentView.activeLeague]} League Party Time Magic Numbers';
    populatePartyTimeTable(subStandings[currentView.activeLeague], currentView.groupByDiv);
    setNotes(partytimeNotesHTML);
    break;
  case View.postseason:
    setMainContent(postseasonHTML);
    querySelector('#leagueTitle')!.text =
      'Internet League Blaseball Post Season Chances';
    populatePostseasonTable(subStandings, currentView.groupByDiv, sitedata);
    break;  
  case View.bracket:
    setMainContent(bracketHTML);
    populatePlayoffBracket(entries);
    break;
  }

}

void pushViewState(){
  //update URL with popstate
  window.history.pushState(currentView.toJson(), '', 
    currentView.toHash());
}

void replaceViewState(){
  //update URL with popstate
  window.history.replaceState(currentView.toJson(), '', 
    currentView.toHash());
}
  
void setMainContent(String html){
  querySelector('#mncntnt')!.children.clear();
  querySelector('#mncntnt')!.innerHtml = html;
}

void setNotes(String html){
  querySelector('#notes')!.children.clear();
  querySelector('#notes')!.innerHtml = html;  
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
      window.localStorage['current_view']!));
  } else {
    var view = CurrentView();
    view.activeLeague = 0;
    view.activeView = View.winsbehind;
    view.groupByDiv = false;
    return view;
  }
}

