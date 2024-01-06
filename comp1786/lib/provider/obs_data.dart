

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comp1786/service/databaseService.dart';
import 'package:flutter/cupertino.dart';

class ObsData extends ChangeNotifier{
  String oid = '';
  String name = '';
  String weather = '';
  double temperature = 0;
  String description = '';
  DateTime date= DateTime.now();

  Future<void> getObservationData(oid) async{
    QuerySnapshot snapshot = await DatabaseService().observationCollection.where('oid', isEqualTo: oid).get();
    if(snapshot.docs.isNotEmpty){
      name = snapshot.docs[0].get('observation');
      weather = snapshot.docs[0].get('weather');
      temperature = snapshot.docs[0].get('temperature').toDouble();
      date = snapshot.docs[0].get('date').toDate();
      description = snapshot.docs[0].get('description');
      notifyListeners();
    }
  }


}