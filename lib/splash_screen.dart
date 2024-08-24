import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test0/Constant/colors.dart';
import 'package:test0/page.dart';

import 'Onboarding.dart';


class Splash_Screen extends StatefulWidget {
  @override
  State<Splash_Screen> createState() => _SplashState();
}

class _SplashState extends State<Splash_Screen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2 , )
      , () => Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => page(0))),
    );
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('icons/woman-jewelry.png'),
              SizedBox(height: 10,),
              Text("JW STORE",style:GoogleFonts.bodoniModa(color:purplefav,fontSize: 40,fontWeight:FontWeight.bold),)
            ],
          ),
        ),
    );
  }
}
