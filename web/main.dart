import 'dart:async';
import 'dart:html';

var standingsHTML;

void main() {
  getContentPages().then((v) {
    print("Got Content Pages");
    querySelector('#mncntnt').children.clear();
    querySelector('#mncntnt').innerHtml = standingsHTML;
    querySelector('#pickLeague1').onClick.listen(selectLeague1);
    querySelector('#pickLeague2').onClick.listen(selectLeague2);
  });
  
}

Future<void> getContentPages() async {
  standingsHTML = await HttpRequest.getString('standings.html');
}

void selectLeague1(MouseEvent event) => clickLeague(1);
void selectLeague2(MouseEvent event) => clickLeague(2);

void clickLeague(int league){
  print("League $league clicked");
}