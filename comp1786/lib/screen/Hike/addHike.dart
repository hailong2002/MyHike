import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comp1786/provider/hike_data.dart';
import 'package:comp1786/service/databaseService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../shared/sharedWidget.dart';

class AddHike extends StatefulWidget {
  const AddHike({Key? key, required this.hid}) : super(key: key);
  final String hid;
  @override
  State<AddHike> createState() => _AddHikeState();
}

class _AddHikeState extends State<AddHike> {
  DatabaseService databaseService = DatabaseService();

  List<String> levels = ['Easy', 'Normal', 'Hard'];
  bool isParking = false;
  String selectLevel = 'Easy';
  DateTime selectedDate = DateTime.now();
  final key = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController lengthController = TextEditingController();

  @override
  void initState(){
    super.initState();
    if(widget.hid.isNotEmpty){
      isEdit(widget.hid);
    }
  }

  Future isEdit(String hid) async{
    HikeData hikeData = HikeData();
    await hikeData.getHikeData(widget.hid);
    setState(() {
      nameController.text = hikeData.name;
      locationController.text = hikeData.location;
      lengthController.text = hikeData.length.toString();
      descriptionController.text = hikeData.description;
      selectedDate = hikeData.date;
      selectLevel = hikeData.level;
      isParking = hikeData.isParking;
    });

  }


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hid.isNotEmpty ? 'Edit hike' : 'Add new hike'),
        backgroundColor: Colors.teal,
      ),

      body: Container(
        height: 590,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/hike.jpg'),
            fit: BoxFit.cover,
          ),
        ),

        child: SingleChildScrollView(
          child:
             Form(
               key: key,
               child: Column(
                children: [
                  const SizedBox(height: 45),
                  TextFormField(
                    controller: nameController,
                    cursorColor: Colors.teal,
                    decoration: textInputDecoration.copyWith(
                      hintText:  'Name',
                      hintStyle: const TextStyle(color: Colors.grey)
                    ),
                    validator: (val){
                      if(val!.length < 3 || val.length > 30){
                        return 'Name must be 3 to 30 characters.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: locationController,
                    cursorColor: Colors.teal,
                    decoration: textInputDecoration.copyWith(
                        hintText: 'Location',
                        hintStyle: const TextStyle(color: Colors.grey)
                    ),
                    validator: (val){
                      if(val!.length < 3 || val.length > 30){
                        return 'Location must be 3 to 30 characters.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: lengthController,
                    cursorColor: Colors.teal,
                    keyboardType: TextInputType.number,
                    decoration: textInputDecoration.copyWith(
                        hintText:  'Length of hike (km)',
                        hintStyle: const TextStyle(color: Colors.grey)
                    ),

                    validator: (val){
                      if (val == null || val.isEmpty) {
                        return 'Length of hike must be greater than 0.';
                      }
                      if (double.tryParse(val) == null) {
                        return 'Please enter a valid number.';
                      }
                      if (double.parse(val) <= 0) {
                        return 'Length of hike must be greater than 0.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',style:
                      const TextStyle(fontSize: 17, color: Colors.white )),
                      const SizedBox(width: 10),
                      ElevatedButton(
                          onPressed: (){_selectDate(context);},
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                          child: const Icon(Icons.calendar_month_outlined, color: Colors.teal,)
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Parking available', style: TextStyle(fontSize: 17, color: Colors.white )),
                      Checkbox(
                        checkColor: Colors.teal,
                        activeColor: Colors.white,
                        side:const BorderSide(color: Colors.white, width: 2),
                        value: isParking,
                        onChanged: (bool? value) {
                          setState(() {
                            isParking = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Level of difficult',style: TextStyle(fontSize: 17,color: Colors.white)),
                      const SizedBox(width: 10),
                      DropdownButton<String>(
                        value: selectLevel,
                        dropdownColor: Colors.teal,
                        icon: const Icon(Icons.arrow_drop_down,color: Colors.white),
                        elevation: 16,
                        style: const TextStyle(color: Colors.white, fontSize: 17),
                        underline: Container(
                            height: 2,
                            color: Colors.white
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            selectLevel = value!;
                          });
                        },
                        items: levels.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),

                    ],
                  ),

                  const SizedBox(height: 20),
                  TextFormField(
                    controller: descriptionController,
                    cursorColor: Colors.white,
                    maxLines: 4,
                    decoration: textInputDecoration.copyWith(
                        hintText: 'Description',
                        hintStyle: const TextStyle(color: Colors.white)
                    ),
                    validator: (val){
                      if(val!.length > 100){
                        return 'Max length of description !';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: (){
                        showDialog(
                            context: context,
                            builder: (BuildContext context){
                              return AlertDialog(
                                title: const Text('Confirm '),
                                content: const Text('Do you want to save this hike?'),
                                actions: [
                                  ElevatedButton(
                                      onPressed: (){
                                        if(key.currentState!.validate()){
                                          double length =  double.parse(lengthController.text);
                                          if(widget.hid.isEmpty){
                                            databaseService.CreateHike(nameController.text, locationController.text, length, selectedDate, descriptionController.text, selectLevel, isParking);
                                          }else{
                                            databaseService.EditHike(widget.hid, nameController.text, locationController.text, length, selectedDate, descriptionController.text, selectLevel, isParking);
                                          }
                                          showToast('Successfully', Colors.tealAccent);
                                          Navigator.pop(context);
                                        }
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Yes')
                                  ),
                                  ElevatedButton(
                                      onPressed: (){
                                          Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                      child: const Text('Wait')
                                  )
                                ],
                              );
                            }
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                      child: Text(widget.hid.isEmpty ? 'Add' : 'Save', style: TextStyle(color: Colors.teal, fontSize: 20, fontWeight: FontWeight.bold))
                  )
                ],
            ),
             ),
          ),

      ),
    );
  }
}
