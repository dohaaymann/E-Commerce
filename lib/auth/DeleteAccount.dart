import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter/material.dart';

import '../page.dart';

class DeleteAccount extends StatelessWidget {
  @override
  DeleteAccount({super.key});
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(title:const Text("Delete account",style: TextStyle(fontWeight: FontWeight.bold),),centerTitle: true,),
            body:Container(height: double.infinity,
              decoration:const BoxDecoration(color:Colors.white),
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
                          Container(margin: const EdgeInsets.only(bottom: 8),height:70,color: Colors.yellow,child: const Row(children: [
                            Padding(
                              padding: EdgeInsets.only(left: 8,right: 8),
                              child: FaIcon(FontAwesomeIcons.table,size:30,),
                            ),
                            Text("Lose Your order history",style: TextStyle(fontSize: 18),),]),
                          ),
                          Container( margin: const EdgeInsets.only(bottom: 8),height:70,
                            color: Colors.yellow,child: const Row(children: [
                            Padding(
                              padding: EdgeInsets.only(left: 8,right: 8),
                              child: FaIcon(FontAwesomeIcons.user,size:30,),
                            ),
                            Text("Erase all your personal infornation",style: TextStyle(fontSize: 18),),]),
                          ),
                          Container( margin: const EdgeInsets.only(bottom: 8),height:70,
                            color: Colors.yellow,child: const Row(children: [
                              Padding(
                                padding: EdgeInsets.only(left: 8,right: 8),
                                child: FaIcon(FontAwesomeIcons.heart,size:30,),
                              ),
                              Text("Lose Your favorites",style: TextStyle(fontSize: 18),),]),
                          ),
                        ],),
                      ),
                      Spacer(),
                      Card(child:  InkWell(onTap:()async{
                        await auth.currentUser?.delete().then((value)async {
                          // await FirebaseFirestore.instance.collection("account").doc(auth.currentUser?.email).delete().then((value) => print("done"));
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => page(2),));
                        }).catchError((e){print("#############$e");});
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