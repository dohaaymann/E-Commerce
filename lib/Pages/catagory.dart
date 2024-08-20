import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
import 'package:test0/Widgets/shimmer.dart';
import '../Models/database.dart';
import '../Models/productmodel.dart';
import '../Models/sql.dart';
import '../main.dart';
import '../page.dart';
import '../Bool.dart';
import 'item.dart';

class catagory extends StatefulWidget {
 final String cata_name;
  const catagory(this.cata_name, {super.key});

  @override
  State<catagory> createState() => _catagoryState();
}
List<bool> check_love=[];
// Future<bool> existInHive(var idp) async {
//   bool exists = Hive.box('Favorite').containsKey("$idp");
//   return exists;
// }
class _catagoryState extends State<catagory>{
  @override
  database db=database();
  var sql=SQLDB();
  List loves=[];
  var value;

  check_Fav(List idp) async {
    // var s=await sql.exist('1');
     // print(s);
    print(idp);
    print(await sql.read("Favorite"));
    check_love=[];
    for(var i=0;i<idp.length;i++){
      if(check_love.length==idp.length){
        break;
      }else{
        var value=await sql.exist(idp[i]);
        print(await sql.exist('${idp[1]}'));
        print(value);
        if(value.toString()=='1'){
          print("88$value");
          check_love.add(true);
        }else if(value.toString()=='0'){
          print("99$value");
          check_love.add(false);
        }else{
          print("d");
          break;
        }
      }
    }
    print(    check_love    );
  }


  // get_product()async{
  //   // var response=await db.postRequest(linkviewproduct,{
  //   // 'type':widget.cata_name
  //   // });
  //   var response=await db.postRequest(linkgetdata,{});
  //   print(response);
  //   if (response != null && response['status'] == 'successful') {
  //     print("///////////////////\n//////////////////////");
  //     // Filter the items to find the one with idp = 2
  //     var item = response['data'].firstWhere((item) => item['catagory'] =='${widget.cata_name} , orElse: () => null);
  //     await check_Fav(await item['data'].map((item) => item['id']).toList());
  //     return item;
  //   }
  //   // var item = response['data'].where((item) => item['catagory'] == '${widget.cata_name}').toList();
  //   // print('\n\n\n $item');
  //   // print(response);
  //   return null;
  // }
  fetchData() async {
    var results = mybox?.get("${widget.cata_name}");
    var res = await sql.read("Favorite");
    print(await results.map((item) => item['idp']).toList());
    await check_Fav(await results.map((item) => item['idp']).toList());
    await Future.delayed(Duration(seconds: 1));
    return results;
  }
  // Future<List<Data>> get_items()async{
  //   // print('${widget.cata_name}');
  //   //   var response = await productcontroller.get_data();
  //   //   print(response.runtimeType);
  //   // var Dataa = Dataa();
  //
  //   // List serializedResponse = response.map((data) => data.toJson()).toList();
  //
  //   // await mybox?.put('${widget.cata_name}', response);
  //
  //   List<Data> Products = response.where((product) => product.catagory =='${widget.cata_name}').toList();
  //     // print(Products);
  //   await check_Fav(await Products.map((item) => item.idp).toList());
  //     return Products;
  // }

  @override 
  void initState() {
    // TODO: implement initState
    super.initState();
    // get_items();
    fetchData();
    // get_product();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          // leading: IconButton(onPressed: (){Get.to(()=>page(0));}, icon:const Icon(Icons.arrow_back,size: 30,color: Colors.black,)),
          // backgroundColor:Color.fromRGBO(206,147,216,4),
          backgroundColor:Colors.white,
          title: Text(widget.cata_name,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 24,),),centerTitle: true,
        ),
        body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("icons/bg.jpeg"),
                fit: BoxFit.cover,
                colorFilter:
                    ColorFilter.mode(Colors.black45, BlendMode.darken),
              ),
            ),
            child: SingleChildScrollView(
              // padding: ,
              child: SizedBox(height:MediaQuery.of(context).size.height-80,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                  child: FutureBuilder(
                    // future: get_items(),
                    future:fetchData(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return shimmer(10);
                      } else if (snapshot.hasData) {
                        // if(snapshot.data['statu s']=='fail'){
                        //   return const Center(child: Text("There's no notes"),);
                        // }
                        print("555555555555555555");
                        var data = snapshot.data ?? [];
                        print(data);
                        return GridView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(0),
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 10,
                            crossAxisCount: 2,
                            // childAspectRatio:0.8
                            mainAxisExtent:260,
                          ),
                          itemCount: data.length,
                          scrollDirection: Axis.vertical,physics: const ClampingScrollPhysics(),
                          itemBuilder: (BuildContext ctx, index) {
                            // return Text("${data[1]['name']}",style: TextStyle(color: Colors.white),);
                            return Consumer<provide>(builder: (context, Bool, child) {
                              Bool.list_cata = check_love;
                              // fetchData();
                              if (index < check_love.length) { //
                                return InkWell(
                                  onTap: () async{
                                    Get.to(()=>
                                        item(
                                          data[index]['idp'],
                                          data[index]['name'],
                                          data[index]['price'],
                                          data[index]['image'],
                                          data[index]['details_image'],
                                        ));
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                          height: 180,
                                          width: double.maxFinite,
                                          decoration: const ShapeDecoration(shape: StadiumBorder()),
                                          child: CachedNetworkImage(
                                            imageUrl: "${data[index]['image']}",fit: BoxFit.fill,
                                            placeholder: (context, url) =>  SkeletonAvatar(
                                              style: SkeletonAvatarStyle(
                                                width: double.infinity,
                                                height: 180,
                                                shape: BoxShape.rectangle,
                                                // borderRadius: BorderRadius.circular(50), // Adjust as needed
                                              ),
                                            ),
                                            errorWidget: (context, url, error) => Icon(Icons.error),
                                          )
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left:8),
                                              child: Text(
                                                // "${data[index].name}",
                                                "${data[index]['name']}",
                                                style: const TextStyle(fontSize:16,fontFamily:"Rubik-Medium",fontWeight: FontWeight.bold
                                                  // style: TextStyle(fontSize: 20,fontFamily:"Kanit-Regular",fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 10),
                                                  child: Text(
                                                    // "${data[index].price} EGP",
                                                    "${data[index]['price']} EGP",
                                                    style: const TextStyle(
                                                        fontWeight: FontWeight.bold, fontSize:18,color: Colors.green),
                                                  ),
                                                ),
                                                const Expanded(child: SizedBox()),
                                                Consumer<provide>(builder: (context, Bool, child) {
                                                  return IconButton(
                                                    isSelected: Bool.list_cata[index],
                                                    icon: const FaIcon(
                                                      FontAwesomeIcons.heart,
                                                      size: 20,
                                                    ),
                                                    selectedIcon: const FaIcon(
                                                      FontAwesomeIcons.solidHeart,
                                                      color: Colors.red,
                                                      size: 20,
                                                    ),
                                                    onPressed: () async {
                                                      if (check_love[index]) {
                                                        await sql.delete(
                                                            'Favorite', data[index]['idp']);
                                                        Bool.list_ch_cata(index, false);
                                                      } else {
                                                        await sql.insert('Favorite', {
                                                          "id": data[index]['idp'],
                                                          'name': data[index]['name'],
                                                          'price': data[index]['price'],
                                                          'image': data[index]['image'],
                                                          'image_details': data[index]['details_image']
                                                        });
                                                        Bool.list_ch_cata(index, true);
                                                      }
                                                    },
                                                  );
                                                }
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              else {
                                return const SizedBox();
                              }
                            });
                          },
                        );
                      } if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(), // Show a loading indicator
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text("Error: ${snapshot.error}"), // Show error message
                        );
                      }
                      return const Center(child: Text("Loading.."),);
                    },
                  ),
                ),
              ),
            )));
  }
}
// Widget productItem(BuildContext context, dynamic data, int index) {
//   return Consumer<provide>(builder: (context, Bool, child) {
//     Bool.list_cata = check_love;
//     // fetchData();
//     if (index < check_love.length) { //
//       return InkWell(
//         onTap: () async{
//           Get.to(()=>
//                   item(
//                     data[index]['idp'],
//                     data[index]['name'],
//                     data[index]['price'],
//                     data[index]['image'],
//                     data[index]['details_image'],
//                   ));
//         },
//         child: Column(
//           children: [
//             Container(
//               height: 180,
//               width: double.maxFinite,
//               decoration: const ShapeDecoration(shape: StadiumBorder()),
//               child: CachedNetworkImage(
//                 imageUrl: "${data[index]['image']}",fit: BoxFit.fill,
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
//             ),
//             Container(
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(left:8),
//                     child: Text(
//                       // "${data[index].name}",
//                       "${data[index]['name']}",
//                       style: const TextStyle(fontSize:16,fontFamily:"Rubik-Medium",fontWeight: FontWeight.bold
//                       // style: TextStyle(fontSize: 20,fontFamily:"Kanit-Regular",fontWeight: FontWeight.bold
//                       ),
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 10),
//                         child: Text(
//                           // "${data[index].price} EGP",
//                           "${data[index]['price']} EGP",
//                           style: const TextStyle(
//                               fontWeight: FontWeight.bold, fontSize:18,color: Colors.green),
//                         ),
//                       ),
//                       const Expanded(child: SizedBox()),
//                       Consumer<provide>(builder: (context, Bool, child) {
//                           return IconButton(
//                             isSelected: Bool.list_cata[index],
//                             icon: const FaIcon(
//                               FontAwesomeIcons.heart,
//                               size: 20,
//                             ),
//                             selectedIcon: const FaIcon(
//                               FontAwesomeIcons.solidHeart,
//                               color: Colors.red,
//                               size: 20,
//                             ),
//                             onPressed: () async {
//                               if (check_love[index]) {
//                                 await favbox?.delete(data[index]['idp']);
//                                 Bool.list_ch_cata(index, false);
//                               } else {
//                                 await favbox?.put("${data[index]['idp']}", {
//                                   'idp':data[index]['idp'],
//                                   'name': data[index]['name'],
//                                   'price': data[index]['price'],
//                                   'image': data[index]['image'],
//                                   'image_details': data[index]['details_image']
//                                 });
//                                 Bool.list_ch_cata(index, true);
//                               }
//                             },
//                           );
//                         }
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//     else {
//       return const SizedBox();
//     }
//   });
// }
