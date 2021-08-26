import 'dart:convert';
import 'package:intl/intl.dart';

enum View {about, winsbehind, winningmagic, partytimemagic, chances, postseason, bracket}

class CurrentView {
  // 0 or 1
  int activeLeague = 0;
  View activeView  = View.winsbehind;
  bool groupByDiv = false;
  
  CurrentView({this.activeLeague = 0, this.activeView = View.winsbehind,
    this.groupByDiv = false});
  
  CurrentView.fromHash(String hash){
    print("Restoring view from hash: $hash");
    //#activeLeague=0&activeView=0&groupByDiv=false
    RegExp exp = RegExp(r"#activeLeague=([0|1])&activeView=(\w+)&groupByDiv=(\w+)");
    Match? match = exp.firstMatch(hash);
    if(match != null){
      //print(match.groups([1, 2, 3]));
      activeLeague = int.parse(match.group(1) ?? "0");
      activeView = View.values[int.parse(match.group(2) ?? "1")];
      groupByDiv = match.group(3) == "true" ? true : false;
    } else {
      print("$hash did not match regex");
      activeLeague = 0;
      activeView = View.values[1];
      groupByDiv = false;
    }
  }

  factory CurrentView.fromJson(Map<String, dynamic> json){
    //key1: json["key1"] == null ? null : json["key1"],
    return CurrentView(
      activeLeague: json['activeLeague'] as int,
      activeView: View.values[json['activeView']],
      groupByDiv: json['groupByDiv'] == null ? false : 
        json['groupByDiv'] as bool,
    );
  }

  Map toJson() => {
    'activeLeague': activeLeague,
    'activeView': activeView.index,
    'groupByDiv': groupByDiv,
  };
  
  String toHash() => "#activeLeague=${activeLeague}" +
    "&activeView=${activeView.index}" +
    "&groupByDiv=${groupByDiv}";
  
  String toString() => "League: $activeLeague View: $activeView GroupByDiv: $groupByDiv";
}
