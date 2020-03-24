import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/services.dart';
import 'settings.dart';
import 'upload.dart';
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
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(
        context,
          MaterialPageRoute(builder: (context) => Settings()),
        );
      }, 
      child: Icon(Icons.settings), backgroundColor: Color.fromARGB(255, 67, 230, 110)),
      
      
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
      controller.scannedDataStream.listen((scanData) {
        setState(() {
          qrText = scanData;
          if (alertBox == false){
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
          content: new Text("User "+data+" has been awarded points."),
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