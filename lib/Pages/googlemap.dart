import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test0/Constant/links.dart';

class googlemap extends StatefulWidget {
  const googlemap({Key? key}) : super(key: key);

  @override
  State<googlemap> createState() => _googlemapState();
}

class _googlemapState extends State<googlemap> {
  late CameraPosition initialCameraPosition ;
  late bool serviceEnabled;
  late LocationPermission permission;
  List<LatLng> polylineCoordinates = [];
  StreamSubscription<Position>? positionStream;
  PolylinePoints polylinePoints = PolylinePoints();
  late GoogleMapController mapController;

  List<Marker> markers = [
    Marker(
      markerId: MarkerId("2"),
      position: LatLng(30.474218522464017, 31.200131804267798),
      infoWindow: InfoWindow(title: "Origin"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    ),
    Marker(
      markerId: MarkerId("3"),
      position: LatLng(30.456037743966284, 31.18070324659635),
    ),
  ];

  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    initialCameraPosition = CameraPosition(
      target: LatLng(30.474218522464017, 31.200131804267798),
      zoom: 17,
    );
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.whileInUse) {
      positionStream = Geolocator.getPositionStream().listen(
            (Position? position) {
          if (position != null && mounted) {
            initialCameraPosition = CameraPosition(
              target:LatLng(position.latitude, position.longitude),
              zoom: 17,
            );
            mapController.animateCamera(
              CameraUpdate.newLatLng(
                LatLng(position.latitude, position.longitude),
              ),
            );
            setState(() {
              markers.add(
                Marker(
                  markerId: MarkerId("1"),
                  icon:BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                  position: LatLng(position.latitude, position.longitude),
                ),
              );
            });
          }
        },
      );
    }
  }

  @override
  void dispose() {
    // Cancel the position stream when the widget is disposed
    positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: 30, bottom: 5),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: FloatingActionButton(
            backgroundColor: Colors.purple,
            child: Icon(Icons.location_on, color: Colors.white),
            onPressed: () async {
              PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
                apiKeymap,
                PointLatLng(
                  markers[0].position.latitude,
                  markers[0].position.longitude,
                ),
                PointLatLng(
                  markers[1].position.latitude,
                  markers[1].position.longitude,
                ),
                travelMode: TravelMode.driving,
                wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")],
              );

              if (result.points.isNotEmpty && mounted) {
                setState(() {
                  polylineCoordinates = result.points
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList();
                  _polylines.add(
                    Polyline(
                      polylineId: PolylineId("polyline"),
                      points: polylineCoordinates,
                      color: Colors.green,
                    ),
                  );
                });
              }
            },
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: initialCameraPosition,
            onMapCreated: (controller) {
              mapController = controller;
            },
            polylines: _polylines,
            markers: markers.toSet(),
          ),
        ],
      ),
    );
  }
}

// Position position = await Geolocator.getCurrentPosition();
// Markers.add(Marker(markerId: MarkerId("1"),position: LatLng(position.latitude, position.longitude)));
// mapController.moveCamera(CameraUpdate.newCameraPosition(
//     CameraPosition(target: LatLng(position.latitude, position.longitude),zoom: 14)));