import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:test0/Widgets/item_w.dart';

import '../Constant/colors.dart';
import '../Constant/links.dart';

class googlemap extends StatefulWidget {
  const googlemap({Key? key}) : super(key: key);

  @override
  State<googlemap> createState() => _googlemapState();
}

class _googlemapState extends State<googlemap> {
  var initialCameraPosition;
  Location location = new Location();
  List polylineCoordinates=[];
  PolylinePoints polylinePoints = PolylinePoints();
var lat,lng;
  var p1=PointLatLng(30.474218522464017, 31.200131804267798);
  var p2=PointLatLng(30.456037743966284, 31.18070324659635);
//   get_location()async{
//
//   bool _serviceEnabled;
//   PermissionStatus _permissionGranted;
//   LocationData _locationData;
//
//   _serviceEnabled = await location.serviceEnabled();
//   if (!_serviceEnabled) {
//     _serviceEnabled = await location.requestService();
//     if (!_serviceEnabled) {
//       return;
//     }
//   }
//
//   _permissionGranted = await location.hasPermission();
//   if (_permissionGranted == PermissionStatus.denied) {
//     _permissionGranted = await location.requestPermission();
//     if (_permissionGranted != PermissionStatus.granted) {
//       return;
//     }
//   }
//   _locationData = await location.getLocation();
//   lat=_locationData.latitude;
//   lng=_locationData.lngitude;
//   return _locationData;
// }

  polylinepoints() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        apiKey,
        p1,
        p2,
        travelMode: TravelMode.driving
    );
    if(result.points.isNotEmpty){
       result.points.forEach((point) {
          polylineCoordinates.add(LatLng(point.latitude,point.longitude));
       },);
    } else{
      print("Error:::${result.errorMessage}");
    }
    return polylineCoordinates;
  }

  @override
  void initState() {
    initialCameraPosition=CameraPosition(
        target: LatLng(30.548378562955463, 31.139540633313032),
      zoom: 17
    );
    // TODO: implement initState
    super.initState();
    update_location();
    // get_location();
  }
  update_location()async{
     location.onLocationChanged.listen((event) {
       print(event);
       var cam=CameraPosition(target: LatLng(event.latitude!, event.longitude!),zoom: 17);
       // var cam=CameraPosition(target: LatLng(30.474292496252875, 31.200099617759623),zoom: 17);
       mapController.animateCamera(CameraUpdate.newCameraPosition(cam));
     },);
  }
  late GoogleMapController mapController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding:EdgeInsets.only(left:30,bottom:5),
        child: Align(alignment:Alignment.bottomLeft ,
          child: FloatingActionButton(
            shape:CircleBorder(),
            backgroundColor:purplefav,
              child:Icon(Icons.location_on,color: Colors.white,),
              onPressed:()async{
           //  var newlocation=CameraPosition(
           //      target: LatLng(lat, lng),
           //      zoom: 17
           //  );
           // mapController.animateCamera(CameraUpdate.newCameraPosition(newlocation));
            update_location();
            // print("${await get_location()}");
          }),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition:initialCameraPosition,
            onMapCreated:(controller) {
              mapController=controller;
            },
            markers: {Marker(
              markerId:MarkerId("كلية الحاسبات والذكاء الاصطناعي"),
              position: LatLng(30.474218522464017, 31.200131804267798),
            ),
              Marker(
              markerId:MarkerId("محطة بنها"),
              position: LatLng(30.456037743966284, 31.18070324659635),
            ),
            // },
              // polylines:Set<polylinePoints>.of(polylinePoints.va)
          },
          ),
        ],
      )
    );
  }
}
