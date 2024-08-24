import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test0/Pages/User Pages/Address/address.dart';
import 'package:test0/Widgets/CustomButton.dart';
import '../../../Constant/links.dart';
import '../../../Models/database.dart';

class add_address extends StatefulWidget {
  final VoidCallback onPressed;
   const add_address({super.key, required this.onPressed});

  @override
  State<add_address> createState() => _add_addressState();
}

class _add_addressState extends State<add_address> {
  @override
  var id;
  get_id()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getInt('id');
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_id();
  }
  @override
  var state,city;
  var street=TextEditingController();
  var name_add=TextEditingController();
  var db=database();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter Your Address",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 24,),),centerTitle: true,
    ),
      body:Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(children: [
          CSCPicker(defaultCountry: CscCountry.Egypt,disableCountry: true,
            showStates: true,
            showCities: true,
            ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
            flagState: CountryFlag.ENABLE,
            dropdownDecoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300, width: 1)),
            ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
            disabledDropdownDecoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: Colors.grey.shade300,
                border: Border.all(color: Colors.grey.shade300, width: 1)),

            ///placeholders for dropdown search field
            countrySearchPlaceholder: "Country",
            stateSearchPlaceholder: "State",
            citySearchPlaceholder: "City",

            ///labels for dropdown
            countryDropdownLabel: "Country",
            stateDropdownLabel: "State",
            cityDropdownLabel: "City",
            selectedItemStyle: const TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
            dropdownHeadingStyle: const TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.bold),
            dropdownItemStyle: const TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
            dropdownDialogRadius: 10.0,
            searchBarRadius: 10.0,
            ///triggers once state selected in dropdown
            onStateChanged: (value) {
              setState(() {                  ///store value in state variable
                state = value;
              });
            },onCountryChanged: (value) {
              setState(() {                  ///store value in state variable
                state = value;
              });
            },
            onCityChanged: (value) {
              setState(() {
                city = value;
                setState(() {
                  double x=1;
                  // p_address = "$p_cityValue, $p_stateValue";
                  // d_address = "$d_cityValue, $d_stateValue";
                  // Booking.add(book_l(id:x, pickup: p_address, drop:d_address,date_time: "0.25"));
                });
              });
            },
          ),
          const SizedBox(height:10,),
          Container(
            alignment: Alignment.center,
            color: Colors.white,
            height:50,
            child: TextField(
                cursorColor: Colors.indigo,controller: street,
                onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                onChanged: (v) {
                  setState(() {
                    // semail = v;
                  });
                },style: const TextStyle(fontSize:17),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white54),
                      borderRadius: BorderRadius.circular(5)),
                  hintText: "Street",
                )),
          ),
          const SizedBox(height:10,),
          Container(
            alignment: Alignment.center,
            color: Colors.white,
            height:50,
            child: TextField(
                cursorColor: Colors.indigo,controller: name_add,
                onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                onChanged: (v) {
                  setState(() {
                    // semail = v;
                  });
                },style: const TextStyle(fontSize:17),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white54),
                      borderRadius: BorderRadius.circular(5)),
                  hintText: "Name of Address",
                )),
          ),
          const SizedBox(height:30,),
          CustomButton("Add",street.text.isNotEmpty&&name_add.text.isNotEmpty ?
                  ()async{
            var response = await db.postRequest(linkadd_address, {
              'user_id':"$id",
               'State':"$state??''",
               'City':"${city??''}",
               'Street':street.text,
               'Name_add':name_add.text,
            }).then((value) {
              // Fluttertoast.showToast(
              //     msg: "This is Center Short Toast",
              //     toastLength: Toast.LENGTH_SHORT,
              //     gravity: ToastGravity.CENTER,
              //     timeInSecForIosWeb: 1,
              //     backgroundColor: Colors.red,
              //     textColor: Colors.white,
              //     fontSize: 16.0
              // );
              // Navigator.of(context).pop();
              Get.to(()=>const address());
            });
          }:null,250.0,40.0)
        ],),
      ),
    );
  }
}
