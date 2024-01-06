import 'package:comp1786/provider/obs_data.dart';
import 'package:flutter/material.dart';

import '../../service/databaseService.dart';
import '../../shared/sharedWidget.dart';

class AddObservation extends StatefulWidget {
  const AddObservation({Key? key, required this.oid, required this.hid}) : super(key: key);
  final String oid;
  final String hid;
  @override
  State<AddObservation> createState() => _AddObservationState();
}

class _AddObservationState extends State<AddObservation> {
  DatabaseService databaseService = DatabaseService();
  String observation = '';
  String weather = '';
  String description = '';
  double temperature = 0;
  DateTime selectedDate = DateTime.now();

  TextEditingController nameController = TextEditingController();
  TextEditingController weatherController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController temperatureController = TextEditingController();


  final key = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: selectedDate,
      lastDate: DateTime(2101),

    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void initState(){
    super.initState();
    isEdit(widget.oid);
  }

  Future isEdit(String oid) async{
    ObsData obsData = ObsData();
    await obsData.getObservationData(oid);
    setState(() {
      nameController.text = obsData.name;
      weatherController.text = obsData.weather;
      descriptionController.text = obsData.description;
      temperatureController.text = obsData.temperature.toString();
      selectedDate = obsData.date;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(widget.oid.isEmpty ? 'Add new observation' : 'Edit observation'),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.teal[300],
      body: Container(
        height: 520,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
        ),
        child: SingleChildScrollView(
          child:
          Form(
            key: key,
            child: Column(
              children: [
                const SizedBox(height: 40),
                TextFormField(
                  controller: nameController,
                  cursorColor: Colors.teal,
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Observation',
                      hintStyle: const TextStyle(color: Colors.grey)
                  ),
                  validator: (val){
                    if(val!.length < 3 || val.length > 30){
                      return 'Observation must be 3 to 30 characters.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: weatherController,
                  cursorColor: Colors.teal,
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Weather',
                      hintStyle: const TextStyle(color: Colors.grey)
                  ),
                  validator: (val){
                    if(val!.length < 3 || val.length > 30){
                      return 'Weather must be 3 to 30 characters.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    SizedBox(
                      child: SizedBox(
                        width: 140,
                        child: TextFormField(
                          controller: temperatureController,
                          cursorColor: Colors.teal,
                          keyboardType: TextInputType.number,
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Temperature (°C)',
                              hintStyle: const TextStyle(color: Colors.grey)
                          ),
                          validator: (val){
                            if(val!.isEmpty){
                              return 'Temperature cannot be empty';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Container(
                      width: 55,
                      child: ElevatedButton(
                          onPressed: (){_selectDate(context);},
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                          child: const Icon(Icons.calendar_month_outlined, color: Colors.teal,)
                      ),
                    ),
                    const SizedBox(width: 10),

                    Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',style: const TextStyle(fontSize: 17, color: Colors.white )),

                  ],
                ),

                const SizedBox(height: 15),
                TextFormField(
                  controller: descriptionController,
                  cursorColor: Colors.white,
                  maxLines: 4,
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Description',
                      hintStyle: const TextStyle(color: Colors.grey)
                  ),
                  validator: (val){
                    if(val!.length > 100){
                      return 'Max length of description is 100 !';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                    onPressed: (){
                      if(key.currentState!.validate()){
                        double temperature = double.parse(temperatureController.text);
                        if(widget.oid.isEmpty){
                          databaseService.CreateObservation(nameController.text, selectedDate,weatherController.text, temperature, descriptionController.text, widget.hid);
                          Navigator.pop(context);
                        }else{
                          databaseService.EditObservation(widget.oid, nameController.text, selectedDate,weatherController.text, temperature, descriptionController.text);
                          Navigator.pop(context);
                        }
                        showToast('Successfully', Colors.tealAccent);
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                    child: Text(widget.oid.isEmpty ? 'Add' : 'Save', style: TextStyle(color: Colors.teal, fontSize: 20, fontWeight: FontWeight.bold))
                )

              ],
            ),
          ),
        ),

      ),
    );
  }
}
