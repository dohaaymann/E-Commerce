import 'package:flutter/material.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:test0/page.dart';
import '../Bool.dart';
import 'Register.dart';
import 'Signin.dart';



class auth_ extends StatefulWidget {
  const auth_({super.key});

  @override
  State<auth_> createState() => _auth_State();
}

var showpass = true;

class _auth_State extends State<auth_> {
  final auth = FirebaseAuth.instance;
final User = FirebaseFirestore.instance.collection("account");
  @override
  void initState() {
    super.initState();
  }
@override
  Widget build(BuildContext context) {
    return Consumer<Bool>(builder: (context, Bool, child) {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("icons/bg.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Image.asset("icons/woman.png", height: 200),
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50),
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25))),
                      padding: const EdgeInsets.only(
                          top: 20, left: 10, right: 10, bottom: 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    color: Colors.greenAccent,
                                    borderRadius: BorderRadius.circular(50)),
                                margin: const EdgeInsets.only(bottom: 15),
                                child: Row(children: [
                                  Expanded(
                                    child: Container(
                                        height: 55,
                                        width: 185,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Bool.b
                                                ? Colors.purple[200]
                                                : Colors.greenAccent,
                                            borderRadius:
                                            BorderRadius.circular(50)),
                                        child: InkWell(
                                          onTap: () {
                                            Bool.ch_bT();
                                            print("hello:${Bool.b}");
                                          },
                                          child: const Text(
                                            "Sign in",
                                            style: TextStyle(fontSize: 27),
                                          ),
                                        )),
                                  ),
                                  Expanded(
                                    child: Container(
                                        height: 55,
                                        width: 157,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Bool.b
                                                ? Colors.greenAccent
                                                : Colors.purple[200],
                                            borderRadius:
                                            BorderRadius.circular(50)),
                                        child: InkWell(
                                          onTap: () {
                                            Bool.ch_bF();
                                            print("Register:${Bool.b}");
                                          },
                                          child: const Text(
                                            "Register",
                                            style: TextStyle(fontSize: 27),
                                          ),
                                        )),
                                  )
                                ])),
                            Bool.b ? const signin() : const Register(),
                            Bool.b? const Text(" Or Sign in using",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                            ) : const Text(" Or Signup using",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () async {
                                      print("--------");
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                                color: Colors.black45,
                                                height: double.infinity,
                                                child: const Center(
                                                    child: SizedBox(
                                                        height: 50,
                                                        width: 50,
                                                        child:
                                                        CircularProgressIndicator(
                                                          color: Colors
                                                              .blueAccent,
                                                          strokeWidth:5,
                                                        ))));
                                          });
                                      final FirebaseAuth auth =
                                          FirebaseAuth.instance;

                                      try {
                                        GoogleSignInAccount?googleSignInAccount =await GoogleSignIn().signIn();
                                        GoogleSignInAuthentication?googleSignInAuthentication =
                                        await googleSignInAccount?.authentication;
                                        AuthCredential credential =
                                        GoogleAuthProvider.credential(
                                          accessToken:
                                          googleSignInAuthentication
                                              ?.accessToken,
                                          idToken: googleSignInAuthentication
                                              ?.idToken,
                                        );
                                        print("--------");
                                        await auth.signInWithCredential(credential).then((value)async{
                                          var authResult = await auth.signInWithCredential(credential);
                                        var user = authResult.user;
                                        print("User Name: ${user?.displayName}");
                                        print("User Email ${user?.email}");
                                          await FirebaseFirestore.instance
                                              .collection("account")
                                              .doc(user?.email)
                                              .set({
                                            "fname": user?.displayName,
                                            "lname": user?.displayName,
                                            "pass": null,
                                            "time": DateTime.now(),
                                            "phone": null
                                          });
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Container(
                                                    color: Colors.black45,
                                                    height: double.infinity,
                                                    child: const Center(
                                                        child: SizedBox(
                                                            height: 50,
                                                            width: 50,
                                                            child:
                                                            CircularProgressIndicator(
                                                              color: Colors
                                                                  .blueAccent,
                                                              strokeWidth: 7,
                                                            ))));
                                              });
                                          Timer(const Duration(seconds: 3), () {
                                            Get.to(() => page(2));
                                          });
                                        });

                                      } catch (r) {
                                        print("ERRRRRRRRROR:$r");
                                      }
                                    },
                                    icon: Image.asset(
                                      "icons/google.png",
                                      height: 26,
                                    ))
                              ],
                            ),
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(100, 38),
                              side: const BorderSide(),
                              // backgroundColor: Color.fromRGBO(103, 0, 92, 4)
                              backgroundColor:
                              const Color.fromRGBO(206, 147, 216, 4)),
                          child: const Text(
                            "Skip",
                            style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold,
                              // color: Color.fromRGBO(103, 0, 92, 4),
                              color: Colors.white,
                              // decorationThickness: 5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 6),
                    //   child: Align(alignment: Alignment.bottomLeft,child:
                    //   Image.asset("icons/shopping-cart.png",height:57,)),
                    // )
                  ],
                ),
              ),
            ),
          ));
    });
  }
}