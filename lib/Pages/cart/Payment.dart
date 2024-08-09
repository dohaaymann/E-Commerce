import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:test0/Widgets/CustomButton.dart';

import '../../Constant/colors.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  String selectedPaymentMethod = 'Cash';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
       const Text("Cash",style: TextStyle(fontSize:19,fontWeight: FontWeight.w800),),
        Card(
          color: Colors.white,
          child:
          ListTile(
            leading:Icon(FontAwesomeIcons.moneyBill,color: purplefav,),
              title:const Text("Cash",style: TextStyle(color: Colors.black54),),
            trailing:Radio(
              onChanged: (value) {
              
            }, groupValue: selectedPaymentMethod,  value: 'Cash',
              activeColor: purplefav,
            ),
          ),
        ),

       const SizedBox(height: 20,),
          const Text("Wallet",style: TextStyle(fontSize:19,fontWeight: FontWeight.w800),),
        Card(
          color: Colors.white,
          child:
          ListTile(
            leading:Icon(FontAwesomeIcons.wallet,color: purplefav,),
              title:const Text("Wallet",style: TextStyle(color: Colors.black54),),
            trailing:Radio(
              onChanged: (value) {

            }, groupValue: selectedPaymentMethod,  value: 'Cash',
              activeColor: purplefav,
            ),
          ),
        ),

          const SizedBox(height: 20,),
        const Text("Credit & Debit Card",style: TextStyle(fontSize:19,fontWeight: FontWeight.w800),),
        Card(
          color: Colors.white,
          child:
          ListTile(
            leading:Icon(FontAwesomeIcons.solidCreditCard,color: purplefav,),
              title:const Text("Add Card",style: TextStyle(color: Colors.black54),),
            trailing:IconButton(onPressed: (){}, icon:Icon(Icons.arrow_forward_ios_outlined,color: purplefav,))
          ),
        ),

        const SizedBox(height: 20,),
        const Text("More Payment Options",style: TextStyle(fontSize:19,fontWeight: FontWeight.w800),),
        Card(
          color: Colors.white,
          child:
          ListTile(
            leading:const Icon(FontAwesomeIcons.paypal,color: Colors.blue,),
              title:const Text("Paypa;",style: TextStyle(color: Colors.black54),),
            trailing:Radio(
              onChanged: (value) {

            }, groupValue: selectedPaymentMethod,  value: 'Cash',
              activeColor: purplefav,
            ),
          ),
        ),

       const Spacer(),
       CustomButton("Confirm and Continue",(){},MediaQuery.of(context).size.width,60.0),
       const SizedBox(height: 20,)

      ],),
    );
  }
}
