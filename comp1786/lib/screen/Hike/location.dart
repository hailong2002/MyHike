import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MyLocation extends StatefulWidget {
  const MyLocation({Key? key}) : super(key: key);

  @override
  State<MyLocation> createState() => _MyLocationState();
}

class _MyLocationState extends State<MyLocation> {
  LatLng _currentPosition = LatLng(0,0);
  _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
      print(_currentPosition.latitude);
      print(_currentPosition.longitude);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My location'),
        backgroundColor: Colors.teal,
      ),
      body: _currentPosition == LatLng(0,0) ?  const Center(child:CircularProgressIndicator(color: Colors.teal, strokeWidth: 4)) :
      FlutterMap(
          options: MapOptions(
              zoom: 15,
              center: LatLng(_currentPosition.latitude,_currentPosition.longitude)
          ),
          children: [
            // Layer that adds the map
            TileLayer(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              userAgentPackageName: 'com.example.comp1786'
            ),
            // Layer that adds points the map
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(_currentPosition.latitude,_currentPosition.longitude),
                  width: 80,
                  height: 80,
                  builder: (context) => IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.location_on),
                    color: Colors.red,
                    iconSize: 45,
                  ),
                ),
              ],
            ),
            // PolyLines layer
          ],
        ),

    );
  }
}
