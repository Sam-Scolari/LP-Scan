import 'package:flutter/material.dart';
import 'main.dart';
import 'main.dart';

class Settings extends StatefulWidget {
  Settings({Key key})
      : super(key: key); // add param after Key key, also in line 23
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: <Widget>[Center(child: MaterialButton(onPressed: (){
        Navigator.push(
        context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      }, child: Text("Back"),)
      )],)
      
    );
  }
}