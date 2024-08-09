import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:test0/page.dart';
import '../Bool.dart';

import '../Widgets/CustomText.dart';
class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  var obscure = false,__wait=false;
  final __formKey = GlobalKey<FormState>();
  var fname = TextEditingController(), lname =TextEditingController()
  , remail = TextEditingController(), rpass =TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<Bool>(builder: (context, Bool, child) {
      return SingleChildScrollView(
        padding:
        EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Form(
          key: __formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.all(4),
                        child: Customtext("First name",fname)),
                  ),
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.all(4),
                        child: Customtext("Last name",lname)),
                  ),
                ],
              ),
              Container(
                  margin: const EdgeInsets.all(4),
                  child:Customtext("Email",remail)),
              Container(
                  margin: const EdgeInsets.all(4),
                  child:Customtext("Password",rpass)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: __wait?const CircularProgressIndicator():ElevatedButton(
                  onPressed: () async {
                    UserCredential user;
                    if (__formKey.currentState!.validate()) {
                      try {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                            email: remail.text, password: rpass.text)
                            .then((value) async {
                          user = await auth.signInWithEmailAndPassword(
                              email: remail.text, password: rpass.text);
                          await FirebaseFirestore.instance
                              .collection("account")
                              .doc(remail.text)
                              .set({
                            "fname": fname.text,
                            "lname": lname.text,
                            "pass": rpass.text,
                            "time": DateTime.now(),
                            "phone": null
                          });
                        }).catchError((err) {
                          return Get.snackbar("Error", err.message,
                              backgroundColor: Colors.red,
                              colorText: Colors.white);
                        });
                      } catch (e) {
                        print("%%%%%%%%%%%%%%5$e");
                      }
                      __wait=__wait;
                      Timer(const Duration(seconds: 3), () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => page(2),
                        ));
                      });
                                        }
                  },
                  style: ElevatedButton.styleFrom(
                      // fixedSize: Size(200, 50),
                      side: const BorderSide(),
                      backgroundColor: const Color.fromRGBO(103, 0, 92, 4)),
                  child: const Text(
                    "Register",
                    style: TextStyle(fontSize: 23, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
