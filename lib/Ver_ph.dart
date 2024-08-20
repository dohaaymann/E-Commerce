import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:test0/page.dart';
import 'Bool.dart';

var update=false;
class code_ph extends StatelessWidget {
  @override
  var ver_id,gmail,pass,phone;
  code_ph({super.key, required this.ver_id,required this.phone,}){
    var user = FirebaseAuth.instance.currentUser;
    for (var userInfo in user!.providerData) {
      if (userInfo.providerId == 'phone') {
        update = true;
        break;
      }else {
        update=false;
      }
    }
  }
  final User=FirebaseFirestore.instance.collection("account");
  Color accentPurpleColor = const Color(0xFF6A53A1);
  Color primaryColor = const Color(0xFF121212);
  Color accentPinkColor = const Color(0xFFF99BBD);
  Color accentDarkGreenColor = const Color(0xFF115C49);
  Color accentYellowColor = const Color(0xFFFFB612);
  Color accentOrangeColor = const Color(0xFFEA7A3B);

  Future<void> reauthenticateUser(String smsCode, String verificationId) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    await FirebaseAuth.instance.currentUser?.reauthenticateWithCredential(credential);
  }
  Future<void> updatePhoneNumber(String smsCode, String verificationId) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    await FirebaseAuth.instance.currentUser?.updatePhoneNumber(credential);
  }
  @override
  Widget build(BuildContext context) {
    late BuildContext dialogContext = context;
    TextStyle? createStyle(Color color) {
    ThemeData theme = Theme.of(context);
    return theme.textTheme.displaySmall?.copyWith(color: color);
  }  var otpTextStyles = [
      createStyle(accentPurpleColor),
      createStyle(accentYellowColor),
      createStyle(accentDarkGreenColor),
      createStyle(accentOrangeColor),
      createStyle(accentPinkColor),
      createStyle(accentPurpleColor),
    ];
    var otpController = TextEditingController();

    var dd="";
    var SmsCode;
    final auth=FirebaseAuth.instance;
    return Consumer<provide>(builder: (context, Bool, child) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent,
            leading: IconButton(onPressed: () {
              Navigator.of(context).pop();
            }, icon: const Icon(Icons.arrow_back_ios),)),

        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Verification Code",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text("We Sent you a code.", style: TextStyle(
                          fontSize:18, fontWeight: FontWeight.bold),),
                      Text("Please enter it below.", style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ), const SizedBox(height: 50),

                ShakeWidget(autoPlay: Bool.time,
                  shakeConstant:ShakeCrazyConstant2(),duration: const Duration(milliseconds: 500),
                  child: OtpTextField (
                    numberOfFields: 6,
                    borderColor: accentPurpleColor,
                    focusedBorderColor: accentPurpleColor,
                    styles: otpTextStyles,
                    showFieldAsBox: false,
                    borderWidth: 4.0,
                    onCodeChanged: (String code) {
                      Bool.ch_ver(code);
                    },
                    //runs when every textfield is filled
                    onSubmit: (String verificationCode)async {
                      SmsCode=verificationCode;
                    Bool.ch_ver(verificationCode);
                    },
                  ),
                ),
                const SizedBox(height: 100),
                Row(
                  children: [
                    const Text("Didn't recive any code ?",
                      style: TextStyle(fontSize:16,color: Colors.black54),),
                    TextButton(onPressed: ()async{
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: phone,timeout: const Duration(seconds: 30),
                        verificationCompleted: (PhoneAuthCredential credential) {},
                        verificationFailed: (FirebaseAuthException e) {},
                        codeSent: (String verificationId, int? resendToken) {},
                        codeAutoRetrievalTimeout: (String verificationId) {
                          ver_id=verificationId;
                        },
                      );
                    },
                        child: const Text(
                          "Send again", style: TextStyle(fontSize: 18),))
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(alignment: Alignment.center,
                    child: Bool.ver_ph.toString().length==6?ElevatedButton(style:
                    ElevatedButton.styleFrom(
                        fixedSize: const Size(150, 50),
                        side: const BorderSide(),
                        backgroundColor: const Color.fromRGBO(103, 0, 92, 4)),
                        onPressed: !update?() async{
                      Bool.ch_ver("");
                          try{
                            PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: ver_id, smsCode:SmsCode);
                            auth.currentUser?.linkWithCredential(credential).then((value)async{
                              await FirebaseFirestore.instance.collection("account").doc("${auth.currentUser?.email}").
                            update({"phone":Bool.ph});

                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => page(0),)).then((value){
                              Timer? timer = Timer(const Duration(milliseconds: 3000), (){
                                Navigator.pop(dialogContext);
                              });
                              return showDialog(
                                  context: context,
                                  builder: (BuildContext context) {dialogContext=context;
                                  return
                                    const AlertDialog(insetPadding: EdgeInsets.all(4),
                                        contentPadding: EdgeInsets.all(12),
                                        shape: OutlineInputBorder(
                                            borderSide: BorderSide.none),
                                        backgroundColor: Colors.black,
                                        content: Text(
                                          "Successed", textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.white),)
                                    );
                                  });
                            });});

                          }catch(e){
                            Bool.ch_T_time();
                            Timer(const Duration(milliseconds: 400), (){
                              Bool.ch_F_time();
                            });
                            otpController.clear();
                          }
                        }:() async {
                          Bool.ch_ver("");
                          try {
                            PhoneAuthCredential credential = PhoneAuthProvider
                                .credential(
                              verificationId: ver_id,
                              smsCode: SmsCode,
                            );

                            // Reauthenticate and update the phone number
                            await reauthenticateUser(SmsCode, ver_id);
                            await updatePhoneNumber(SmsCode, ver_id);

                            await FirebaseFirestore.instance
                                .collection("account")
                                .doc("${auth.currentUser?.email}")
                                .update({"phone": Bool.ph});

                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => page(0)))
                                .then((value) {
                              Timer? timer = Timer(
                                  const Duration(milliseconds: 3000), () {
                                Navigator.pop(dialogContext);
                              });
                              return showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  dialogContext = context;
                                  return const AlertDialog(
                                    insetPadding: EdgeInsets.all(4),
                                    contentPadding: EdgeInsets.all(12),
                                    shape: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    backgroundColor: Colors.black,
                                    content: Text(
                                      "Success",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                },
                              );
                            });
                          } catch (e) {
                            if(e=='The supplied credentials do not correspond to the previously signed in user.')
                            {Fluttertoast.showToast(
                                msg:"This phone number is already linked to another account. Please use a different number or sign in with the account that is associated with this phone number.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );}else{
                              Fluttertoast.showToast(
                                  msg:"$e",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                            }
                            Bool.ch_T_time();
                            Timer(const Duration(milliseconds: 400), () {
                              Bool.ch_F_time();
                            });
                            otpController.clear();
                          }
                        }, child: const Text("Confirm", style: TextStyle(color: Colors
                            .white, fontSize: 20),)):ElevatedButton(style:
                    ElevatedButton.styleFrom(
                        fixedSize: const Size(150, 50),
                        side: const BorderSide(),
                        backgroundColor: Colors.grey),
                        onPressed:null,child: const Text("Confirm", style: TextStyle(color: Colors.white, fontSize: 20),)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );});
  }

}
