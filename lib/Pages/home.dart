import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
import 'package:test0/Models/sql.dart';
import 'package:test0/Pages/catagory.dart';
import 'package:test0/Pages/googlemap.dart';
import 'package:test0/page.dart';
import '../Bool.dart';
import '../Constant/productcontroller.dart';
import '../Models/database.dart';
import '../Constant/links.dart';
import '../Models/productmodel.dart';
import '../Widgets/item_w.dart';
import '../Widgets/shimmer.dart';
import '../main.dart';
import 'cart/testtt.dart';
import 'item.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}
var check_love=[];
var check_lovee=[];
class _homeState extends State<home> {
  List<String> img = [
    'images/Earrings_07.jpeg',
    "images/Marene-Earrings-768x768.jpg",
    "images/Kamiva-Earrings.jpg",
    "images/Hodd-Earrings.jpg",
    "images/Graciane-Bracelet.jpg",
    "images/Falda-Earrings.jpg",
    "images/Dulce-Earrings.jpg"
  ];
  var db=database();
  var sql=SQLDB();
  var value;
 List s=[];
  Future<bool> existInHive(String idp) async {
    bool exists = Hive.box('Favorite').containsKey(idp);
    return exists;
  }
  List loves=[];
  check_Fav(List idp) async {
    check_love = [];
    check_lovee = [];

    for (var i = 0; i < idp.length; i++) {

      var t = await sql.get(idp[i]);
      var value = t[0]["COUNT(*)"];
      if (value.toString() == '1') {
        !check_lovee.any((element) => element.containsKey(idp[i]))?check_lovee.add({idp[i]: true}):null;
      } else if (value.toString() == '0') {
        !check_lovee.any((element) => element.containsKey(idp[i]))?check_lovee.add({idp[i]: false}):null;
      } else {
        break;
      }
    }
     check_love=check_lovee.expand((map) => map.values).toList();
  }

  // Future<dynamic> getProducts() async {
  //   var response = await db.postRequest(linkviewtrend, {});
  //   // var response = await db.postRequest(linkgetdata, {});
  //   await check_Fav(await response['data'].map((item) => item['idp']).toList());
  //   // return response;
  // }
  // Future<dynamic> getP() async {
  //   // var response = await db.postRequest(linkgetdata, {});
  //   var response = await db.postRequest(linkviewtrend, {});
  //   return response;
  // }
  // Future<List<Data>> getTrendingProducts() async {
  //   var response = await productcontroller.get_data();
  //
  //   List<Data> trendingProducts = response.where((product) => product.trend == '1').toList();
  //   return trendingProducts;
  // }
  Future<dynamic> fetchData() async {
    var results = mybox?.get("trend");
    if (results != null) {
      await check_Fav(await results.map((item) => item['idp']).toList());
    } else {
      return []; // or handle it in a way that fits your app's logic
    }
    return results;
  }
  @override
  late Future _tasks;
  late AnimationController _controller;
  @override
  void initState() {
    db = database();
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height:70,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("icons/bg.jpeg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
          ),
        ),
        child: SingleChildScrollView(
          // physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: const ShapeDecoration(shape: StadiumBorder()),
                  child: ImageSlideshow(
                    width: double.infinity,
                    height: 200,
                    initialPage: 0,
                    indicatorColor: Colors.black,
                    indicatorBackgroundColor: Colors.grey,
                    onPageChanged: (value) {
                    },
                    autoPlayInterval: 3000,
                    isLoop: true,
                    children: img
                        .map((image) => Image.asset(
                      image,
                      fit: BoxFit.fill,
                    ))
                        .toList(),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(5)),
                const Text(
                  "Categories",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Padding(padding: EdgeInsets.all(3)),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    children: [
                      categoryButton("icons/BBracelet (1).png","Bracelets"),
                      categoryButton("icons/necklace.png","Necklaces"),
                      categoryButton("icons/diamond-ring.png","Rings"),
                      categoryButton("icons/earrings.png","Earrings"),
                      categoryButton("icons/jewellery.png","Pendants"),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Trending Items",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FutureBuilder(
                  future: fetchData(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return shimmer(10);
                    } else
                      if (snapshot.hasError) {
                        print("\\\n\n\n${snapshot.error}\n\n");
                      return Center(
                        child: Text("Error: ${snapshot.error}"),
                      );
                    } else if (!snapshot.hasData || snapshot.data == null || snapshot.data.isEmpty) {
                        return CircularProgressIndicator();
                      }
                      else if (snapshot.hasData) {
                        var data = snapshot.data ?? [];
                        return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 10,
                            crossAxisCount: 2,
                            mainAxisExtent: 265,
                          ),
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (BuildContext ctx, i) {
                            return productItem(context,data, i);
                          },
                        );
                      } else {
                        return const Center(
                          child: Text("Loading.."),
                        );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
    );
  }
  Widget productItem(BuildContext context, dynamic data, int index) {
    return Consumer<provide>(builder: (context, Bool, child) {
      Bool.list_home = check_love;
      if (index < check_love.length) { // Check if the index is within the range
        return InkWell(
          onTap: () {
            Get.to(()=>item(
                    data[index]['idp'],
                    data[index]['name'],
                    data[index]['price'],
                    data[index]['image'],
                    data[index]['details_image'],
                )
            )?.then((_) {
            setState(() {
            (context as Element).reassemble();
            Bool.get_count();
            });
            });
          },
      child: Column(
      children: [
        Container(
          height: 180,
          width: double.maxFinite,
          decoration: const ShapeDecoration(shape: StadiumBorder()),
          child: CachedNetworkImage(
            imageUrl: "${data[index]['image']}",
            fit: BoxFit.fill,
            placeholder: (context, url) => SkeletonAvatar(
              style: SkeletonAvatarStyle(
                width: double.infinity,
                height: 180,
                shape: BoxShape.rectangle,
              ),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  "${data[index]['name']}",
                  style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      "${data[index]['price']} EGP",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  IconButton(
                    isSelected: Bool.list_home[index],
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
                        await sql.delete('Favorite', data[index]['idp']);
                        Bool.list_ch_home(index, false);
                      } else {
                        await sql.insert('Favorite', {
                          "id": data[index]['idp'],
                          'name': data[index]['name'],
                          'price': data[index]['price'],
                          'image': data[index]['image'],
                          'image_details': data[index]['details_image']
                        });
                        Bool.list_ch_home(index, true);
                      }
                            },
                          )
                        ],
                      )
                    ]),
              ),
            ],
          ),
        );
      } else {
        return const Text("Error"); // Return an empty widget if the index is out of range
      }
    });
  }

  Widget categoryButton(String imagePath,String page) {
    return InkWell(
      onTap: ()async{
        Get.to(()=> catagory(page))?.then((_) {
          setState(() {
            (context as Element).reassemble();

          });
        });
       // Get.to(()=>googlemap());
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),padding: const EdgeInsets.all(10),
        width: 100,
        // height: 90,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Color.fromRGBO(206, 147, 216, 4),
          // shape: BoxShape.circle,
        ),
        child: Column(
          children: [
            Image.asset(
              imagePath,
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(page,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize:16),),
            )
          ],
        ),
      ),
    );
  }
}
