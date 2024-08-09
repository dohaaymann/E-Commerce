import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:test0/Bool.dart';

import '../Ver_ph.dart';
final auth=FirebaseAuth.instance;
final User=FirebaseFirestore.instance.collection("account");
class info extends StatelessWidget {

  final _remail=TextEditingController();
  final _phone=TextEditingController();
  final _fname=TextEditingController();
  final _lname=TextEditingController();

  void getdata() async{
    var c= await FirebaseFirestore.instance.collection("account").doc(auth.currentUser?.email).get();
  _fname.text=c.get("fname");
  _lname.text=c.get("lname");
  } info({super.key}){
       getdata();
  }
  Connectivity connectivity = Connectivity();
  @override
  Widget build(BuildContext context) {
    return Consumer<Bool>(builder: (context,Bool, child) {
      return StreamBuilder<ConnectivityResult>(
        stream: connectivity.onConnectivityChanged,
        builder: (context, snapshot) {
          return snapshot.data == ConnectivityResult.none?const forgetpass():
     Scaffold(
        appBar: AppBar(title: const Text("Info",style: TextStyle(fontWeight: FontWeight.bold)),centerTitle: true,backgroundColor: Colors.transparent),
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(left: 10,right: 10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              const Text("First Name",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                TextField(controller:_fname,decoration: const InputDecoration(hintText:"First Name",border:UnderlineInputBorder()),),
              const Padding(padding: EdgeInsets.all(8)),

              const Text("Last Name",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              TextField(controller:_lname,decoration: const InputDecoration(hintText:"Last Name",border: UnderlineInputBorder()),),
              const Padding(padding: EdgeInsets.all(12)),

              const Text("Email",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              TextField( readOnly:true,decoration: InputDecoration(hintText:auth.currentUser!.email,border: const UnderlineInputBorder()),),
              const Padding(padding: EdgeInsets.only(top: 4)),
                  Align(alignment: Alignment.bottomRight,child: ElevatedButton(onPressed: ()async{
                    late BuildContext sdialogContext = context;
                    late BuildContext cdialogContext = context;
                    late BuildContext dialogContext = context;
                    try{
                      await auth.currentUser?.sendEmailVerification().then((value) async{
                        await auth.currentUser?.reload();
                        Timer(const Duration(seconds:5), (){
                          Navigator.pop(sdialogContext);});
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              cdialogContext = context;
                              return Container( color:Colors.black45,height:double.infinity,child: const Center(child:
                              SizedBox(height:50,width:50,child: CircularProgressIndicator(color: Colors.black,strokeWidth:7,))));});

                        Timer(const Duration(seconds: 2), (){
                          Navigator.pop(cdialogContext);
                          showDialog(context: context, builder:(context) {
                            sdialogContext = context;
                            return const AlertDialog(title: Align(alignment:Alignment.center,child: FaIcon(FontAwesomeIcons.solidCircleCheck,color: Colors.green,size: 60,)),
                              contentPadding: EdgeInsets.only(top: 20,bottom: 15,left: 10,right:10),
                              content: Text("Ther verification code has been sent to your email",style: TextStyle(fontSize: 20),textAlign: TextAlign.center,),);
                          },);
                        });
                      }).catchError((e){print(e);});}
                    on FirebaseAuthException catch (e) {
                      Timer? timer = Timer(const Duration(milliseconds: 3000), (){
                        Navigator.pop(dialogContext);
                      });
                      return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            dialogContext=context;
                            return AlertDialog(insetPadding: const EdgeInsets.all(4),contentPadding: const EdgeInsets.all(8),shape: const OutlineInputBorder(borderSide: BorderSide.none),
                                backgroundColor:Colors.black,
                                // backgroundColor:Color.fromRGBO(103, 0, 92,4),
                                content: Text(e.code,textAlign:TextAlign.center,style: const TextStyle(fontWeight:FontWeight.bold,fontSize: 18,color: Colors.white),)
                            );});
                    }

                  },
                      style:ElevatedButton.styleFrom(backgroundColor:const Color.fromRGBO(206,147,216,4) ),
                      child:const Text("Verify email",style: TextStyle(color:Color.fromRGBO(103, 0, 92,4)),)),),
                 const Padding(padding: EdgeInsets.all(6)),
                  IntlPhoneField(controller: _phone,initialValue: auth.currentUser?.phoneNumber,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    ),
                    initialCountryCode: 'EG',
                    onChanged: (phone) {
                      Bool.ch_ph(phone.completeNumber);
                      print(phone.completeNumber);
                    },
                  ),

               Align(alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () async {
                      print(_phone.text);
                      late BuildContext dialogContext = context;
                      late BuildContext sdialogContext = context;
                      late BuildContext cdialogContext = context;
                      if(_phone.text.isNotEmpty){
                      try {
                        await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: "+20${_phone.text}",
                          timeout: const Duration(seconds: 30),
                          verificationCompleted:(PhoneAuthCredential credential) async {print("done");},
                          verificationFailed: (FirebaseAuthException e) {
                            Timer? timer = Timer(const Duration(milliseconds: 3000), (){
                              print("//////////////////////////////////////////////////////");
                              Navigator.pop(dialogContext);
                            });
                            print(("//////////////////$e"));
                            showDialog(
                                // "the phone number provided is incorrect. Please enter the phone number in a format"
                                context: context,
                                builder: (BuildContext context) {dialogContext = context;
                                  return AlertDialog(
                                      insetPadding: const EdgeInsets.all(4),
                                      contentPadding: const EdgeInsets.all(12),
                                      shape: const OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      backgroundColor: Colors.black,
                                      content: Text(
                                        e.code,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.white),
                                      ));
                                });
                          },
                          codeSent: (String verificationId, int? resendToken) {
                            Timer(const Duration(seconds: 3), (){
                              // Navigator.pop(cdialogContext);
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => code_ph(
                                  ver_id: verificationId.toString(),
                                  phone:"+20${Bool.ph}",
                                ),
                              ));
                            });
                            print("==============================${Bool.ph}");

                          },
                          codeAutoRetrievalTimeout: (String verificationId) {},
                        )
                            .catchError((err) {
                          Timer? timer = Timer(const Duration(milliseconds: 3000), (){
                            print("//////////////////////////////////////////////////////");
                            Navigator.pop(dialogContext);
                          });
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
                                      err.message,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.white),
                                    ));
                              });
                        }).then((value) async {
                          Timer(const Duration(seconds:3), (){
                            Navigator.pop(sdialogContext);});
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                cdialogContext = context;
                                return Container( color:Colors.black45,height:double.infinity,child: const Center(child:
                                SizedBox(height:50,width:50,child: CircularProgressIndicator(color: Colors.black,strokeWidth:7,))));});

                          // _phone.text= (auth.currentUser?.phoneNumber)!;
                          print("################+20${_phone.text}");
                          // var c= await User.doc(auth.currentUser?.email).update({"fname":_fname.text,"lname":_lname.text,"phone":_phone.text}).
                          // then((value) {
                          // });
                        });
                      } catch (e) {
                        print("%%%%%%%%%%%%%%5$e");
                        print(Bool.ph);
                      }}else{
                        print("+20${_phone.text}");
                      var c= await User.doc(auth.currentUser?.email).update({"fname":_fname.text,"lname":_lname.text,"phone":_phone.text}).
                      then((value) {
                        Navigator.of(context).pop();
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
                                      "Saved", textAlign: TextAlign.center,
                                      style: TextStyle(fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.white),)
                                );
                              });
                      });
                      }
                    },style:
                      ElevatedButton.styleFrom(fixedSize:const Size(250,50),shape:const StadiumBorder(),backgroundColor:const Color.fromRGBO(103, 0, 92,4)),
                    child: const Text(
                      "Save change",style: TextStyle(fontSize: 22,color: Colors.white),),
                  ),
               ),]),
          ),
        ),
      );},
    );
  });}
}
class forgetpass extends StatelessWidget {
  const forgetpass({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Container(height: double.infinity,
          decoration:const BoxDecoration(color:Colors.white),
          child: Center(child:Column(children: [
            const SizedBox(height: 200,),
            Image.asset("icons/no-wifi.png",height:200),
            const Text("Network Failed",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text("Please check your connection",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black54),),
            ),
          ]) ,),
        )
    );
  }
}
