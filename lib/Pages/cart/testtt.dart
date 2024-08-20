// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:hive/hive.dart';
// import 'package:provider/provider.dart';
// import 'package:skeletons/skeletons.dart';
//
// import '../../Bool.dart';
// import '../../Constant/productcontroller.dart';
// import '../../Models/productmodel.dart';
// import '../../Widgets/shimmer.dart';
// import '../../main.dart';
// import '../item.dart';
//
// class MyImageWidget extends StatefulWidget {
//
//
//   MyImageWidget();
//
//   @override
//   _MyImageWidgetState createState() => _MyImageWidgetState();
// }
// Future<List<dynamic>> get_Fav() async {
//   var favoritesBox = Hive.box('Favorite');
//   List<dynamic> allFavorites = favoritesBox.values.toList();
//   // await Future.delayed(Duration(seconds: 2)); // Simulated delay
//   return allFavorites;
// }
// class _MyImageWidgetState extends State<MyImageWidget> {
//   String? imageUrl;
//
//   _getImageUrl(String imageName) async {
//     try {
//       // Construct the reference to the file within the specific folder
//       var ref = await FirebaseStorage.instance
//           .ref()
//           .child('Adley-Bracelet-768x768.jpg');
//       var url = await ref.getDownloadURL();
//       print(url);
//       return url;
//     } catch (e) {
//       print("////$e"); //
//     }
//   }
//
//
//
//   @override
//   void initState() {
//     super.initState();
//     get_Fav();
//     // _loadImage();
//   }
//
//   // Future<void> _loadImage() async {
//   //   var url = await _getImageUrl(widget.imageName);
//   //   setState(() {
//   //     imageUrl = url;
//   //   });
//   // }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:  Container(
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage("icons/bg.jpeg"),
//             fit: BoxFit.cover,
//             colorFilter:
//             ColorFilter.mode(Colors.black45, BlendMode.darken),
//           ),
//         ),
//         child: FutureBuilder<List<dynamic>>(
//           future: get_Fav(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return shimmer(5); // Show a loading spinner while waiting
//             } else if (snapshot.hasError) {
//               return Text('Error: ${snapshot.error}'); // Handle error
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return Container(color: const Color(0xffffffff),
//                 child: Column(
//                   children: [
//                     const SizedBox(
//                       height: 200,
//                     ),
//                     Image.asset(
//                       "images/fav.jpeg",
//                       height: 170,
//                     ),
//                     const Text(
//                       "There are not any item in your favorites",
//                       style: TextStyle(fontSize: 20, color: Colors.black54),
//                     ),
//                   ],
//                 ),
//               );
//             }
//             else if (snapshot.hasData) {
//               var data = snapshot.data!;
//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: GridView.builder(
//                   padding: EdgeInsets.zero,
//                   shrinkWrap: true,
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisSpacing: 10,
//                     mainAxisSpacing: 10,
//                     crossAxisCount: 2,
//                     // childAspectRatio:0.8
//                     mainAxisExtent:260,
//                   ),
//                   itemCount: snapshot.data!.length,
//                   physics: const ClampingScrollPhysics(),
//                   itemBuilder: (BuildContext ctx, i) {
//                     return customWidget(context,data, i);
//                   },
//                 ),
//               );
//             } else {
//               return Text('No favorites found.');
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
// Widget customWidget(BuildContext context, dynamic data, int index){
//   return Container(height: 100,color:const Color.fromRGBO(206,147,216,4),
//     child: InkWell(
//       onTap: () {
//         Get.to(()=> item(
//           data[index]['id'],
//           data[index]['name'],
//           data[index]['price'],
//           data[index]['image'],
//           data[index]['image_details'],
//         ));
//       },
//       child: Column(
//         children: [
//           SizedBox(height:180,width: double.maxFinite,
//               child:CachedNetworkImage(
//                 imageUrl: "${data![index]['image']}",fit: BoxFit.fill,
//                 placeholder: (context, url) =>  SkeletonAvatar(
//                   style: SkeletonAvatarStyle(
//                     width: double.infinity,
//                     height: 180,
//                     shape: BoxShape.rectangle,
//                     // borderRadius: BorderRadius.circular(50), // Adjust as needed
//                   ),
//                 ),
//                 errorWidget: (context, url, error) => Icon(Icons.error),
//               )
//           ), Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//               ),
//               child: Column(
//                 mainAxisAlignment:MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left:8),
//                     child: Text("${data![index]['name']}",
//                         style: const TextStyle(fontSize:18,fontWeight: FontWeight.bold)),
//                   ),
//                   Row(
//                     children: [
//                       Padding(
//                         padding:
//                         const EdgeInsets.only(left: 10),
//                         child: Text(
//                             "${data![index]['price']} EGP",
//                             style:const TextStyle(fontSize:18,fontWeight: FontWeight.bold,color: Colors.green)
//                         ),
//                       ),
//                       const Expanded(child: SizedBox()),
//                       IconButton(
//                         icon: const FaIcon(
//                           FontAwesomeIcons.xmark,
//                           size: 20,
//                         ),
//                         onPressed: () async {
//                           print(data[index]['idp']);
//                           // var favoritesBox = Hive.box('Favorite');
//                           // List<dynamic> allFavorites = favoritesBox.values.toList();
//                           // print(allFavorites);
//                           // print(allFavorites.length);
//                           // await favbox?.clear();
//                           await favbox?.delete(data[index]['idp']);
//                           // setState(() {
//                             get_Fav();
//                           // });
//                           // print("$fetch");
//                           // await delete(
//                           //     snapshot.data![index]['id']);
//                           // setState(() {
//                           //   _tasks=get_fav();
//                           // });
//                         },
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
//
// }