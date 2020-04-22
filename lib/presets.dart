import 'package:flutter/material.dart';
import 'package:lpscan/upload.dart';
import 'main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Presets extends StatefulWidget {
  Presets({Key key})
      : super(key: key); // add param after Key key, also in line 23
  @override
  _PresetsState createState() => _PresetsState();
}

class _PresetsState extends State<Presets> {
  List names = new List();
  List points = new List();
  _getPresetsList() {
    //data
    Firestore.instance
        .collection('generalData')
        .document('presets')
        .get()
        .then((DocumentSnapshot ds) {
      // use ds as a snapshot
      List keys = ds.data.keys.toList();
      List values = ds.data.values.toList();

      setState(() {
        names = keys;
        points = values;
      });
    });
    
  }

  @override
  Widget build(BuildContext context) {
    _getPresetsList();
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.only(top: 45),
      child: Column(
        children: <Widget>[
          Row(children: [
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "< Add Presets",
                style: TextStyle(fontSize: 35),
                textAlign: TextAlign.center,
              ),
            )
          ]),
          Container(
              child: names == null
                  ? Container(
                      child: Text(
                          "No Presets are saved to the server.")) //might save local later so it can be used offline
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: names.length,
                      itemBuilder: (context, index) {
                        return Column(children: [
                          ListTile(
                              leading: IconButton(
                                  onPressed: () {
                                    _showDialog(names[index], points[index]);
                                  },
                                  icon: Icon(Icons.edit)),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    names[index],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: Text(points[index]))
                                ],
                              )),
                          Divider()
                        ]);
                      },
                    ))
        ],
      ),
    ));
  }

  void _showDialog(var name, var points) {
    String text = " ";
    bool close = false;
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Edit Preset"),
          content: new 
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(name),
              SizedBox(
                  width: 75,
                  height: 35,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: points),
                    textAlign: TextAlign.right,
                    //autofocus: true,
                  ))
            ]),
          
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("Save", style: TextStyle(color: Colors.green),),
              onPressed: () {
                Upload.preset(name, points);
                Navigator.of(context).pop();

              },
            ),
            FlatButton(
              child: Text("Cancel", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
