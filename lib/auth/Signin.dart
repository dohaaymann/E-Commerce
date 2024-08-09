import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:test0/page.dart';
import '../Bool.dart';

import '../Widgets/CustomText.dart';
class signin extends StatefulWidget {
  const signin({Key? key}) : super(key: key);

  @override
  State<signin> createState() => _signinState();
}

class _signinState extends State<signin> {
  @override
  final _formKey = GlobalKey<FormState>();
  var obscure = false,wait=false;
  var semail =TextEditingController();
  var spass =TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<Bool>(
      builder: (context, Bool, child) => SingleChildScrollView(
        padding:
        EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Form(
          key:_formKey,
          child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 4, left: 8, right: 8),
                  child:Customtext("Email",semail)),
              Container(
                  margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
                  child:Customtext("Password",spass)
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Get.to(() => forgetpass());
                  },
                  child: const Text(
                    "forgot Password?",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child:wait?const CircularProgressIndicator():ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      UserCredential user;
                      try {
                        user = await auth.signInWithEmailAndPassword(email: semail.text, password: spass.text)
                            .catchError((err) {
                          if (err.code == "invalid-email") {
                            return Get.snackbar(
                                "Error", "Please enter a valid email address",
                                backgroundColor: Colors.red);
                          }
                          if (err.message ==
                              "The password is invalid or the user does not have a password.") {
                            return Get.snackbar(
                                "Error", "ًWrong email address or password",
                                backgroundColor: Colors.red);
                          }
                          if (err.message ==
                              "There is no user record corresponding to this identifier. The user may have been deleted.") {
                            return Get.snackbar(
                                "Error", "Email is not register with us",
                                backgroundColor: Colors.red);
                          }
                          return Get.snackbar("Error", err.message,
                              backgroundColor: Colors.red);
                        });
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          print('No user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          print('Wrong password provided for that user.');
                        }
                      }
                      print("-------------");
                      print("email:  ${semail.text}");
                      print("pass:  ${spass.text}");
                      wait=!wait;
                      Timer(const Duration(seconds: 3), () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => page(2),));
                      });
                                        }
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(200, 50),
                      side: const BorderSide(),
                      backgroundColor: const Color.fromRGBO(103, 0, 92, 4)),
                  child: const Text(
                    "Sign in",
                    style: TextStyle(fontSize: 23, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}