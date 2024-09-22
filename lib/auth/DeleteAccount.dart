import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test0/auth/auth.dart';

import '../main.dart';
import '../page.dart';

class DeleteAccount extends StatelessWidget {
  DeleteAccount({super.key});
  final auth = FirebaseAuth.instance;

  Future<void> reauthenticategoogle() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final GoogleSignIn googleSignIn = GoogleSignIn();
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
        if (googleUser != null) {
          final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          // Re-authenticate the user
          await user.reauthenticateWithCredential(credential);

          // Now delete the account
          await deleteUserAccount();
        }
      }
    } catch (e) {
      print('Error during re-authentication: $e');
      // Fluttertoast.showToast(
      //   msg: "Error during re-authentication: $e",
      //   toastLength: Toast.LENGTH_LONG,
      //   gravity: ToastGravity.BOTTOM,
      //   backgroundColor: Colors.red,
      //   textColor: Colors.white,
      //   fontSize: 16.0,
      // );
    }
  }

  Future<void> deleteUserAccount() async {
    try {
      // Get the currently signed-in user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Delete the user's account
        await user.delete().then((value) async {
          print("deleted");
          Get.to(() => page(0));
          await FirebaseFirestore.instance
              .collection("account")
              .doc(user.email)
              .delete();
        });

        // Sign out the user after deletion
        await FirebaseAuth.instance.signOut().then((_) {
          Fluttertoast.showToast(
            msg: "Account deleted successfully.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        },);
      } else {
        Fluttertoast.showToast(
          msg: "No user is signed in.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle errors here, such as re-authentication requirement
      if (e.code == 'requires-recent-login') {
        Fluttertoast.showToast(
          msg: "You need to re-authenticate before deleting your account.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        // Re-authenticate the user before trying to delete the account again
      } else {

      }
    }
  }

  Future<void> _reauthenticateUser(BuildContext context) async {
    User? user = auth.currentUser;
    if (user != null) {
      try {
        // Assuming the user signed in with email and password.
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: "${await mybox?.get("pass")}", // Function to get user's password
        );
        await user.reauthenticateWithCredential(credential);
        await deleteUserAccount();
      } catch (e) {
        Fluttertoast.showToast(
          msg: "$e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }

  List<String> privacy = [
    "Lose Your order history",
    "Erase all your personal information",
    "Lose Your favorites"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Delete account",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "You are about to delete your account.",
                style: TextStyle(fontSize: 18),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 12.0, bottom: 12),
                child: Text(
                  "Just so you know, when you delete your account, you will...",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 400,
                child: ListView.builder(
                  itemCount: privacy.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      height: 70,
                      color: Colors.yellow,
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: FaIcon(FontAwesomeIcons.table, size: 30),
                          ),
                          Text(
                            privacy[index],
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const Spacer(),
              Card(
                child: InkWell(
                  onTap: () async {
                    Get.defaultDialog(
                      title: "Delete Account",
                      content: const Text(
                        "Are you sure that you want to delete this account?",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 19),
                      ),
                      onCancel: () {},
                      onConfirm: () async {
                        try {
                          var user = FirebaseAuth.instance.currentUser;
                          for (var userInfo in user!.providerData) {
                            if (userInfo.providerId == 'password') {
                              _reauthenticateUser(context);
                              print('This user is authenticated with email and password.');
                            } else if (userInfo.providerId == 'google.com') {
                              await reauthenticategoogle();
                              print('This user is authenticated with Google.');
                            } else {
                              print('This user is authenticated with another provider: ${userInfo.providerId}');
                            }
                          }
                        } catch (e) {
                          Navigator.of(context).pop();
                          Fluttertoast.showToast(
                            msg: "Something went wrong. Please try again later.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      },
                      textConfirm: "Delete",
                    );
                  },
                  child: Container(
                    width: double.maxFinite,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey,
                    ),
                    height: 60,
                    child: const Text(
                      "DELETE ACCOUNT",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 23,
                          fontWeight: FontWeight.bold),
                    ),
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
