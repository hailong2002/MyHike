

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comp1786/service/databaseService.dart';
import 'package:flutter/cupertino.dart';

class HikeData extends ChangeNotifier{
  String hid = '';
  String name = '';
  String location = '';
  double length = 0;
  String description = '';
  String level = '';
  bool isParking = false;
  DateTime date= DateTime.now();

  Future<void> getHikeData(hid) async{
    QuerySnapshot snapshot = await DatabaseService().hikeCollection.where('hid', isEqualTo: hid).get();
    if(snapshot.docs.isNotEmpty){
      name = snapshot.docs[0].get('name');
      location = snapshot.docs[0].get('location');
      length = snapshot.docs[0].get('length').toDouble();
      date = snapshot.docs[0].get('date').toDate();
      level = snapshot.docs[0].get('level');
      isParking = snapshot.docs[0].get('isParking');
      description = snapshot.docs[0].get('description');
      notifyListeners();
    }
  }


}