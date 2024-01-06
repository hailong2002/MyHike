import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comp1786/provider/hike_data.dart';
import 'package:comp1786/screen/Hike/addHike.dart';
import 'package:comp1786/service/databaseService.dart';
import 'package:comp1786/shared/sharedWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Hike/HikeDetails.dart';
import 'Hike/location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseService databaseService = DatabaseService();
  String searchText = '';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.teal,
              ),
              height: 250,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const[
                           Text('M-Hike', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Times')),
                           Text('Hello bro!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white54, fontFamily: 'Times')),
                        ],
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                              onPressed: (){
                                nextScreen(context,  const AddHike( hid: ''));
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                              child:const Icon(Icons.add, color: Colors.teal)
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                              onPressed: (){
                                nextScreen(context, const MyLocation());
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                              child: const Icon(Icons.location_on_outlined, color: Colors.teal)
                          ),
                        ],
                      ),

                    ],
                  ),

                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          padding: const EdgeInsets.only(left: 5),
                          width: 330,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: mainColor,
                          ),
                          child: TextFormField(
                            style: const TextStyle(color: Colors.white, fontSize: 20),
                            cursorColor: Colors.white,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(top: 6, left: 10),
                                hintText: 'Search...',
                                border: InputBorder.none,
                                hintStyle:  TextStyle(color: Colors.white54, fontSize: 20)
                            ),
                            onChanged: (val){
                              setState(() {
                                searchText = val;
                              });
                            },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 350,
              height: 450,
              child: StreamBuilder(
                  stream: databaseService.hikeCollection.snapshots(),
                  builder: (context, snapshot){
                    if(!snapshot.hasData){
                      return const SizedBox();
                    }else{
                      List<DocumentSnapshot> documents = snapshot.data!.docs;
                      List<DocumentSnapshot> filteredDocuments = [];
                      if (searchText.isNotEmpty) {
                        String text = searchText.toLowerCase().replaceAll(' ', '');
                        for (DocumentSnapshot doc in documents) {
                          String name = doc['name'].toString().toLowerCase().replaceAll(' ', '');
                          if (name.contains(text)) {
                            filteredDocuments.add(doc);
                          }
                        }
                      } else {
                        filteredDocuments = documents;
                      }
                      return documents.isEmpty  ? const Center(child: Text("No result or you don't have any hike", style: TextStyle(color: Colors.teal, fontSize: 18),)) :
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: searchText.isEmpty ? documents.length : filteredDocuments.length,
                          itemBuilder: (context, index){
                            DocumentSnapshot doc = searchText.isEmpty ? documents[index] : filteredDocuments[index];
                            DateTime date = doc['date'].toDate();
                            HikeData hikeData = HikeData();
                            hikeData.getHikeData(doc['hid']);
                            return
                              Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: (){
                                  nextScreen(context, DetailHike(hid: doc['hid']));
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.teal,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.teal)
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('${date.day}/${date.month}/${date.year}',style: const TextStyle(color: Colors.white, fontSize: 12)),
                                          Text("${doc['name']} ", style: const TextStyle(color: Colors.white, fontSize: 18),),
                                          Text('${doc['location']}, ${doc['length']} km, level: ${doc['level']}',style: const TextStyle(color: Colors.white, fontSize: 12)),
                                        ],
                                      ),
                                      const Icon(Icons.chevron_right, color: Colors.white)
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                      );
                    }
                  }
              ),
            )

          ],
        ),
      ),
    );
  }
}
