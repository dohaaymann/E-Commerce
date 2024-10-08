
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
import 'package:test0/Models/uploaddata.dart';
import 'package:test0/Pages/item.dart';
import '../Widgets/shimmer.dart';
import '../main.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  var res;
  Future get_fav() async {
    res = await sql.read("Favorite");
    return res;
  }

  Future<void> delete(var id) async {
    var res = await sql.delete('Favorite', id);
    setState(() {});
  }


  @override
  void initState() {
    print("ffffa");
    super.initState();
    get_fav();
  }
  var fav=upload_data();
  final appBarHeight = AppBar().preferredSize.height;
  // color: Color.fromRGBO(206, 147, 216, 4)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("icons/bg.jpeg"),
            fit: BoxFit.cover,
            colorFilter:
            ColorFilter.mode(Colors.black45, BlendMode.darken),
          ),
        ),
        child: FutureBuilder(
              future: get_fav(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: shimmer(1),
                  ); // Show a loading spinner while waiting
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // Handle error
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Container(
                    // height: MediaQuery.of(context).size.height-appBarHeight,
                    color: const Color(0xffffffff),
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 150,
                          ),
                          Image.asset(
                            "images/fav.jpeg",
                            height: 170,
                          ),
                          const Text(
                            "There are not any item in your favorites",textAlign:TextAlign.center,
                            style: TextStyle(fontSize: 18, color: Colors.black54, ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                else if (snapshot.hasData) {
                  var data = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 2,
                        // childAspectRatio:0.8
                        mainAxisExtent:260,
                      ),
                      itemCount: snapshot.data!.length,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (BuildContext ctx, index) {
                        return Container(height: 100,color:const Color.fromRGBO(206,147,216,4),
                          child: InkWell(
                            onTap: () {
                              Get.to(()=> item(
                                data[index]['id'],
                                data[index]['name'],
                                data[index]['price'],
                                data[index]['image'],
                                data[index]['image_details'],
                              ))?.then((_) {
                                setState(() {
                                  (context as Element).reassemble();
                                });
                              });
                            },
                            child: Column(
                              children: [
                                SizedBox(height:180,width: double.maxFinite,
                                    child:CachedNetworkImage(
                                      imageUrl: "${data![index]['image']}",fit: BoxFit.fill,
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
                                ), Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left:8),
                                          child: Text("${data![index]['name']}",
                                              style: const TextStyle(fontSize:18,fontWeight: FontWeight.bold)),
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(left: 10),
                                              child: Text(
                                                  "${data![index]['price']} EGP",
                                                  style:const TextStyle(fontSize:18,fontWeight: FontWeight.bold,color: Colors.green)
                                              ),
                                            ),
                                            const Expanded(child: SizedBox()),
                                            IconButton(
                                              icon: const FaIcon(
                                                FontAwesomeIcons.xmark,
                                                size: 20,
                                              ),
                                              onPressed: () async {
                                                // await favbox?.clear();
                                                await sql.delete('Favorite',data![index]['id']);
                                                setState(() {
                                                  (context as Element).reassemble();
                                                });
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );

                      },
                    ),
                  );
                } else {
                  return Text('No favorites found.');
                }
              },
        ),
      ),
    );
  }
}
