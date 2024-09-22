
import 'dart:io';

import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:test0/Models/database.dart';
import 'package:test0/Models/sql.dart';
import 'package:test0/Pages/Favorite.dart';
import 'package:test0/auth/DeleteAccount.dart';
import 'package:test0/page.dart';
import 'package:test0/splash_screen.dart';
import 'package:test0/stripe_payment/stripe_keys.dart';
import 'Bool.dart';
import 'Constant/productcontroller.dart';
import 'Constant/links.dart';
import 'Models/uploaddata.dart';
import 'Pages/googlemap.dart';
import 'Pages/home.dart';
import 'Pages/cart/cart.dart';
import 'Pages/item.dart';
import 'firebase_options.dart';
import 'onboarding.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';

Box? mybox;
// Box? favbox;
Box? cartbox;
SQLDB sql = SQLDB();
Future<Box> openhivebox(var boxname)async{
  if(Hive.isBoxOpen(boxname)){
    Hive.init((await getApplicationDocumentsDirectory()).path);
  }
  return await Hive.openBox(boxname);
}
set_catagory(){

}
get_products()async{
  var db=database();
  var response = await db.postRequest(linkview, {});
  print("respone::::::::::$response");
  if(response==null){
    await mybox?.put("products", await productcontroller.get_data());
    print("respone");
  }
  else{
    print("cash");
    await mybox?.put("products", response);
  }
}
void main() async {
  // Stripe.publishableKey=ApiKeys.publishedKey;
  WidgetsFlutterBinding.ensureInitialized();
  var appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  // Hive.registerAdapter(DataAdapter());
  mybox=await openhivebox("user_data");
  cartbox=await openhivebox("Cart");
  // favbox=await openhivebox("Favorite");
  await get_products();
  upload_data();
  Platform.isAndroid?
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBkRiFIWAZ6n6DUsevbC_HduQfcaOCqCdo",
      appId: "1:189381920997:android:e718130d8717b8e41fec0c",
      messagingSenderId: "189381920997",
      projectId: "store-291d5",
    ),
  ) :await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await sql.db;
  runApp(ChangeNotifierProvider(
    create: (context) => provide(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "Kanit-Regular",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: mybox!.isNotEmpty?Splash_Screen():Onboarding_1(),
      // home: googlemap(),
      home: page(0),
      routes: {
        "cart": (context) => const cart(),
        // "page":(context) => page(),
        "home": (context) => const home(),
        "Favorite": (context) => const Favorite(),
        'Delete_acc': (context) =>  DeleteAccount(),

      },
    );
  }
}




