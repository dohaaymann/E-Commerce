import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:test0/Pages/catagory.dart';
import 'package:test0/page.dart';
import '../Bool.dart';
import '../Models/database.dart';
import '../Constant/links.dart';
import '../Widgets/item_w.dart';
import 'item.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}
List check_love=[];
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
  late database db;
  var value;
 List s=[];
  check_Fav(List idp) async {
    check_love=[];
    for(var i=0;i<idp.length;i++){
      if(check_love.length==idp.length){
        break;
      }else{
        var t=await sql.exist(idp[i]);
        value=t[0]["COUNT(*)"];
        if(value.toString()=='1'){
          check_love.add(true);
        }else if(value.toString()=='0'){
          check_love.add(false);
        }else{
          break;
        }
      }
    }
  }
  List loves=[];
  Future<dynamic> getProducts() async {
    var response = await db.postRequest(linkviewtrend, {});
    await check_Fav(await response['data'].map((item) => item['idp']).toList());
    // return response;
  }
  Future<dynamic> getP() async {
    var response = await db.postRequest(linkviewtrend, {});
    return response;
  }
  @override
  late Future _tasks;
  @override
  void initState() {
    db = database();
    getProducts();
    _tasks=getP();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      // print('Page changed: $value');
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
                  child: Row(
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
                  future: _tasks,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else
                      if (snapshot.hasError) {
                      return Center(
                        child: Text("Error: ${snapshot.error}"),
                      );
                    } else if (snapshot.hasData) {
                      return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                          // // childAspectRatio: 0.7,
                          crossAxisSpacing: 10,
                          // mainAxisSpacing:10,
                          crossAxisCount: 2,
                          // childAspectRatio:0.8
                          mainAxisExtent:265,
                        ),
                        shrinkWrap: true,
                        itemCount: snapshot.data['data'].length,
                        itemBuilder: (BuildContext ctx, i) {
                          return productItem(context, snapshot.data, i);
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
    return Consumer<Bool>(builder: (context, Bool, child) {
      Bool.list_home = check_love;
      if (index < check_love.length) { // Check if the index is within the range
        return InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => item(
                  data['data'][index]['idp'],
                  data['data'][index]['name'],
                  data['data'][index]['price'],
                  data['data'][index]['image'],
                  data['data'][index]['details_image'],
                    (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page(0),));
                    }
                ),
              ),
            );
          },
          child: Column(
            children: [
              Container(
                height: 180,
                width: double.maxFinite,
                decoration: const ShapeDecoration(shape: StadiumBorder()),
                child: Image.network(
                  "$linkImageRoot/${data['data'][index]['image']}",
                  fit: BoxFit.fill,
                ),
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
                        "${data['data'][index]['name']}",
                        style: const TextStyle(fontSize:19, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:8),
                          child: Text(
                            "${data['data'][index]['price']} EGP",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize:18,color: Colors.green),
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
                              await sql.delete('Favorite', data['data'][index]['idp']);
                              Bool.list_ch_home(index, false);
                            } else {
                              await sql.insert('Favorite', {
                                "id": data['data'][index]['idp'],
                                'name': data['data'][index]['name'],
                                'price': data['data'][index]['price'],
                                'image': data['data'][index]['image'],
                                'image_details': data['data'][index]['details_image']
                              });
                              Bool.list_ch_home(index, true);
                            }
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      } else {
        return const SizedBox(); // Return an empty widget if the index is out of range
      }
    });
  }

  Widget categoryButton(String imagePath,String page) {
    return InkWell(
      onTap: () {
       Navigator.of(context).push(MaterialPageRoute(builder: (context) => catagory(page),));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),padding: const EdgeInsets.all(10),
        // width: 100,
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
