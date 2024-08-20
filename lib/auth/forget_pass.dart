import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class forget_pass extends StatelessWidget {
  final _email = TextEditingController();
  final auth=FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  forget_pass({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 20),
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              "Reset Password",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),const Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text("Please enter your email address. We will send you an email to reset your password."
                ,style: TextStyle(fontSize:17),),
            ),
            const Padding(padding: EdgeInsets.all(8)),
            const Padding(
              padding: EdgeInsets.only(left: 8,top: 8),
              child: Text("Email",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            ),
            TextFormField(cursorColor: Colors.indigo,controller: _email,
              decoration:InputDecoration(  hintText: "yours@gmail.com",
                  errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),border: OutlineInputBorder(borderRadius:BorderRadius.circular(20)),
                  suffixIcon:const Padding(
                    padding: EdgeInsets.all(8.0),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.center,
                child: ElevatedButton(onPressed: () async {
                  late BuildContext dialogContext = context;
                  Timer? timer = Timer(const Duration(milliseconds: 4000), (){
                    Navigator.pop(dialogContext);
                  });
                  await auth.
                  sendPasswordResetEmail(email: _email.text)
                      .then((value){
                        return showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        dialogContext=context;
                        return const AlertDialog(
                            insetPadding: EdgeInsets.all(4),
                            contentPadding: EdgeInsets.all(12),
                            shape: OutlineInputBorder(
                                borderSide: BorderSide.none),
                            backgroundColor: Colors.black,
                            // backgroundColor:Color.fromRGBO(103, 0, 92,4),
                            content: Text(
                              "Password reset link send! check your email",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white),
                            ));
                      });
                  }).catchError((e){
                    return showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          dialogContext=context;
                          return AlertDialog(
                              insetPadding: const EdgeInsets.all(4),
                              contentPadding: const EdgeInsets.all(12),
                              shape: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              backgroundColor: Colors.black,
                              // backgroundColor:Color.fromRGBO(103, 0, 92,4),
                              content: Text(
                               e.message,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white),
                              ));
                        });

                  });
                },
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(200, 50),
                      side: const BorderSide(),
                      backgroundColor: const Color.fromRGBO(103, 0, 92, 4)),
                  child: const Text("Send email",style: TextStyle(fontSize: 22, color: Colors.white),),
                ),
              ),
            )
          ])),
    );
  }
}
