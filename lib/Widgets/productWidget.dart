// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../Bool.dart';
// import '../Pages/catagory.dart';
// import '../Pages/item.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:skeletons/skeletons.dart';
// import '../Widgets/productWidget.dart';
// import '../main.dart';
// Widget productWidget(BuildContext context, dynamic data, int index) {
//   return InkWell(
//     onTap: () {
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (context) => item(
//             data[index]['idp'],
//             data[index]['name'],
//             data[index]['price'],
//             data[index]['image'],
//             data[index]['details_image']
//           ),
//         ),
//       );
//     },
//     child: Column(
//       children: [
//         Container(
//           height: 180,
//           width: double.maxFinite,
//           decoration: const ShapeDecoration(shape: StadiumBorder()),
//           child: CachedNetworkImage(
//             imageUrl: "${data[index]['image']}",
//             fit: BoxFit.fill,
//             placeholder: (context, url) => SkeletonAvatar(
//               style: SkeletonAvatarStyle(
//                 width: double.infinity,
//                 height: 180,
//                 shape: BoxShape.rectangle,
//               ),
//             ),
//             errorWidget: (context, url, error) => const Icon(Icons.error),
//           ),
//         ),
//         Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 8),
//                 child: Text(
//                   "${data[index]['name']}",
//                   style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left: 8),
//                     child: Text(
//                       "${data[index]['price']} EGP",
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                         color: Colors.green,
//                       ),
//                     ),
//                   ),
//                   const Expanded(child: SizedBox()),
//                   Consumer<provide>(builder: (context, Bool, child) {
//                     return IconButton(
//                       isSelected: Bool.list_home[index],
//                       icon: const FaIcon(
//                         FontAwesomeIcons.heart,
//                         size: 20,
//                       ),
//                       selectedIcon: const FaIcon(
//                         FontAwesomeIcons.solidHeart,
//                         color: Colors.red,
//                         size: 20,
//                       ),
//                       onPressed: () async {
//                         if (Bool.list_home[index]) {
//                           await sql.delete('Favorite', data[index]['idp']);
//                           Bool.list_ch_home(index, false);
//                         } else {
//                           await sql.insert('Favorite', {
//                             "id": data[index]['idp'],
//                             'name': data[index]['name'],
//                             'price': data[index]['price'],
//                             'image': data[index]['image'],
//                             'image_details': data[index]['details_image']
//                           });
//                           Bool.list_ch_home(index, true);
//                         }
//                       },
//                     );
//                   },
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }