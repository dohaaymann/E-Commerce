import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otp_text_field_v2/otp_field_v2.dart';
import 'package:provider/provider.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:test0/page.dart';
import '../../Bool.dart';
import '../../Bool.dart';
import '../../Constant/colors.dart';
import '../../Widgets/CustomButton.dart';

var update = false;

class code_ph extends StatefulWidget {
   var verId, phone;
  code_ph({super.key, required this.verId, required this.phone}) {
    var user = FirebaseAuth.instance.currentUser;
    for (var userInfo in user!.providerData) {
      if (userInfo.providerId == 'phone') {
        update = true;
        break;
      } else {
        update = false;
      }
    }
  }

  @override
  State<code_ph> createState() => _code_phState();
}

class _code_phState extends State<code_ph> {
  final userCollection = FirebaseFirestore.instance.collection("account");

  Color accentPurpleColor = const Color(0xFF6A53A1);
  Color primaryColor = const Color(0xFF121212);
  Color accentPinkColor = const Color(0xFFF99BBD);
  Color accentDarkGreenColor = const Color(0xFF115C49);
  Color accentYellowColor = const Color(0xFFFFB612);
  Color accentOrangeColor = const Color(0xFFEA7A3B);

  Future<void> reauthenticateUser(String smsCode, String verificationId) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: "AD8T5Iu8iMlMLC0WivC2MZM-jv7JbD9_ZPFFeN1O8pc1gX53VsphBjtzYaOv0qZhBVv71WGFsqcHbrkiPcKQL-coreRaL3yP1CAhHtGHF1rp3jix27UuvNTxKSCnJj5FMdzLQRMe9JqcS3GO-S6lVIsiZCClMDNwrSjlP87MF69YZD6T5v2rtEx6iHFFYUFTyKinjXTuq71DABmuHTmpNlR3lzuMseh4wNdR8p38OtYMcaNzMjtYaok",
      smsCode: smsCode,
    );

    await FirebaseAuth.instance.currentUser?.reauthenticateWithCredential(credential).then((_)async{
      await updatePhoneNumber(smsCode,"AD8T5Iu8iMlMLC0WivC2MZM-jv7JbD9_ZPFFeN1O8pc1gX53VsphBjtzYaOv0qZhBVv71WGFsqcHbrkiPcKQL-coreRaL3yP1CAhHtGHF1rp3jix27UuvNTxKSCnJj5FMdzLQRMe9JqcS3GO-S6lVIsiZCClMDNwrSjlP87MF69YZD6T5v2rtEx6iHFFYUFTyKinjXTuq71DABmuHTmpNlR3lzuMseh4wNdR8p38OtYMcaNzMjtYaok").then((_) {
        print("phhhone updated");
      },);
    },);
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
    TextStyle? createStyle(Color color) {
      ThemeData theme = Theme.of(context);
      return theme.textTheme.displaySmall?.copyWith(color: color);
    }

    var otpController = TextEditingController();
    var smsCode;
    var isError = false;
    final auth = FirebaseAuth.instance;

    return Consumer<provide>(builder: (context, Bool, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Verification Code",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "We Sent you a code.",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Please enter it below.",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                ShakeWidget(
                  autoPlay: Bool.time,
                  shakeConstant: ShakeCrazyConstant2(),
                  duration: const Duration(milliseconds: 500),
                  child: OTPTextFieldV2(
                    length: 6,
                    width: MediaQuery.of(context).size.width,
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldStyle: FieldStyle.underline,
                    outlineBorderRadius: 15,
                    style: TextStyle(fontSize: 35, color: purplefav),
                    onChanged: (pin) {
                      setState(() {
                        isError = false;
                      });
                      Bool.ch_ver(pin);
                    },
                    onCompleted: (pin) {
                      smsCode = pin;
                      Bool.ch_ver(pin);
                      print("Completed: $pin");
                    },
                    hasError: isError,
                  ),
                ),
                const SizedBox(height: 100),
                Row(
                  children: [
                    const Text(
                      "Didn't receive any code?",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    TextButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: widget.phone,
                          timeout: const Duration(seconds: 30),
                          verificationCompleted: (PhoneAuthCredential credential) {},
                          verificationFailed: (FirebaseAuthException e) {
                            setState(() {
                              isError = true;
                            });
                          },
                          codeSent: (String verificationId, int? resendToken) {
                            setState(() {
                              widget.verId = verificationId;
                            });
                          },
                          codeAutoRetrievalTimeout: (String verificationId) {
                            setState(() {
                              widget.verId = verificationId;
                            });
                          },
                        );
                      },
                      child: const Text(
                        "Send again",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Bool.ver_ph.toString().length == 6
                        ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(150, 50),
                        side: const BorderSide(),
                        backgroundColor: const Color.fromRGBO(103, 0, 92, 4),
                      ),
                      onPressed: !update
                          ? () async {
                        try {
                          PhoneAuthCredential credential = PhoneAuthProvider.credential(
                            verificationId: widget.verId,
                            smsCode: Bool.ver_ph,
                          );

                          await auth.currentUser?.linkWithCredential(credential).then((value) async {
                            await userCollection.doc("${auth.currentUser?.email}")
                                .update({"phone": Bool.ph});

                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Align(
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      "icons/verify (1).png",
                                      height: 100,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.only(
                                      top: 20, bottom: 15, left: 10, right: 10),
                                  content: const Text(
                                    "You have successfully verified your phone number!",
                                    style: TextStyle(fontSize: 20),
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: [
                                    Center(
                                      child: CustomButton(
                                        "Done",
                                            () {
                                          Navigator.of(context).pop();
                                        },
                                        100.0,
                                        45.0,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          });
                        } catch (e) {
                          Bool.ch_T_time();
                          Timer(const Duration(milliseconds: 400), () {
                            Bool.ch_F_time();
                          });
                          otpController.clear();
                        }
                      }
                          : () async {
                         print("change");
                        print(Bool.ver_ph);
                        print(widget.verId);
                        try {
                          await reauthenticateUser(Bool.ver_ph,Bool.ver_ph);

                          await userCollection.doc("${auth.currentUser?.email}")
                              .update({"phone": Bool.ph});

                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => page(0)),
                          ).then((value) {
                            Timer? timer = Timer(
                                const Duration(milliseconds: 3000), () {
                              Navigator.pop(context);
                            });

                            return showDialog(
                              context: context,
                              builder: (BuildContext context) {
                              return AlertDialog(
                                title: Align(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    "icons/verify (1).png",
                                    height: 100,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.only(
                                    top: 20, bottom: 15, left: 10, right: 10),
                                content: const Text(
                                  "Phone number changed successfully",
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                                actions: [
                                  Center(
                                    child: CustomButton(
                                      "Done",
                                          () {
                                        Navigator.of(context).pop();
                                      },
                                      100.0,
                                      45.0,
                                    ),
                                  ),
                                ],
                              );

                            },
                            );
                          });
                        } catch (e) {
                          String errorMessage = e.toString();
                          if (errorMessage.contains('The supplied credentials do not correspond to the previously signed in user.')) {
                            Fluttertoast.showToast(
                              msg: "This phone number is already linked to another account. Please use a different number or sign in with the account that is associated with this phone number.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          } else {
                            print("$errorMessage");
                            print("$isError");
                            Fluttertoast.showToast(
                              msg: errorMessage,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }

                          Bool.ch_T_time();
                          Timer(const Duration(milliseconds: 400), () {
                            Bool.ch_F_time();
                          });
                          otpController.clear();
                        }
                      },
                      child: const Text(
                        "Confirm",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )
                        : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(150, 50),
                        side: const BorderSide(),
                        backgroundColor: Colors.grey,
                      ),
                      onPressed: null,
                      child: const Text(
                        "Confirm",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
