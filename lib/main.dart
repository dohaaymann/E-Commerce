
import 'dart:io';

import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test0/Models/sql.dart';
import 'package:test0/Pages/Favorite.dart';
import 'package:test0/Ver_ph.dart';
import 'package:test0/auth/DeleteAccount.dart';
import 'package:test0/page.dart';
import 'Bool.dart';
import 'Pages/home.dart';
import 'Pages/cart/cart.dart';
import 'firebase_options.dart';

SQLDB sql = SQLDB();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid?
  await Firebase.initializeApp(
    options: FirebaseOptions(
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
    create: (context) => Bool(),
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
      home: page(0),
      routes: {
        "cart": (context) => const cart(),
        // "page":(context) => page(),
        "home": (context) => const home(),
        "Favorite": (context) => const Favorite(),
        'Delete_acc': (context) =>  DeleteAccount(),
        "Ver_ph": (context) => code_ph(
              ver_id: "",
              phone: "",
            )
      },
    );
  }
}




