import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comp1786/screen/Observation/addObservation.dart';
import 'package:comp1786/service/databaseService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../shared/sharedWidget.dart';

class DetailObservation extends StatefulWidget {
  const DetailObservation({Key? key, required this.oid}) : super(key: key);
  final String oid;
  @override
  State<DetailObservation> createState() => _DetailObservationState();
}

class _DetailObservationState extends State<DetailObservation> {
  DatabaseService databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Observation details'),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.teal[400],
      body: SingleChildScrollView(
        child: StreamBuilder(
              stream: databaseService.observationCollection.where('oid', isEqualTo: widget.oid).snapshots(),
              builder: (context, snapshot){
                if(!snapshot.hasData){
                  return const SizedBox();
                }else{
                  DocumentSnapshot doc = snapshot.data!.docs[0];
                  DateTime date = doc['date'].toDate();

                  return  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                           Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: (){
                                    nextScreen(context, AddObservation(oid: widget.oid, hid: ''));
                                  },
                                  icon: const Icon(Icons.edit_outlined, color: Colors.white)
                              ),
                              IconButton(
                                  onPressed: (){
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context){
                                          return AlertDialog(
                                            title: const Text('Delete observation', style: TextStyle(color: Colors.red)),
                                            content: const Text('Are you sure want to delete?'),
                                            actions: [
                                              ElevatedButton(
                                                  onPressed: (){
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Cancel')
                                              ),
                                              ElevatedButton(
                                                  onPressed: (){
                                                    databaseService.DeleteObservation(doc['oid']);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                  },
                                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                                  child: const Text('Delete')
                                              )
                                            ],
                                          );
                                        });
                                  },
                                  icon: const Icon(Icons.delete, color: Colors.white)
                              )
                            ],
                        ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Observation: ${doc['observation']}',style: const TextStyle(fontSize: 20,color: Colors.white)),
                                const SizedBox(height: 8),
                                Text('Weather condition: ${doc['weather']}',style: const TextStyle(fontSize: 20,color: Colors.white)),
                                const SizedBox(height: 8),

                                Text('Date: ${DateFormat.EEEE().format(date)}, ${DateFormat.MMMM().format(date)} ${date.day}, ${date.year}',
                                    style: const TextStyle(fontSize: 20,color: Colors.white)),
                                const SizedBox(height: 8),

                                Text('Temperature: ${doc['temperature']}°C',style: const TextStyle(fontSize: 20,color: Colors.white)),
                                const SizedBox(height: 8),

                                doc['description'].isNotEmpty ?
                                Text('Description: ${doc['description']}',style: const TextStyle(fontSize: 20,color: Colors.white))
                                    : const Text('No description.',style: TextStyle(fontSize: 20,color: Colors.white)),
                              ],
                            ),
                          )
                      ],
                    ),
                  );
                }
              }
            ),
      ),


    );
  }
}
