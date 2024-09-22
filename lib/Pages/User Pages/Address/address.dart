import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test0/Pages/User Pages/Address/address.dart';
import 'package:test0/Pages/User Pages/Address/add_address.dart';
import 'package:test0/main.dart';

import '../../../Constant/colors.dart';
import '../../../Constant/links.dart';
import '../../../Models/database.dart';
import '../../../Widgets/CustomButton.dart';
import '../../../page.dart';

class address extends StatefulWidget {
  const address({Key? key}) : super(key: key);

  @override
  State<address> createState() => _addressState();
}

class _addressState extends State<address> {
  @override
  var db=database();
  var id;
  Future<dynamic> get_data() async {
     // SharedPreferences prefs = await SharedPreferences.getInstance();
     // id = prefs.getInt('id');
    // var response = await db.postRequest(linkview_address, {'user_id':'$id'});

    return await mybox?.get("Address");
  }
  var _tasks;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // get_data();
    _tasks=get_data();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(onPressed: (){Get.to(()=>page(2));}, icon:const Icon(Icons.arrow_back,size: 30,color: Colors.black,)),
          backgroundColor:Colors.white,
          title: const Text("Address",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 24,),),centerTitle: true,

        ),
      body:Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Center(
            child:FutureBuilder(
          future: _tasks,
          builder: (context, AsyncSnapshot snapshot) {
            print(snapshot.data);
             if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(), );
             } else if (snapshot.hasError) {
             return Center(
                 child: Text("Error: ${snapshot.error}"),);
             } else if (!snapshot.hasData||snapshot.data==null||snapshot.data.length==0) {
                 return Column(
                      children:[
                        const SizedBox(height:40,),
                        Image.asset("images/location.png",height:200,),
                        const SizedBox(height:30,),
                        const Text("What is Your Location?",style: TextStyle(fontSize:30,fontWeight: FontWeight.bold),),
                        const Text("we need to know your location in order to suggest nearby service",textAlign:TextAlign.center,style: TextStyle(color: Colors.black54),)
                        ,CustomButton("Add Location",()async{
                          Get.to(()=>add_address(onPressed: () { Get.to(()=>const address());},));
                        },250.0,45.0)
                      ],
                    );
            }else if(snapshot.hasData) {
               var data=snapshot.data;
                return Stack(
                  children: [
                    Padding(
                      padding:const EdgeInsets.only(right: 5,bottom:20),
                      child: Align(alignment: Alignment.bottomRight,
                        child: FloatingActionButton(
                          onPressed: ()async{
                            var x=await mybox?.get("address_key");
                            print(x);
                            Get.to(()=> add_address(onPressed: () { Get.to(()=>const address()); },));
                          },
                          backgroundColor: purplefav,shape: const CircleBorder(),
                          child: const Icon(Icons.add,color:Colors.white,)),
                      ),
                    ),
                    ListView.builder(itemCount:data.length,shrinkWrap:true,itemBuilder: (context, i) {
                         return Column(
                     children: [
                        ListTile(
                        title:Text("${data[i]['Name_add']}",style: const TextStyle(fontSize: 22,fontWeight: FontWeight.w500),),
                        subtitle:Text("${data[i]['State']},${data[i]['City']} ,${data[i]['Street']}",style: const TextStyle(fontSize:16,color:Colors.black54),),
                        trailing: IconButton(onPressed: ()async{
                           await db.postRequest(linkdelete_address, {'id':'${data[i]['id']}'});
                          setState(() {
                            data.removeAt(i);
                          });
                          },
                        icon: const Icon(Icons.delete),
                        ),),
                        const Divider()
                     ],); },),
                  ],
                );
             }else {
               return const Center(
                 child: Text("Loading.."),
               );
             }
          }))));
  }
}

