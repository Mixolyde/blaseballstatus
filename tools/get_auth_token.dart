import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:http/http.dart';

/// Tool for fetching auth token
Future<void> main(List<String> args) async { 

  var parser = ArgParser();
  parser.addOption('email', abbr: 'e',  mandatory: true);
  parser.addOption('password', abbr: 'p',  mandatory: true);
  parser.addFlag('export', abbr: 'x', defaultsTo: false);
  var results = parser.parse(args);
  var email = results['email'];
  var password = results['password'];
  var export = results['export'];
  
  var sign_in_url = "https://api2.blaseball.com/auth/sign-in";

  Response response = await post(
    Uri.parse(sign_in_url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
    'email': email,
    'password': password,
    }),
  );
  
  stderr.writeln("Body: ${response.body}");
  stderr.writeln("StatusCode: ${response.statusCode}");
  stderr.writeln("set-cookie: ${response.headers['set-cookie'] ?? ''}");
  if (response.statusCode == 201) {
    var authCookie = response.headers['set-cookie']!.split(";")[0];
    if (export){
      print ("export AUTH_TOKEN='$authCookie'");
    } else {
      print("authCookie: $authCookie");
    }
  } else {
    print("Error retrieving auth cookie!");
  }
  
}
