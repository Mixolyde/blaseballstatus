import 'dart:async';
import 'dart:html';

var pickLeagueHTML;
var standingsHTML;

StreamSubscription leagueLinkSub1;
StreamSubscription leagueLinkSub2;

void main() {
  getContentPages().then((v) {
    print("Got Content Pages");
    querySelector('#mncntnt').children.clear();
    //querySelector('#mncntnt').innerHtml = pickLeagueHTML;
    //leagueLinkSub1 = querySelector('#leagueLink1').onClick.listen(selectLeague1);
    //leagueLinkSub2 = querySelector('#leagueLink2').onClick.listen(selectLeague2);
    querySelector('#mncntnt').innerHtml = standingsHTML;
  });
  
}

Future<void> getContentPages() async {
  pickLeagueHTML = await HttpRequest.getString('pickLeague.html');
  standingsHTML = await HttpRequest.getString('standings.html');
}

void selectLeague1(MouseEvent event) => clickLeague(1);
void selectLeague2(MouseEvent event) => clickLeague(2);

void clickLeague(int league){
  print("League $league clicked");
  leagueLinkSub1.cancel();
  leagueLinkSub2.cancel();
  print("League subscriptions canceled");
  querySelector('#mncntnt').children.clear();
  querySelector('#mncntnt').innerHtml = standingsHTML;
  print("Standings HTML set");
}