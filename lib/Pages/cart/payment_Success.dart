import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:test0/Constant/colors.dart';
import 'package:test0/Widgets/CustomButton.dart';

import '../../page.dart';

class payment_success extends StatelessWidget {
  const payment_success({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text("Payment",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 24,),),centerTitle: true,
    automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){Get.to(()=>page(0));}, icon:const Icon(Icons.arrow_back,size: 30,color: Colors.black,)),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height:130,),
             CircleAvatar(
               backgroundColor: purplefav,
               radius:70,
               child:const FaIcon(FontAwesomeIcons.check,color: Colors.white,size:70,),),
              const SizedBox(height:15,),
              const Text("Payment Successful!",style: TextStyle(fontSize:30,fontWeight: FontWeight.bold,letterSpacing: 1.5),),
              const SizedBox(height:5,),
              const Text("Thank you for your purchase",style: TextStyle(fontSize:20,color: Colors.grey)),
              const SizedBox(height:200,),
              CustomButton("Continue shopping",(){ Get.to(()=>page(0));},300.0,50.0)



            ],),
        ),
      ),
    );
  }
}
