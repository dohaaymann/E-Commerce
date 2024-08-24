import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:test0/Pages/User Pages/Address/add_address.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test0/Pages/User%20Pages/Changepassword.dart';
import 'package:test0/Pages/googlemap.dart';
import 'package:test0/Widgets/CustomButton.dart';
import 'package:test0/auth/DeleteAccount.dart';
import 'package:test0/main.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Bool.dart';
import '../../Constant/productcontroller.dart';
import '../../Constant/links.dart';
import '../../Models/database.dart';
import '../../Models/productmodel.dart';
import '../../auth/auth.dart';
import '../../onboarding.dart';
import 'package:test0/Pages/User Pages/Address/address.dart';
import '../../splash_screen.dart';
import '../cart/testtt.dart';
import 'info.dart';
var auth=FirebaseAuth.instance;
class user extends StatelessWidget {
  const user({super.key});

  @override
  Widget build(BuildContext context) {
    user_page(){
    return Center(
      child: Column (
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Image.asset("icons/worlwide.png",height: 130),
          ),
          const Padding(padding: EdgeInsets.all(35)),
          const Text("Sign in to save and view orders ",style: TextStyle(fontSize: 23),),
          const Text("and update your details",style: TextStyle(fontSize: 23),),
          // ElevatedButton(onPressed: (){}, child:Text("")),
          Padding(
            padding: const EdgeInsets.all(15),
            child: ElevatedButton(style:
            ElevatedButton.styleFrom(
                fixedSize:const Size(300,50),side: const BorderSide(),backgroundColor: const Color.fromRGBO(103, 0, 92,4)),
                onPressed: ()async{
                  Get.to(()=>const auth_());
                }, child:const Text("Go to sign in",style: TextStyle(color:Colors.white,fontSize:23),)),
          ),const SizedBox(height: 90,),
          const Text("Follow Us !",style: TextStyle(fontSize: 20),),
          Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            IconButton(onPressed: ()async{
              // on FirebaseAuthException catch (e) {
                // if (e.code == 'user-not-found') {
                // } else if (e.code == 'wrong-password') {

            }, icon:FaIcon(FontAwesomeIcons.facebook,color: Colors.blue[900],size:35,)),
            IconButton(onPressed: ()async{
              Get.to(()=>Splash_Screen());

              // const url = 'https://www.facebook.com/profile.php?id=100006949608192';
              // if (await canLaunchUrl(Uri.parse(url))) {
              //   await launchUrl(Uri.parse(url));
              // } else {
              //   throw 'Could not launch $url';
              // }

            }, icon:const FaIcon(FontAwesomeIcons.instagram,color: Colors.pink,size:35,)),
            IconButton(onPressed: ()async{

            }, icon:const FaIcon(FontAwesomeIcons.youtube,color: Colors.red,size:35,)),
          ],)
        ],),
    );}
    Future<dynamic> get_data() async {
      var db=database();
      var response = await db.postRequest(linkget_id, {'email':""});
      return response;
    }
  return StreamBuilder(
    stream: auth.authStateChanges(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }else if (snapshot.hasData) {
        return account_page();
      } else {
        return user_page();
      }
    },
  );
  }
}
class account_page extends StatefulWidget {
  account_page({super.key}) {
    auth.currentUser?.reload();
  }

  @override
  State<account_page> createState() => _account_pageState();
}

class _account_pageState extends State<account_page> {
    Future<bool> check() async {
    await auth.currentUser?.reload();
    if (auth.currentUser!.emailVerified) {
      return true;
    } else {
      return false;
    }
  }

    Future<dynamic> get_data() async {
      print("${ await auth.currentUser!.phoneNumber}");
    var c= await FirebaseFirestore.instance.collection("account").doc(auth.currentUser?.email).get();
    await mybox?.put("fname", c.get("fname"));
    await mybox?.put("pass", c.get("pass"));
    await mybox!.put("lname", c.get("lname"));
    await mybox!.put("phone", "${auth.currentUser!.phoneNumber??''}"??'');

    var db = database();
    var response_id = await db.postRequest(linkget_id, {'email': "${auth.currentUser!.email}"});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('id', int.parse(response_id['data'][0]['id']??'0'));

    var id = prefs.getInt('id');
    var response_address = await db.postRequest(linkview_address, {'user_id':'$id'});
    await mybox!.put("Address",response_address);

    return response_id;
    }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_data();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<provide>(builder: (context, Bool, child) {
      return StreamBuilder(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          return Container(
            color: Colors.grey,
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => Get.to(()=>info()),
                  child: Container(
                    color: Colors.white,
                    margin: const EdgeInsets.only(top: 8, bottom: 8),
                    width: double.infinity,
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Welcome",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8, bottom: 8),
                                  child: Text(
                                    auth.currentUser!.email.toString(),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black54),
                                  ),
                                ),
                              ],
                            ),
                            const Expanded(child: SizedBox()),
                            const Icon(Icons.arrow_forward_ios_outlined, size: 20)
                          ],
                        ),
                        auth.currentUser!.emailVerified
                            ? const SizedBox.shrink()
                            : Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: LinearBorder.none,
                                fixedSize: const Size(250, 40),
                                side: const BorderSide(),
                                backgroundColor:
                                const Color.fromRGBO(206, 147, 216, 4),
                              ),
                              onPressed: () async {
                                Get.to(()=>info());
                              },
                              child: const Text(
                                "Verify your email",
                                style: TextStyle(
                                    fontSize: 20,
                                    color:
                                    Color.fromRGBO(103, 0, 92, 4)),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.all(5),
                        height: 40,
                        child: const Text(
                          "Settings",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 23),
                        ),
                      ),
                      ink("Change Password", () async {
                        Get.to(()=>changepassword());
                      }),
                      ink("Address", () async {
                         Get.to(()=>const address());
                         // Get.to(()=>CheckoutPage());
                         // Get.to(()=>Shipping());
                         // Get.to(()=>payment_success());
                         // Get.to(()=>order_completed());
                         // Get.to(()=>Payment());
                      }),
                      ink("My Orders", () async {
                        // Get.to(()=>MyImageWidget());
                      }),
                      ink("About us", () async {
                        Get.to(()=>googlemap());
                      }),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top:7, bottom:2),
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.all(5),
                        child: const Text(
                          "Security",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 23),
                        ),
                      ),
                      ink("Delete account", () async {
                        Get.to(()=>DeleteAccount());
                       }),
                    ],
                  ),
                ),
                Card(
                  child: InkWell(
                    onTap: () async {
                      Get.defaultDialog(
                        title: "Sign Out",
                        content: const Text("Are you sure you want to sign out?"),
                        onCancel: (){},
                          textConfirm: "Yes",
                        onConfirm:()async{
                        await auth.signOut().then((value) => Navigator.of(context).pop());}
                      );
                    },
                    child: Container(
                      width: double.maxFinite,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          color: Colors.transparent),
                      height:50,
                      child: const Text(
                        "SIGN OUT",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 23,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    margin: const EdgeInsets.only(top: 2),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const Text(
                          "Follow Us !",
                          style: TextStyle(fontSize: 20),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () async {
                                // context.callmethod
                                const url =
                                    'https://www.facebook.com/profile.php?id=100006949608192';
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(Uri.parse(url));
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              icon: FaIcon(
                                FontAwesomeIcons.facebook,
                                color: Colors.blue[900],
                                size: 35,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                Get.to(()=>Splash_Screen());
                              },
                              icon: const FaIcon(
                                FontAwesomeIcons.instagram,
                                color: Colors.pink,
                                size: 35,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // void checkAuthProvider() {
                                  // Get the currently signed-in user
                                  var user = FirebaseAuth.instance.currentUser;

                                  if (user != null) {
                                    // Loop through the provider data to check the provider ID
                                    for (var userInfo in user.providerData) {
                                      if (userInfo.providerId == 'password') {
                                        print('This user is authenticated with email and password.');
                                        // Perform actions specific to email/password authentication
                                      } else if (userInfo.providerId == 'google.com') {
                                        print('This user is authenticated with Google.');
                                        // Perform actions specific to Google authentication
                                      } else {
                                        print('This user is authenticated with another provider: ${userInfo.providerId}');
                                      }
                                    }
                                  } else {
                                    print('No user is currently signed in.');
                                  }
                                // }
                              },
                              icon: const FaIcon(
                                FontAwesomeIcons.youtube,
                                color: Colors.red,
                                size: 35,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      );
    });
  }
}
Widget ink(String name,void Function()? onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height:46,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
      ),
      width: double.infinity,
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Text(name, style: const TextStyle(fontSize: 20)),
          const Expanded(child: SizedBox()),
          const Icon(Icons.arrow_forward_ios_outlined, size: 20),
        ],
      ),
    ),
  );
}

