import 'dart:convert';
import 'package:intl/intl.dart';

enum View { about, gamesbehind, winningmagic, partytimemagic}

class CurrentView {
  // 0 or 1
  int activeLeague;
  View activeView;
  
  CurrentView({this.activeLeague, this.activeView});
  
  factory CurrentView.fromJson(Map<String, dynamic> json){
    return CurrentView(
      activeLeague: json['activeLeague'] as int,
      activeView: View.values[json['activeView']],
    );
  }

  Map toJson() => {
    'activeLeague': activeLeague,
    'activeView': activeView.index,
  };
  
  String toString() => "League: $activeLeague View: $activeView";
}