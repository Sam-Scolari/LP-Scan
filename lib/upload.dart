import 'package:cloud_firestore/cloud_firestore.dart';

class Upload{
  static points(var data, var points){
    final Firestore _db = Firestore.instance;

    DocumentReference ref = _db.collection('users').document(''+data);
      ref.setData({
        'points': FieldValue.increment(1000)
      }, merge: true);
  }

  static preset(var preset, var points){
    final Firestore _db = Firestore.instance;

    DocumentReference ref = _db.collection('generalData').document('presets');
      ref.setData({
        preset: points
      });
  }
}


