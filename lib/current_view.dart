import 'dart:convert';
import 'package:intl/intl.dart';

enum View { about, gamesbehind, winningmagic, partytimemagic}

class CurrentView {
  // 0 or 1
  int activeLeague;
  View activeView;
  bool groupByDiv;
  
  CurrentView({this.activeLeague, this.activeView, this.groupByDiv});
  
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
  
  String toString() => "League: $activeLeague View: $activeView GroupByDiv: $groupByDiv";
}