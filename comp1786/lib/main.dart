
import 'package:comp1786/provider/hike_data.dart';
import 'package:comp1786/provider/obs_data.dart';
import 'package:comp1786/screen/home_screen.dart';
import 'package:comp1786/showImageApp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'calculator.dart';
import 'contact.dart';
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => HikeData()),
          ChangeNotifierProvider(create: (context) => ObsData()),
        ],
        child: MaterialApp(
          home: HomeScreen(),
          debugShowCheckedModeBanner: false,
        ),
      )

  );

}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }
}




