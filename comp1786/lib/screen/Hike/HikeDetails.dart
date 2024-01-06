import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comp1786/screen/Hike/addHike.dart';
import 'package:comp1786/screen/Hike/location.dart';
import 'package:comp1786/screen/Observation/ObservationDetails.dart';
import 'package:comp1786/screen/Observation/addObservation.dart';
import 'package:comp1786/service/databaseService.dart';
import 'package:comp1786/shared/sharedWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../provider/hike_data.dart';

class DetailHike extends StatefulWidget {
  const DetailHike({Key? key, required this.hid}) : super(key: key);
  final String hid;
  @override
  State<DetailHike> createState() => _DetailHikeState();
}

class _DetailHikeState extends State<DetailHike> {
  DatabaseService databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hike details'),
        actions: [
          IconButton(
              onPressed: (){
                nextScreen(context, AddHike(hid: widget.hid));
              },
              icon: const Icon(Icons.edit_outlined)
          ),
          IconButton(
              onPressed: (){
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: const Text('Delete hike', style: TextStyle(color: Colors.red)),
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
                                databaseService.DeleteHike(widget.hid);
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
              icon: const Icon(Icons.delete)
          ),
        ],
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder(
        stream: databaseService.hikeCollection.where('hid', isEqualTo: widget.hid).snapshots(),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Text('');
          }else{
            DocumentSnapshot doc = snapshot.data!.docs[0];
            DateTime date = doc['date'].toDate();
            return StreamBuilder(
                stream: databaseService.observationCollection.where('hid', isEqualTo: widget.hid).snapshots(),
                builder: (context,snapshot){
                  if(!snapshot.hasData){
                    return Text('');
                  }else{
                    List<DocumentSnapshot> document = snapshot.data!.docs;
                    return SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Name: ${doc['name']}.',style:const TextStyle(fontSize: 20)),
                            Text('Location: ${doc['location']}.',style:  const TextStyle(fontSize: 20)),
                            Text('Date: ${DateFormat.EEEE().format(date)}, ${DateFormat.MMMM().format(date)} ${date.day}, ${date.year}.',style: TextStyle(fontSize: 20)),
                            Text('Length of hike: ${doc['length']} km.', style: const TextStyle(fontSize: 20)),
                            Text('Level: ${doc['level']}.',style: const TextStyle(fontSize: 20)),
                            doc['isParking'] ? const Text('Available parking.',style: TextStyle(fontSize: 20)) : const Text('Unavailable parking.',style: TextStyle(fontSize: 20)),
                            Text('Description: ${doc['description']}.',style: const TextStyle(fontSize: 20)),

                            const SizedBox(height: 20),
                            const Divider(color: Colors.teal, thickness: 0.8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('My observation: ', style:TextStyle(fontSize: 20, color: Colors.teal, fontWeight: FontWeight.bold)),
                                ElevatedButton(onPressed: (){
                                  nextScreen(context,  AddObservation(oid: '', hid: widget.hid));
                                },
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal) ,
                                    child: const Text('New +')
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 350,
                              height: 280,
                              child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: document.length,
                                  itemBuilder: (context, index){
                                    DocumentSnapshot doc = document[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Container(
                                        height: 55,
                                        decoration: BoxDecoration(
                                          color: Colors.teal[400],
                                          borderRadius: BorderRadius.circular(10)

                                        ),
                                        child: ListTile(
                                          title: Text('${doc['observation']}',style: const TextStyle(fontSize: 16, color: Colors.white) ),
                                          trailing: const Icon(Icons.chevron_right,color: Colors.white),
                                          onTap: (){
                                            nextScreen(context, DetailObservation(oid: doc['oid']));
                                          },
                                        ),
                                      ),
                                    );
                                  }
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
            });

          }

        },
      )

    );
  }
}
