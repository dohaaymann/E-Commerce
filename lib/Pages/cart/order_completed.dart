import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Widgets/CustomButton.dart';
import '../../page.dart';

class order_completed extends StatelessWidget {
  const order_completed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child:Center(
          child: Column(
            children: [
              const SizedBox(height: 20,),
              const Text("Order Completed",style: TextStyle(fontSize:35,fontWeight: FontWeight.bold,letterSpacing: 1.5),),
              const SizedBox(height: 60,),
              Image.asset("icons/online-shopping.png",height:150,),
              const SizedBox(height:20,),
              const Text("Thank you for your purchase.",style: TextStyle(fontSize:20,color: Colors.grey),),
              const Text("You can view your order in 'My Orders' section.",textAlign:TextAlign.center,style: TextStyle(fontSize:20,color: Colors.grey),),
              const SizedBox(height: 50,),
              CustomButton("Continue shopping",(){ Get.to(()=>page(0));},300.0,50.0)



            ]
        ),
        )
        ,),
    );
  }
}
