import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:test0/Widgets/CustomButton.dart';
import 'package:test0/Widgets/CustomText.dart';
import 'package:test0/auth/auth.dart';
import 'package:test0/auth/forget_pass.dart';
import 'package:test0/page.dart';

import '../../main.dart';

class changepassword extends StatefulWidget {
  const changepassword({Key? key}) : super(key: key);

  @override
  State<changepassword> createState() => _changepasswordState();
}

class _changepasswordState extends State<changepassword> {

  Future<Widget> checkProvide() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      for (var userInfo in user.providerData) {
        if (userInfo.providerId == 'password') {
          return changePass(context);
        } else if (userInfo.providerId == 'google.com') {
          return forget_pass();
        } else {
          return Center(
            child: Text('Unsupported authentication provider: ${userInfo.providerId}'),
          );
        }
      }
    }
    return Center(child: Text('No user is signed in.'));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: checkProvide(),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (snapshot.hasData) {
          return snapshot.data!;
        } else {
          return Scaffold(
            body: Center(child: Text('Something went wrong.')),
          );
        }
      },
    );
  }
}

Widget changePass(BuildContext context) {
  var _oldPass = TextEditingController();
  var _newPass = TextEditingController();
  var _confPass = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> updatePassword(BuildContext context, String newPassword, String oldPassword) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      try {
        // Re-authenticate the user
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: oldPassword, // This is the user's current password
        );

        await user.reauthenticateWithCredential(credential);

        // Update the password
        await user.updatePassword(newPassword).then((_)async{
          await FirebaseFirestore.instance.collection("account").doc(auth.currentUser?.email).update({"pass":_newPass.text}).
          then((_)async{
            await mybox?.put("pass", _newPass.text);});
        },);

        // Optionally, sign out the user after the password is updated
        await auth.signOut().then((_){
          Get.to(()=>auth_());
        });

        // Notify the user about the successful password update
        Fluttertoast.showToast(
          msg: "Password updated successfully. Please sign in again.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } catch (e) {
        print("$e");
        if(e.toString()=='[firebase_auth/wrong-password] The password is invalid or the user does not have a password.')
         { Fluttertoast.showToast(
            msg: "The old password you entered is incorrect. Please try again.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );}
        else if(e.toString()=='[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.')
        { Fluttertoast.showToast(
          msg: "Something went wrong. Please try again later.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );}
        else{
        Fluttertoast.showToast(
          msg: "Failed to update password: $e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }}
    }
    else {
      Fluttertoast.showToast(
        msg: "No user is signed in.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  return Scaffold(
    appBar: AppBar(
      title: const Text('Password Change'),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Customtext("Old Password", _oldPass),
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  // Handle forgot password logic
                },
                child: const Text("Forgot Password?"),
              ),
            ),
            Customtext("New Password", _newPass),
            const SizedBox(height: 16),
            Customtext("Confirm Password", _confPass, newPasswordController: _newPass),
            const SizedBox(height: 16),
            CustomButton(
              "SAVE PASSWORD",
                  () async {
                if (_formKey.currentState!.validate()) {
                  await updatePassword(context, _newPass.text, _oldPass.text);
                }
              },
              250.0,
              55.0,
            ),
          ],
        ),
      ),
    ),
  );
}
