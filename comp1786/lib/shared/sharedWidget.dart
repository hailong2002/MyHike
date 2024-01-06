import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const mainColor = Color(0xFF26A69A);

final textInputDecoration = InputDecoration(
    labelStyle: TextStyle(color: Colors.grey),
    filled: true,
    fillColor:  Colors.white.withOpacity(0.7),
    contentPadding:  EdgeInsets.all(5),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white.withOpacity(0.7),),
        borderRadius: BorderRadius.all(Radius.circular(15))
    ),

    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white.withOpacity(0.7),),
        borderRadius: BorderRadius.all(Radius.circular(15))
    ),

    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white.withOpacity(0.7),),
        borderRadius: BorderRadius.all(Radius.circular(15))
    )

);

void nextScreen(context, page){
  Navigator.push(context, MaterialPageRoute(builder: (context)=> page));
}

void showToast(String msg, Color color){
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.white,
      textColor: color,
      fontSize: 16.0
  );
}

void deleteDialog(context, ){
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
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete')
            )
          ],
        );
      });
}