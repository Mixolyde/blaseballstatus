import 'dart:async';
import 'dart:convert';
import 'dart:html';

var standingsHTML;
List<dynamic> wildStandings;

void main() {
  getContentPages().then((v) {
    print("Got Content Pages");
    querySelector('#mncntnt').children.clear();
    querySelector('#mncntnt').innerHtml = standingsHTML;
    querySelector('#pickLeague1').onClick.listen(selectLeague1);
    querySelector('#pickLeague2').onClick.listen(selectLeague2);
    TableElement table = querySelector("#standingsTable");
    
//<td class="tblteam">Crabs</td>
//<td>High</td>									
//<td>26</td>
//<td>10</td>
//<td>-</td>
//<td>-</td>
//<td style="color:#008000;">75%</td>
//<td style="color:#008000;">14%</td>
//<td style="color:#008000;">3%</td>
//<td style="color:#008000;">7%</td>
//<td style="color:#008000;">&lt;1%</td>

    wildStandings.forEach((row){
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
    
    //<tr> <td class="sepRow" colspan="11">&nbsp;</td> </tr>

  });
  
}

Future<void> getContentPages() async {
  standingsHTML = await HttpRequest.getString('standings.html');
  wildStandings = json.decode(await HttpRequest.getString('aabc11a1-81af-4036-9f18-229c759ca8a9.json'));
}

void selectLeague1(MouseEvent event) => clickLeague(1);
void selectLeague2(MouseEvent event) => clickLeague(2);

void clickLeague(int league){
  print("League $league clicked");
}