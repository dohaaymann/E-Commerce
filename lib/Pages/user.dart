import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Bool.dart';
import '../Constant/links.dart';
import '../Models/database.dart';
import '../auth/auth.dart';
import 'Address/address.dart';
import 'info.dart';
var auth=FirebaseAuth.instance;
class user extends StatelessWidget {
  const user({super.key});

  @override
  Widget build(BuildContext context) {
    user_page(){
    return Center(
      child: Column (
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Image.asset("icons/worlwide.png",height: 130),
          ),
          const Padding(padding: EdgeInsets.all(35)),
          const Text("Sign in to save and view orders ",style: TextStyle(fontSize: 23),),
          const Text("and update your details",style: TextStyle(fontSize: 23),),
          // ElevatedButton(onPressed: (){}, child:Text("")),
          Padding(
            padding: const EdgeInsets.all(15),
            child: ElevatedButton(style:
            ElevatedButton.styleFrom(
                fixedSize:const Size(300,50),side: const BorderSide(),backgroundColor: const Color.fromRGBO(103, 0, 92,4)),
                onPressed: (){
                  Get.to(()=>const auth_());
                }, child:const Text("Go to sign in",style: TextStyle(color:Colors.white,fontSize:23),)),
          ),const SizedBox(height: 90,),
          const Text("Follow Us !",style: TextStyle(fontSize: 20),),
          Row(mainAxisAlignment: MainAxisAlignment.center,children: [
            IconButton(onPressed: ()async{
              // await auth.currentUser?.sendEmailVerification().then((value){print('Email Verification sent! Check your mail box');});
              try{await auth.currentUser?.sendEmailVerification().then((value) => print("done")).catchError((e){print(e);});}
              on FirebaseAuthException catch (e) {
                // if (e.code == 'user-not-found') {
                //   print('No user found for that email.');
                // } else if (e.code == 'wrong-password') {
                //   print('Wrong password provided for that user.');
                print(e); }

            }, icon:FaIcon(FontAwesomeIcons.facebook,color: Colors.blue[900],size:35,)),
            IconButton(onPressed: ()async{

              const url = 'https://www.facebook.com/profile.php?id=100006949608192';
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url));
              } else {
                throw 'Could not launch $url';
              }

            }, icon:const FaIcon(FontAwesomeIcons.instagram,color: Colors.pink,size:35,)),
            IconButton(onPressed: ()async{
              Navigator.of(context).pushNamed("forgotpass");
            }, icon:const FaIcon(FontAwesomeIcons.youtube,color: Colors.red,size:35,)),
          ],)
        ],),
    );}
    Future<dynamic> get_data() async {
      var db=database();
      var response = await db.postRequest(linkget_id, {'email':""});
      return response;
    }
  return StreamBuilder(
    stream: auth.authStateChanges(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return account_page();
      } else {
        return user_page();
      }
    },
  );
  }
}
class account_page extends StatefulWidget {
  account_page({super.key}) {
    auth.currentUser?.reload();
  }

  @override
  State<account_page> createState() => _account_pageState();
}

class _account_pageState extends State<account_page> {
    Future<bool> check() async {
    await auth.currentUser?.reload();
    if (auth.currentUser!.emailVerified) {
      return true;
    } else {
      return false;
    }
  }
    Future<dynamic> get_data() async {
    var db = database();
    var response = await db.postRequest(linkget_id, {'email': "${auth.currentUser!.email}"});
    print( response['data'][0]['id'].runtimeType);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('id', int.parse(response['data'][0]['id']));
    }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_data();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<Bool>(builder: (context, Bool, child) {
      return StreamBuilder(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          return Container(
            color: Colors.grey,
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => Get.to(()=>info()),
                  child: Container(
                    color: Colors.white,
                    margin: const EdgeInsets.only(top: 8, bottom: 8),
                    width: double.infinity,
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Welcome",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8, bottom: 8),
                                  child: Text(
                                    auth.currentUser!.email.toString(),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black54),
                                  ),
                                ),
                              ],
                            ),
                            const Expanded(child: SizedBox()),
                            const Icon(Icons.arrow_forward_ios_outlined, size: 20)
                          ],
                        ),
                        auth.currentUser!.emailVerified
                            ? const SizedBox.shrink()
                            : Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: LinearBorder.none,
                                fixedSize: const Size(250, 40),
                                side: const BorderSide(),
                                backgroundColor:
                                const Color.fromRGBO(206, 147, 216, 4),
                              ),
                              onPressed: () async {
                                Get.to(()=>info());
                              },
                              child: const Text(
                                "Verify your email",
                                style: TextStyle(
                                    fontSize: 20,
                                    color:
                                    Color.fromRGBO(103, 0, 92, 4)),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.all(5),
                        height: 40,
                        child: const Text(
                          "Settings",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 23),
                        ),
                      ),
                      ink("Address", () async {
                         Get.to(()=>const address());
                         // Get.to(()=>CheckoutPage());
                         // Get.to(()=>Shipping());
                         // Get.to(()=>payment_success());
                         // Get.to(()=>order_completed());
                         // Get.to(()=>Payment());
                        print(auth.currentUser?.emailVerified);
                      }),
                      ink("Currency", () async {
                        try {
                          await FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: '+2${01028789903}',
                            timeout: const Duration(seconds: 30),
                            verificationCompleted: (PhoneAuthCredential
                            credential) {},
                            verificationFailed: (FirebaseAuthException e) {},
                            codeSent: (String verificationId,
                                int? resendToken) {
                              PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: "123123");
                              auth.currentUser
                                  ?.linkWithCredential(credential)
                                  .then((value) => print("done"));
                            },
                            codeAutoRetrievalTimeout:
                                (String verificationId) {
                              // ver_id=verificationId;
                            },
                          );
                        } catch (e) {
                          print("/////////////////////////");
                          print(e);
                        }
                      }),
                      ink("Privacy policy", () async {
                        Connectivity connectivity = Connectivity();
                        print(connectivity.onConnectivityChanged);
                        print(connectivity.checkConnectivity());
                        print(connectivity);
                        print("----------------------------------------");
                      }),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top:7, bottom:2),
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.all(5),
                        child: const Text(
                          "Security",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 23),
                        ),
                      ),
                      ink("Delete account", () async {
                        Navigator.of(context).pushNamed("Delete_acc");
                      }),
                    ],
                  ),
                ),
                Card(
                  child: InkWell(
                    onTap: () async {
                      Get.defaultDialog(
                        title: "Sign Out",
                        content: Text("Are you sure you want to sign out?"),
                        onCancel: (){},
                          textConfirm: "Yes",
                        onConfirm:()async{
                          print(auth.currentUser?.email);
                        await auth.signOut().then((value) => Navigator.of(context).pop());}
                      );
                    },
                    child: Container(
                      width: double.maxFinite,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          color: Colors.transparent),
                      height:50,
                      child: const Text(
                        "SIGN OUT",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 23,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    margin: const EdgeInsets.only(top: 2),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const Text(
                          "Follow Us !",
                          style: TextStyle(fontSize: 20),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () async {
                                // context.callmethod
                                const url =
                                    'https://www.facebook.com/profile.php?id=100006949608192';
                                if (await canLaunchUrl(Uri.parse(url))) {
                                  await launchUrl(Uri.parse(url));
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              icon: FaIcon(
                                FontAwesomeIcons.facebook,
                                color: Colors.blue[900],
                                size: 35,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {},
                              icon: const FaIcon(
                                FontAwesomeIcons.instagram,
                                color: Colors.pink,
                                size: 35,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // print(auth.currentUser?.isAnonymous);
                                // print(auth.currentUser?.email);
                              },
                              icon: const FaIcon(
                                FontAwesomeIcons.youtube,
                                color: Colors.red,
                                size: 35,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      );
    });
  }
}
Widget ink(String name,void Function()? onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height:46,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
      ),
      width: double.infinity,
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Text(name, style: const TextStyle(fontSize: 20)),
          const Expanded(child: SizedBox()),
          const Icon(Icons.arrow_forward_ios_outlined, size: 20),
        ],
      ),
    ),
  );
}

