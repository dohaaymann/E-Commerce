import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class googlemap extends StatefulWidget {
  const googlemap({Key? key}) : super(key: key);

  @override
  State<googlemap> createState() => _googlemapState();
}

class _googlemapState extends State<googlemap> {
  var initialCameraPosition;
  @override
  void initState() {
    initialCameraPosition=CameraPosition(target: LatLng(30.542867319103216, 31.141861219609382));
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition:
        CameraPosition(target: LatLng(30.542867319103216, 31.141861219609382),zoom: 120)

      )
    );
  }
}
