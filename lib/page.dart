import 'dart:ffi';
import 'dart:ffi';
import 'dart:io';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:test0/Models/uploaddata.dart';
import 'package:test0/Pages/cart/cart.dart';
import 'package:test0/Pages/googlemap.dart';
import 'package:test0/Pages/home.dart';
import 'Bool.dart';
import 'Models/database.dart';
import 'Models/sql.dart';
import 'Pages/Favorite.dart';
import 'Pages/cart/testtt.dart';
import 'Pages/catagory.dart';
import 'Pages/User Pages/user.dart';

final auth=FirebaseAuth.instance;
class page extends StatefulWidget{
  final numofpage;
  page(this.numofpage, {super.key}){
  }

  @override
  State<page> createState() => _pageState();
}

class _pageState extends State<page> {
  // Connectivity connectivity = Connectivity();
  database db=database();
  SQLDB sql=SQLDB();
  var count;
  get_count()async{
    var x=await sql.selectsum();
     count=x[0]['COUNT(*)']??0;
     return x[0]['COUNT(*)'];
  }

  @override
  void initState(){
    super.initState();
    get_count();
    count=get_count();
  }
  @override
  Widget build(BuildContext context) {

    final pageController = PageController(initialPage:widget.numofpage);
    final controller = NotchBottomBarController(index: 0);
    List category=["Bracelets","Earrings","Rings","Necklaces","Pendants" ];

    final List<Widget> bottomBarPages = [
      const home(),
      const Favorite(),
      const user(),
    ];
    return Consumer<provide>(builder: (context, Bool, child) {
        return Scaffold(
            body: PopScope(canPop: false,
              child: PageView(
                controller: pageController,
                physics: const ClampingScrollPhysics(),
                children: List.generate(
                    bottomBarPages.length, (index) => bottomBarPages[index]),
              ),
            ),
            extendBody: true,
              bottomNavigationBar: AnimatedNotchBottomBar(
                kBottomRadius:20,
            notchBottomBarController: controller,
            color: const Color.fromRGBO(206,147,216,4),
            showLabel: false,
            notchColor: Colors.white,
            removeMargins: false,
            bottomBarWidth: 100,
            durationInMilliSeconds: 300,
                kIconSize: 24.0,
                bottomBarItems: const [
                BottomBarItem(
                  inActiveItem: Icon(
                    FontAwesomeIcons.house,
                    color: Colors.white,
                  ),
                  activeItem: Icon(
                    FontAwesomeIcons.house,
                    color: Color.fromRGBO(103, 0, 92, 4),
                  ),
                  itemLabel: 'Page 1',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    FontAwesomeIcons.solidHeart,
                    color: Colors.white,
                  ),
                  activeItem: Icon(
                    FontAwesomeIcons.solidHeart,
                    color: Color.fromRGBO(103, 0, 92, 4),

                  ),
                  itemLabel: 'Page 2',
                ),
                BottomBarItem(
                  inActiveItem: Icon(
                    FontAwesomeIcons.solidUser,  color: Colors.white,

                  ),
                  activeItem: Icon(
                    FontAwesomeIcons.solidUser,
                    color: Color.fromRGBO(103, 0, 92, 4),
                  ),
                  itemLabel: 'Page 3',
                ),
              ],
              onTap: (index) {
                pageController.jumpToPage(index);
                // pageController.page;
              },
            ), appBar:  AppBar(backgroundColor: Colors.transparent,
                elevation: 4,
                title: const Text("JW STORE",style: TextStyle(fontWeight: FontWeight.bold),),
                centerTitle: true,
                actions: [
                  Consumer<provide>(builder: (context, Bool, child) {
                    // get_count();
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children:[
                              IconButton(onPressed:()async{
                                Get.to(()=>const cart())?.then((_) {
                                  setState(() {
                                    get_count();
                                    (context as Element).reassemble();
                                  });
                                });
                              },icon:const FaIcon(FontAwesomeIcons.cartShopping),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(left:35),
                                  child: Container(
                                      decoration: const BoxDecoration(color:Colors.green
                                    ,shape: BoxShape.circle,
                                  ),padding: const EdgeInsets.all(4),
                                      child: Text("${Bool.count_cart}",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                                  ),
                                ),
                              )

                            ],
                          ));
                    }
                  )
                ],
            ),
            drawer:Drawer(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8,right: 4,top:15),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: (){}, icon: const FaIcon(FontAwesomeIcons.house,size: 25,)),
                      const Text("category",style: TextStyle(fontSize: 25),),
                    IconButton(onPressed: (){Navigator.of(context).pop();}, icon: const FaIcon(FontAwesomeIcons.xmark,size: 25,))
                  ],),
                ),
              SizedBox(height:500,
                child: ListView.builder(itemCount:category.length,itemBuilder: (context, i) {
                  return Card(child:  InkWell(onTap:() =>
                      Get.to(()=>catagory(category[i].toString()))?.then((_) {
                        setState(() {
                          (context as Element).reassemble();
                        });
                      })
                  ,child: Container(width: double.maxFinite,alignment: Alignment.center,
                    decoration:BoxDecoration(borderRadius: BorderRadius.circular(0),color: Colors.transparent),
                    height:60,child:Text(category[i],style: const TextStyle(fontSize: 23),),)),);
                },),
              )
              ]),
            ) ,
        );
      }
    );
  }
}

  // class Network_Failed extends StatelessWidget {
  // @override
  // Network_Failed({super.key}){
  // }
  // @override
  // Widget build(BuildContext context) {
  // return Scaffold(
  // body:Container(height: double.infinity,
  // decoration:const BoxDecoration(color:Colors.white),
  // child: Center(child:Column(children: [
  // const SizedBox(height: 200,),
  // Image.asset("icons/no-wifi.png",height:200),
  // const Text("Network Failed",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
  // const Padding(
  // padding: EdgeInsets.all(12.0),
  // child: Text("Please check your connection",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black54),),
  // ),
  // ]) ,),
  // )
  // );
  // }
  // }
