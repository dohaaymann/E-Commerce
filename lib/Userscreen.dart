
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../Constant/functions.dart';
import '../Bool.dart';
import '../Models/sql.dart';
import 'Constant/links.dart';

class Userscreen extends StatefulWidget {
  const Userscreen({super.key});

  @override
  State<Userscreen> createState() => _UserscreenState();
}

class _UserscreenState extends State<Userscreen> {
  SQLDB sql = SQLDB();
  functions fun = functions();
  var res;
  List<dynamic> favoriteList=[];
  get_fav() async {
    // res = await sql.read("Favorite");
    // return res;
    var res = await sql.read("Favorite");
    favoriteList.addAll(res);
    // return favoriteList;
    return res;
  }

  Future<void> delete(var id) async {
    var res = await sql.delete('Favorite', id);
    print(res);
    setState(() {});
  }

  late Future _tasks;
  late Future _task;

  @override
  void initState() {
    res=get_fav();
    _tasks = get_fav();
    super.initState();
  }
  // color: Color.fromRGBO(206, 147, 216, 4)
  @override
  Widget build(BuildContext context) {
    return Consumer<Bool>(builder: (context, Bool, child) {
      Bool.list_Fav=favoriteList;
      // _task=FfavoriteList;
      return Scaffold(
        appBar: AppBar(
          actions: [IconButton(onPressed: (){
            print(favoriteList);
            print( Bool.list_Fav);
            print(Future.value(Bool.list_Fav));
          }, icon:const Icon(Icons.contact_support_rounded))],
        ),
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
                // future:,
                future: _tasks,
                builder: (context, snapshot) {
                  // if (snapshot.connectionState == ConnectionState.waiting) {
                  //   return Center(child: CircularProgressIndicator());
                  // } else
                    if (snapshot.hasError) {
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
                            "There are not any item in your Userscreens",
                            style: TextStyle(fontSize: 20, color: Colors.black54),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 5,
                          crossAxisCount: 2,
                        ),
                        itemCount: snapshot.data!.length,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (BuildContext ctx, i) {
                          return InkWell(
                            onTap: () {
                              print(Bool.list_Fav);
                              // Navigator.of(context).push(MaterialPageRoute(
                              //   builder: (context) => item(
                              //       snapshot.data![i]['id'],
                              //       snapshot.data![i]['name'],
                              //       snapshot.data![i]['price'],
                              //       snapshot.data![i]['image'],
                              //       snapshot.data![i]['details_image']),
                              // ));
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
                                      // borderRadius: BorderRadius.only(
                                      //   topRight: Radius.circular(20),
                                      //   topLeft: Radius.circular(20),)
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("${snapshot.data![i]['name']}",
                                            style: const TextStyle(fontSize:20,fontWeight: FontWeight.bold)),
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(left: 10),
                                              child: Text(
                                                  "${snapshot.data![i]['price']} EGP",
                                                  style:const TextStyle(fontSize:20,fontWeight: FontWeight.bold)
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
                          );
                        },
                      ),
                    );
                  }
                })),
      );});
  }
}