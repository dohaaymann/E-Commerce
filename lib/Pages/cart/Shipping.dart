import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test0/Constant/colors.dart';
import 'package:test0/Pages/Address/add_address.dart';
import 'package:test0/Pages/cart/order_completed.dart';
import 'package:test0/Pages/cart/payment_Success.dart';
import 'package:test0/Pages/cart/testtt.dart';
import 'package:test0/Widgets/CustomButton.dart';

import '../../Constant/links.dart';
import '../../Models/Paypal.dart';
import '../../Models/database.dart';
import '../item.dart';
import 'cart.dart';

class Shipping extends StatefulWidget {
  var total,items;
  Shipping(this.total,this.items);

  @override
  State<Shipping> createState() => _ShippingState();
}

class _ShippingState extends State<Shipping> {
  var _tasks,id;
  var db=database();
  get_address()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
     id = prefs.getInt('id');
    var response = await db.postRequest(linkview_address, {'user_id':'$id'});
    return response;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tasks=get_address();
  }
  String selectedPaymentMethod = '';
  String selectedAddress = '';
  String selectedDelivery = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){Get.to(()=>cart());}, icon:Icon(Icons.arrow_back,size: 30,color: Colors.black,)),
        title: Text("Checkout"),),
      body: Container(
        padding: EdgeInsets.all(7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(height: 150,),
            Row(children: [
              Text("ADDRESS",style: TextStyle(fontWeight: FontWeight.w500,fontSize:19),),
              Spacer(),
              TextButton(onPressed: (){
                Get.to(()=>add_address());
              }, child:Text("+ AddNew",style: TextStyle(fontWeight: FontWeight.w500,fontSize:19)))
            ],),
            FutureBuilder(future:_tasks,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(),);
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),);
                } else if (!snapshot.hasData || snapshot.data['data'] == null) {
                  return Container(
                    height: 50,
                    child: Center(child:
                    Text("Add your address to continue payment",
                      style: TextStyle(color: Colors.black54,fontSize:18),)),
                  );
                } else if (snapshot.hasData) {
                  var data = snapshot.data['data'];
                  return ListView.builder(
                    itemCount: data.length,
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedAddress =
                            "${data[i]['State']},${data[i]['City']} ,${data[i]['Street']}";
                          });
                        },
                        child: Card(
                          color: selectedAddress ==
                              "${data[i]['State']},${data[i]['City']} ,${data[i]['Street']}"
                              ? purplefav.withOpacity(0.4)
                              : null,
                          child: ListTile(
                            title: Text("${data[i]['Name_add']}",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w500),),
                            subtitle: Text(
                              "${data[i]['State']},${data[i]['City']} ,${data[i]['Street']}",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black54),),
                          ),),
                      );
                    },);
                } else {}
                return add_address();
              }),
                SizedBox(height: 20,),
            Text("Payment Method",style: TextStyle(fontWeight: FontWeight.w500,fontSize:19),),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(onTap: () {
                   setState(() {
                     selectedPaymentMethod="Paypal";
                   });
                  },
                    child: Card(
                      color:selectedPaymentMethod=="Paypal"? purplefav.withOpacity(0.4) : null,
                      child: Container(
                        height:50,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(7),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("images/paypal.png",height:30,),
                                Text(" Paypal",style: TextStyle(fontSize:18),)
                              ],  ),),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPaymentMethod="Cash";
                      });
                    },
                    child: Card(
                      color:selectedPaymentMethod=="Cash"? purplefav.withOpacity(0.4) : null,
                      child: Container(
                        height:50,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(7),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(FontAwesomeIcons.moneyBill,color: Colors.red),
                                Text("   Cash",style: TextStyle(fontSize:18,),)
                              ],  ),),
                    ),
                  ),
                )
            ],),

             SizedBox(height: 20,),
            Text("DELIVERY ESTIMATE",style: TextStyle(fontWeight: FontWeight.w500,fontSize:19),),
            GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDelivery="Instant Delivery";
                  });
                },
                child: Card(
                  color: selectedDelivery== 'Instant Delivery' ? purplefav.withOpacity(0.4) : null,
                  child: ListTile(
                    leading: Icon(FontAwesomeIcons.vanShuttle),
                    title:Text("Instant Delivery",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500),),
                    subtitle:Text("1-2 Day",style: TextStyle(fontSize:16,color:Colors.black54),),
                  ),),
              ),
            GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDelivery="Standard Delivery";
                  });
                },
                child: Card(
                  color: selectedDelivery== 'Standard Delivery' ? purplefav.withOpacity(0.4) : null,
                  child: ListTile(
                    leading: Icon(FontAwesomeIcons.vanShuttle),
                    title:Text("Standard Delivery",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500),),
                    subtitle:Text("Same Day",style: TextStyle(fontSize:16,color:Colors.black54),),
                  ),),
              ),
            Spacer(),
            CustomButton("Confirm and Continue",
                selectedDelivery!=''&&selectedPaymentMethod!=''&&selectedAddress!=''?(){
                    selectedPaymentMethod=='Paypal'?
                     Get.to(()=>paypal("${widget.total}",widget.items)):
                     Get.to(()=>order_completed());}:null
                ,MediaQuery.of(context).size.width,50.0),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}
