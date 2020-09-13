import 'dart:html';

var pickLeagueHTML;
var standingsHTML;

void main() {
  getContentPages().then((v) {
    print("Got Content Pages");
    querySelector('#mncntnt').setInnerHtml(pickLeagueHTML);
    querySelector('#leagueLink1').onClick.listen(selectLeague1);
    querySelector('#leagueLink2').onClick.listen(selectLeague2);
  });
  
}

Future<void> getContentPages() async {
  pickLeagueHTML = await HttpRequest.getString('pickLeague.html');
  //print('Pick League HTML: $pickLeagueHTML');
  standingsHTML = await HttpRequest.getString('standings.html');
}

void selectLeague1(MouseEvent event) => clickLeague(1);
void selectLeague2(MouseEvent event) => clickLeague(2);

void clickLeague(int league){
  print("League $league clicked");
  querySelector('#mncntnt').setInnerHtml(standingsHTML);
}