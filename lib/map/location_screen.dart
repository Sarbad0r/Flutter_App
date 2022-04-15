import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          
          SizedBox(
              height: MediaQuery.of(context).size.height - 200,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(37.43296265331129, -122.08832357078792)),
              )),
        ],
      ),
    );
  }
}
