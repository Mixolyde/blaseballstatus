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
      var cell = trow.insertCell(0)
        ..text = row['nickname'];
      cell.attributes['class'] = "tblteam";
      cell = trow.insertCell(1)
        ..text = row['division'];
      cell = trow.insertCell(2)
        ..text = row['wins'].toString();
      cell = trow.insertCell(3)
        ..text = row['losses'].toString();        
    });
    
    //<tr> <td class="sepRow" colspan="11">&nbsp;</td> </tr>

  });
  
}

Future<void> getContentPages() async {
  standingsHTML = await HttpRequest.getString('standings.html');
  wildStandings = json.decode(await HttpRequest.getString('wildstandings.json'));
}

void selectLeague1(MouseEvent event) => clickLeague(1);
void selectLeague2(MouseEvent event) => clickLeague(2);

void clickLeague(int league){
  print("League $league clicked");
}