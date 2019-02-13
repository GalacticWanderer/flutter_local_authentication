import 'package:flutter/material.dart';
import 'package:flutter_local_authentication/screens/local_auth_page.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter local authentication',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        accentColor: Colors.amberAccent
      ),
      home: LocalAuth(),
    );
  }
}
