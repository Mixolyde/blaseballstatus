import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:blaseballstatus/database_api.dart';

var standingsHTML;
List<dynamic> sub1Standings;
List<dynamic> sub2Standings;
SiteData sitedata;
int activeLeague = 1;

void main() {
  getContentPages().then((v) {
    print("Got Content Pages and data");
    //set last update time
    querySelector('#lastUpdate').text = sitedata.lastUpdate;
    querySelector('#pickLeague1').onClick.listen(selectLeague1);
    querySelector('#pickLeague2').onClick.listen(selectLeague2);
    clickLeague(1);
  });
}

Future<void> getContentPages() async {
  sitedata = SiteData.fromJson(json.decode(await HttpRequest.getString('sitedata.json')));
  print(sitedata);
  standingsHTML = await HttpRequest.getString('standings.html');
  sub1Standings = json.decode(await HttpRequest.getString('${sitedata.sub1id}.json'));
  sub2Standings = json.decode(await HttpRequest.getString('${sitedata.sub2id}.json'));
}

void selectLeague1(MouseEvent event) => clickLeague(1);
void selectLeague2(MouseEvent event) => clickLeague(2);

void clickLeague(int league){
  print("League $league clicked");
  querySelector('#mncntnt').children.clear();
  querySelector('#mncntnt').innerHtml = standingsHTML;
  if(league == 1){
    querySelector('#leagueTitle').text = sitedata.sub1name;
    populateStandingsTable(sub1Standings);
  } else {
    querySelector('#leagueTitle').text = sitedata.sub2name;
    populateStandingsTable(sub2Standings);
  }
}

void populateStandingsTable(List<dynamic> subStandings){
  TableElement table = querySelector("#standingsTable");
  subStandings.forEach((row){
    TableRowElement trow = table.addRow();
    trow.insertCell(0)
      ..text = row['nickname']
      ..classes.add('tblteam');
    trow.insertCell(1)
      ..text = row['division'];
    trow.insertCell(2)
      ..text = row['wins'].toString();
    trow.insertCell(3)
      ..text = row['losses'].toString();        
    trow.insertCell(4)
      ..text = row['gbLg'].toString();        
    trow.insertCell(5)
      ..text = row['gbPo'].toString();        
    for(int i = 1; i < 6; i++){
      trow.insertCell(5 + i)
        ..text = row["po$i"].toString();        
    }
      
  });
  
  var sepRow = table.insertRow(6);
  sepRow.insertCell(0)
    ..text = '&nbsp;'
    ..colSpan = 11
    ..classes.add('sepRow');  
  
}