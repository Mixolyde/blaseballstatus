import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:blaseballstatus/database_api.dart';
import 'package:blaseballstatus/calc_stats.dart';

String gamesbehindHTML;
int activeLeague = 1;
SimulationData simData;

void main() {
  getContentPages().then((v) {
    print("Retrieved content pages and data");
    //set last update time
    querySelector('#lastUpdate').text = sitedata.lastUpdate;
    querySelector('#pickLeague1').onClick.listen(selectLeague1);
    querySelector('#pickLeague1').text = sitedata.sub1nickname;
    querySelector('#pickLeague2').onClick.listen(selectLeague2);
    querySelector('#pickLeague2').text = sitedata.sub2nickname;
    clickLeague(1);
  });
}

Future<void> getContentPages() async {
  simData = await getSimulationData();
  querySelector('.wkinfo').text = "Season ${simData.season + 1}: "
    + "Day ${simData.day + 1}";
  gamesbehindHTML = await HttpRequest.getString('gamesbehind.html');
  setMainContent(gamesbehindHTML);
  await calcStats(simData.season);
}

void selectLeague1(MouseEvent event) => clickLeague(1);
void selectLeague2(MouseEvent event) => clickLeague(2);

void clickLeague(int league){
  activeLeague = league;
  setMainContent(gamesbehindHTML);
  if(league == 1){
    querySelector('#leagueTitle').text = sitedata.sub1nickname;
    populateStandingsTable(sub1Standings);
    querySelector('#pickLeague1').classes
      .add('nav-button-active');
    querySelector('#pickLeague1').classes
      .remove('nav-button-inactive');
    querySelector('#pickLeague2').classes
      .remove('nav-button-active');
    querySelector('#pickLeague2').classes  
      .add('nav-button-inactive');
  } else {
    querySelector('#leagueTitle').text = sitedata.sub2nickname;
    populateStandingsTable(sub2Standings);
    querySelector('#pickLeague1').classes
      .remove('nav-button-active');
    querySelector('#pickLeague1').classes  
      .add('nav-button-inactive');
    querySelector('#pickLeague2').classes
      .add('nav-button-active');
    querySelector('#pickLeague2').classes  
      .remove('nav-button-inactive');
  }
}

void populateStandingsTable(List<TeamStandings> subStandings){
  TableElement table = querySelector("#standingsTable");
  subStandings.forEach((row){
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
    trow.insertCell(5)
      ..text = row.gbLg;        
    trow.insertCell(6)
      ..text = row.gbPo.toString();        
      
  });
  
  var sepRow = table.insertRow(6);
  sepRow.insertCell(0)
    ..text = '&nbsp;'
    ..colSpan = 7
    ..classes.add('sepRow');  
  
}

void setMainContent(String html){
  querySelector('#mncntnt').children.clear();
  querySelector('#mncntnt').innerHtml = html;
}