import 'package:flutter/material.dart';

class ShowImageApp extends StatefulWidget {
  const ShowImageApp({Key? key}) : super(key: key);

  @override
  State<ShowImageApp> createState() => _ShowImageAppState();
}

class _ShowImageAppState extends State<ShowImageApp> {
  final List<String> images = [
    'assets/bgr.jpg',
    'assets/hike.jpg',
    'assets/home.jpg',
    'assets/wait.jpg'
  ];

  int currentIndex = 0;
  void nextImage(){
    setState(() {
      currentIndex = (currentIndex + 1) % images.length;
    });
  }

  void previousImage(){
    setState(() {
      currentIndex = (currentIndex - 1 + images.length) % images.length;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Show image app', style: TextStyle()),
        backgroundColor: Colors.pink,
      ),
      body: Container(
        child: Column(
          children: [
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed:previousImage,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                      child: const Icon(Icons.chevron_left)
                  ),
                  const SizedBox(width: 5),
                  ElevatedButton(
                      onPressed: nextImage,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                      child: const Icon(Icons.chevron_right)
                  ),
                ],

            ),
            Center(
              child: Image.asset(images[currentIndex], fit: BoxFit.cover, width: 300),
            )
          ],
        ),
      ),
    );
  }
}
