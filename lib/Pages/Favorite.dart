
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:test0/Pages/item.dart';

import '../Constant/functions.dart';
import '../Constant/links.dart';
import '../Models/sql.dart';
import '../page.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  SQLDB sql = SQLDB();
  functions fun = functions();
  var res;

  get_fav() async {
    res = await sql.read("Favorite");
    return res;
  }

  Future<void> delete(var id) async {
    var res = await sql.delete('Favorite', id);
    // print(res);
    setState(() {});
  }

  late Future _tasks;

  @override
  void initState() {
    get_fav();
    _tasks = get_fav();
    super.initState();
  }
  // color: Color.fromRGBO(206, 147, 216, 4)
  @override
  Widget build(BuildContext context) {
    return Container(
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
            future: _tasks,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Container(color: const Color(0xffffffff),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 200,
                      ),
                      Image.asset(
                        "images/fav.jpeg",
                        height: 170,
                      ),
                      const Text(
                        "There are not any item in your favorites",
                        style: TextStyle(fontSize: 20, color: Colors.black54),
                      ),
                    ],
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 10,
                      crossAxisCount: 2,
                      // childAspectRatio:0.8
                      mainAxisExtent:260,
                    ),
                    itemCount: snapshot.data!.length,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (BuildContext ctx, i) {
                      return Container(height: 100,color:const Color.fromRGBO(206,147,216,4),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => item(
                                  snapshot.data![i]['id'],
                                  snapshot.data![i]['name'],
                                  snapshot.data![i]['price'],
                                  snapshot.data![i]['image'],
                                  snapshot.data![i]['details_image'],
                                      (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page(1),));
                                  }),
                            ));
                          },
                          child: Column(
                            children: [
                              SizedBox(height:180,width: double.maxFinite,
                                child:Image.network("$linkImageRoot/${snapshot.data![i]['image'].toString()}",
                                  fit: BoxFit.fill,
                                ),
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
                                        child: Text("${snapshot.data![i]['name']}",
                                            style: const TextStyle(fontSize:18,fontWeight: FontWeight.bold)),
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(left: 10),
                                            child: Text(
                                                "${snapshot.data![i]['price']} EGP",
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
                                              await delete(
                                                  snapshot.data![i]['id']);
                                              setState(() {
                                                initState();
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
              }
            }));
  }
}