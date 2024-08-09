import 'package:add_to_cart_button/add_to_cart_button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:countnumberbutton/countnumberbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:item_count_number_button/item_count_number_button.dart';
import 'package:provider/provider.dart';
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
  SQLDB sql=SQLDB();
  var auth=FirebaseAuth.instance;
  Connectivity connectivity = Connectivity();
  var res;
  List price=[],amount=[];
  List items=[];
  var q,q1;
  get_carts() async {
     price=[];
    res = await sql.read("Cart");
    if (mounted) {
      setState(() {});
    }
    for (var innerMap in res) {
      price.add(innerMap['price']);
      amount.add(innerMap['quantity']);
    }
    get_sum();
    return res;
  }
 get_sum(){
   var sum = 0.0;
   for (int i = 0; i < price.length; i++) {
     sum+= price[i] * amount[i];
   }
   return sum;
   // return price.reduce((value, element) => value + element);
 }
  late Future _tasks;
  @override
  void initState(){
    _tasks=get_carts();
    super.initState();
  }
  functions fun=functions();

  @override
  Widget build(BuildContext context) {
    return Consumer<Bool>(builder: (context, Bool, child) {
      return StreamBuilder<ConnectivityResult>(
        stream: connectivity.onConnectivityChanged,
        builder: (context, snapshot) {
          return snapshot.data == ConnectivityResult.none
              ? const offlinepage()
              : Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    leading: IconButton(onPressed: (){Get.to(()=>page(0));}, icon:const Icon(Icons.arrow_back,size: 30,color: Colors.white,)),
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
                        color: Color.fromRGBO(206, 147, 216, 4)
                        ),
                    child: FutureBuilder(
                        future: _tasks,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }  else if (!snapshot.hasData ||snapshot.data!.isEmpty) {
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
                                // Padding(padding: EdgeInsets.all(5)),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        fixedSize: const Size(300, 50),
                                        side: const BorderSide(),
                                        backgroundColor: Colors.white),
                                    onPressed: () async {
                                      Get.to(()=>page(0));
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
                                    itemCount:snapshot.data!.length,
                                    itemBuilder: (context, i) {
                                       q=snapshot.data![i]['quantity'];
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
                                                width:103,
                                                child: Image.network(
                                                  "$linkImageRoot/${snapshot.data![i]['image'].toString()}",fit: BoxFit.fill,
                                                ),
                                              ),
                                              // SizedBox(height: 100,),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                     snapshot.data![i]['name'].toString(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:20,
                                                          color: Colors.black),
                                                    ),
                                                    Text(
                                                      "Quantity:$q",
                                                      style: const TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              Colors.black54),
                                                    ),
                                                    const Expanded(child: SizedBox()),
                                                    Text(
                                                      "${snapshot.data![i]['price']} EGP",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20,color: Colors.green),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  IconButton(
                                                      onPressed: () async {
                                                        // print('${res[0]['id']}');
                                                        await sql.delete(
                                                            'Cart',
                                                            snapshot.data![i]['id']);
                                                        setState(() {
                                                          initState();
                                                        });
                                                      },
                                                      icon: const FaIcon(
                                                        Icons.delete,
                                                        size: 25,
                                                      )),
                                                  AddToCartCounterButton(
                                      initNumber:q,
                                      counterCallback:(int){
                                        // print(int.toString());
                                        setState(() {
                                          q=int;
                                        });
                                      },
                                      increaseCallback:(){
                                        print(q.toString());
                                        setState(() {
                                          q++;
                                        });
                                      },
                                      decreaseCallback:(){
                                        setState(() {
                                          q--;
                                        });
                                      },
                                      minNumber: 0,
                                      maxNumber: 16,
                                        backgroundColor: Color.fromRGBO(103, 0, 92, 4),
                                        buttonFillColor: Color.fromRGBO(103, 0, 92, 4),
                                        buttonIconColor: Colors.white,
                                      ),
                                                  SizedBox(height:2,)

                                                ],
                                              ),
                                              SizedBox(width:10,)

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
                                            "${get_sum().toString()} EGP",
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
                                              print(auth.currentUser);
                                              if(auth.currentUser==null){
                                                Get.to(()=>page(2));
                                              }else{
                                                Get.to(()=>Shipping(get_sum().toString().substring(0,get_sum().toString().length - 2),res));
                                              }
                                              // print(res);
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
