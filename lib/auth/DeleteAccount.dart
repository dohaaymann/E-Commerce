import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test0/auth/auth.dart';

import '../page.dart';

class DeleteAccount extends StatelessWidget {
  @override
  DeleteAccount({super.key});
  final auth = FirebaseAuth.instance;
  Future<void> _reauthenticateUser(BuildContext context) async {
    User? user = auth.currentUser;
    if (user != null) {
      try {
        // Assuming the user signed in with email and password.
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: "123123", // Function to get user's password
        );

        // Reauthenticate the user
        await user.reauthenticateWithCredential(credential);
      } catch (e) {
        // Show error message or handle error
      }
    }
  }
  List privacy=["Lose Your order history","Erase all your personal information","Lose Your favorites"];
  @override
  Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(title:const Text("Delete account",style: TextStyle(fontWeight: FontWeight.bold),),centerTitle: true,),
            body:Container(height: double.infinity,
              decoration: const BoxDecoration(color:Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    const Text("You are about to delete your account.",style: TextStyle(fontSize:18),),
                  const Padding(
                    padding: EdgeInsets.only(top: 12.0,bottom: 12),
                    child: Text("Just so you know,whem you delete your account ,you will..",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  ),
                      SizedBox(height: 400,
                        child: ListView(children: [
                          for(int i=0;i<privacy.length;i++)
                          Container(margin: const EdgeInsets.only(bottom: 8),height:70,color: Colors.yellow,child:  Row(children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 8,right: 8),
                              child: FaIcon(FontAwesomeIcons.table,size:30,),
                            ),
                            Text("${privacy[i]}",style: const TextStyle(fontSize: 18),),]),
                          ),
                        ],),
                      ),
                      const Spacer(),
                      Card(child:  InkWell(onTap:()async{
                        Get.defaultDialog(
                          title:"Delete Acoount",content:const Text("Are You sure that you want to delete this account?" ,textAlign: TextAlign.center,
                            style:TextStyle(fontSize: 19),),
                          onCancel: () {},
                          onConfirm: ()async{
                            await _reauthenticateUser(context); // Reauthenticate user
                            await auth.currentUser?.delete().then((value) async {
                              Get.to(()=> auth_());
                              await FirebaseFirestore.instance
                                  .collection("account")
                                  .doc("${FirebaseAuth.instance.currentUser!.email}").delete();
                              // Navigate to another page after successful deletion

                            }).catchError((e) {
                            });
                          },textConfirm: "Delete"
                        );
                      },
                          child: Container(width: double.maxFinite,alignment: Alignment.center,
                            decoration:BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.grey),
                            height:60,child:const Text("DELETE ACCOUNT",style: TextStyle(color:Colors.red,fontSize: 23,fontWeight: FontWeight.bold),),)),)
                ]),
              ),
            )
        );
    }
}
