import 'package:add_to_cart_button/add_to_cart_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
import 'package:slider_button/slider_button.dart';
import 'package:test0/Models/sql.dart';
import 'package:test0/page.dart';
import '../../Bool.dart';
import '../../Constant/functions.dart';
import '../../Constant/links.dart';
import 'Shipping.dart';
class cart extends StatefulWidget{
  const cart({super.key});

  @override
  State<cart> createState() => _cartState();
}

class _cartState extends State<cart> {
  SQLDB sql = SQLDB();
  var auth = FirebaseAuth.instance;
  Connectivity connectivity = Connectivity();
  var res;
  List price = [];
  List amount = [];
  List items = [];
  double sum = 0.0;

  get_carts() async {
    price = [];
    amount = [];
    res = await sql.read("Cart");
    if (mounted) {
      setState(() {});
    }
    for (var innerMap in res) {
      price.add(innerMap['price']);
      amount.add(innerMap['quantity']);
    }
    calculateSum();
    return res;
  }

  calculateSum() {
    sum = 0.0;
    for (int i = 0; i < price.length; i++) {
      sum += price[i] * amount[i];
    }
    return sum;
  }

  late Future _tasks;

  @override
  void initState() {
    _tasks = get_carts();
    super.initState();
  }

  functions fun = functions();

  @override
  Widget build(BuildContext context) {
    return Consumer<provide>(builder: (context, Bool, child) {
      return StreamBuilder<ConnectivityResult>(
        stream: connectivity.onConnectivityChanged,
        builder: (context, snapshot) {
          return snapshot.data == ConnectivityResult.none
              ? const offlinepage()
              : Scaffold(
              appBar: AppBar(
                // automaticallyImplyLeading: false,
                // leading: IconButton(
                //     onPressed: () {
                //       Get.to(() => page(0));
                //     },
                //     icon: const Icon(
                //       Icons.arrow_back,
                //       size: 30,
                //       color: Colors.white,
                //     )),
                backgroundColor: const Color.fromRGBO(206, 147, 216, 4),
                title: const Text(
                  "Shopping cart",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Color.fromRGBO(103, 0, 92, 4),
                            Colors.white
                          ])),
                ),
              ),
              body: Container(
                height: double.infinity,
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(206, 147, 216, 4)),
                child: FutureBuilder(
                    future: _tasks,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator());
                      } else if (!snapshot.hasData ||
                          snapshot.data!.isEmpty) {
                        return Center(
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 190,
                                ),
                                Image.asset(
                                  "icons/shopping-cart.png",
                                  height: 150,
                                ),
                                const Padding(padding: EdgeInsets.all(12)),
                                const Text(
                                  "Oops your shopping cart is empty !",
                                  style: TextStyle(fontSize: 15),
                                ),
                                const Text(
                                  "Looking for saved items?",
                                  style: TextStyle(fontSize: 18),
                                ),
                                const Padding(padding: EdgeInsets.all(3)),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        fixedSize: const Size(300, 50),
                                        side: const BorderSide(),
                                        backgroundColor: Colors.white),
                                    onPressed: () async {
                                      Get.to(() => page(0));
                                      // Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      "Continue shopping",
                                      style: TextStyle(
                                          color: Color.fromRGBO(103, 0, 92, 4),
                                          fontSize: 20),
                                    ))
                              ],
                            ));
                      } else {
                        return Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, i) {
                                  return Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        // Color(0xffFFD863),
                                      ),
                                      height: 100,
                                      margin: const EdgeInsets.only(
                                          top: 8, left: 8, right: 8),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 103,
                                            child:CachedNetworkImage(
                                              imageUrl: "${snapshot.data![i]['image']}",fit: BoxFit.fill,
                                              placeholder: (context, url) =>  SkeletonAvatar(
                                                style: SkeletonAvatarStyle(
                                                  width: double.infinity,
                                                  height: 180,
                                                  shape: BoxShape.rectangle,// Adjust as needed
                                                ),
                                              ),
                                              errorWidget: (context, url, error) => Icon(Icons.error),
                                            )
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  snapshot.data![i]['name']
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 20,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  "Quantity:${amount[i]}",
                                                  style: const TextStyle(
                                                      fontSize: 13,
                                                      color:
                                                      Colors.black54),
                                                ),
                                                const Expanded(
                                                    child: SizedBox()),
                                                Text(
                                                  "${snapshot.data![i]['price']} EGP",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 20,
                                                      color:
                                                      Colors.green),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Spacer(),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              IconButton(
                                                  onPressed: () async {
                                                    await sql.delete('Cart',snapshot.data![i]['id']);
                                                    setState(() {
                                                      Bool.get_count();
                                                      _tasks = get_carts();
                                                      // (context as Element).reassemble();
                                                    });
                                                  },
                                                  icon: const FaIcon(
                                                    Icons.delete,
                                                    size: 25,
                                                  )),
                                              AddToCartCounterButton(
                                                initNumber: amount[i],
                                                counterCallback: (int) {
                                                  setState(() {
                                                    if (int <= 0) {
                                                      amount[i]=1;
                                                    }
                                                    else{
                                                      amount[i] = int;
                                                    }
                                                    calculateSum();
                                                  });
                                                },
                                                increaseCallback: () {
                                                },
                                                decreaseCallback: () {
                                                },
                                                minNumber: 1,
                                                maxNumber: 16,
                                                backgroundColor:
                                                const Color.fromRGBO(
                                                    103, 0, 92, 4),
                                                buttonFillColor:
                                                const Color.fromRGBO(
                                                    103, 0, 92, 4),
                                                buttonIconColor:
                                                Colors.white,
                                              ),
                                              const SizedBox(
                                                height: 2,
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          )
                                        ],
                                      ));
                                },
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(103, 0, 92, 4)),
                              padding: const EdgeInsets.all(8),
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Sub total:",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        "${sum.toStringAsFixed(2)} EGP",
                                        style: const TextStyle(
                                            fontSize: 25,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: SliderButton(
                                        width: double.infinity,
                                        action: () async {
                                          if (auth.currentUser == null) {
                                            Get.to(() => page(2));
                                          } else {
                                            Get.to(() => Shipping(
                                                sum.toStringAsFixed(2),
                                                res));
                                          }
                                        },
                                        label: const Text(
                                          "Slide To Checkout",
                                          style: TextStyle(
                                              color: Color(0xff4a4a4a),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17),
                                        ),
                                        icon: const FaIcon(
                                            FontAwesomeIcons.cartShopping)),
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    }),
              ));
        },
      );
    });
  }
}
class offlinepage extends StatelessWidget {
  const offlinepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Container(height: double.infinity,
          decoration:const BoxDecoration(color:Colors.white),
          child: Center(child:Column(children: [
            const SizedBox(height: 200,),
            Image.asset("icons/no-wifi.png",height:200),
            const Text("Network Failed",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text("Please check your connection",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black54),),
            ),
          ]) ,),
        )
    );
  }
}
