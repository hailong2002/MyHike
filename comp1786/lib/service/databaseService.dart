import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  DatabaseService();
  final CollectionReference hikeCollection = FirebaseFirestore.instance.collection("hike");
  final CollectionReference observationCollection = FirebaseFirestore.instance.collection("observation");

  Future CreateHike(String name, String location, double length, DateTime date, String description, String level, bool isParking) async{
    DocumentReference documentReference =  await hikeCollection.add({
      'hid': '',
      'name': name,
      'location': location,
      'length': length,
      'date': Timestamp.fromDate(date),
      'description': description,
      'level': level,
      'isParking': isParking
    });

    await documentReference.update({
      'hid': documentReference.id
    });
  }

  Future DeleteHike(String hid) async{
    DocumentReference documentReference =  hikeCollection.doc(hid);
    documentReference.delete();
  }

  Future EditHike(String hid,String name, String location, double length, DateTime date, String description, String level, bool isParking) async{
    DocumentReference documentReference =  hikeCollection.doc(hid);
    await documentReference.update({
      'name': name,
      'location': location,
      'length': length,
      'date': Timestamp.fromDate(date),
      'description': description,
      'level': level,
      'isParking': isParking
    });
  }

  Future CreateObservation(String observation, DateTime dateTime, String weather, double temperature, String description, String hid) async{
    DocumentReference documentReference = await observationCollection.add({
      'oid': '',
      'hid': hid,
      'observation': observation,
      'date': Timestamp.fromDate(dateTime),
      'weather': weather,
      'temperature': temperature,
      'description': description
    });

    await documentReference.update({
      'oid': documentReference.id
    });
  }

  Future EditObservation(String oid, String observation, DateTime dateTime, String weather, double temperature, String description) async{
    await observationCollection.doc(oid).update({
      'observation': observation,
      'date': Timestamp.fromDate(dateTime),
      'weather': weather,
      'temperature': temperature,
      'description': description
    });
  }

  Future DeleteObservation(String oid) async{
    DocumentReference documentReference =  observationCollection.doc(oid);
    documentReference.delete();
  }




}