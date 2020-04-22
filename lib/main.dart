import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/services.dart';
import 'presets.dart';
import 'upload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(), //add param here and line 29
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key})
      : super(key: key); // add param after Key key, also in line 23
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int points = 1000;
  bool alertBox = false;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrText = "";
  QRViewController controller;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            _onButtonPressed();
          },
          child: Icon(Icons.arrow_upward, color: Colors.green,),
          // backgroundColor: Color.fromARGB(255, 67, 230, 110)
          ),
    );
  }

  void _onButtonPressed() {
    var names = ['N/A'];
    String _chosenValue = names[0];
    _getPresetsList() {
      //data
      Firestore.instance
          .collection('generalData')
          .document('presets')
          .get()
          .then((DocumentSnapshot ds) {
        // use ds as a snapshot
        List keys = ds.data.keys.toList();

        for(var key in keys){
          if (!names.contains(key)){
            names.add(key);
            
          }
        }
      });
      
    }
    _getPresetsList();
  
    
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
              padding: EdgeInsets.all(15),
              child: SizedBox(height: 150,child:Column(children: [
                Row(children: [
                  Text(
                    "Presets",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  Container()
                ]),
                Row(children: [
                  Text("Select a preset: "),
                  DropdownButton<String>(
                    value: _chosenValue,
                    items: names.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String value) {
                      setState(() {
                        _chosenValue = value;
                      });
                    },
                  ),
                ]),
                Row(children: [
                  RaisedButton(
                      color: Color.fromARGB(255, 67, 230, 110),
                      onPressed: () {
                        Navigator.push(
                        context,
                          MaterialPageRoute(builder: (context) => Presets()),
                        );
                      },
                      child: Row(children: [
                        Text("Add a preset"),
                        Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Icon(Icons.add_circle_outline))
                      ])),
                ])
              ])));
        });
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
        if (alertBox == false) {
          Upload.points(qrText, points);
          _showDialog(qrText);
        }
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  // user defined function
  void _showDialog(var data) {
    setState(() {
      alertBox = true;
    });
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Upload"),
          content: new Text("User " + data + " has been awarded points."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  alertBox = false;
                });
              },
            ),
          ],
        );
      },
    );
  }
}
