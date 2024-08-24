// import 'package:fancy_otp_text_fields/otp_text_fields_widget.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:otp_text_field_v2/otp_field_v2.dart';
// import '../../Constant/colors.dart';
//
// class MyImageWidget extends StatefulWidget {
//
//
//   MyImageWidget();
//
//   @override
//   _MyImageWidgetState createState() => _MyImageWidgetState();
// }
// Future<List<dynamic>> get_Fav() async {
//   var favoritesBox = Hive.box('Favorite');
//   List<dynamic> allFavorites = favoritesBox.values.toList();
//   // await Future.delayed(Duration(seconds: 2)); // Simulated delay
//   return allFavorites;
// }
// class _MyImageWidgetState extends State<MyImageWidget> {
//   String? imageUrl;
// var otpController;
//   _getImageUrl(String imageName) async {
//     try {
//       // Construct the reference to the file within the specific folder
//       var ref = await FirebaseStorage.instance
//           .ref()
//           .child('Adley-Bracelet-768x768.jpg');
//       var url = await ref.getDownloadURL();
//       print(url);
//       return url;
//     } catch (e) {
//       print("////$e"); //
//     }
//   }
//
//
//
//   @override
//   void initState() {
//     super.initState();
//     // _loadImage();
//   }
//
//   // Future<void> _loadImage() async {
//   //   var url = await _getImageUrl(widget.imageName);
//   //   setState(() {
//   //     imageUrl = url;
//   //   });
//   // }
//   OtpTextFieldsController otpTextFieldsController = OtpTextFieldsController();
//
//   void changeMode(OtpState otpState) {
//     // changing mode for changing design
//     // modes=> {success,loading,error,normal}  otpTextFieldsController.currentState.value = otpState;
//   }
//
//   void changeOtpValues(String otpValue) {
//     // if you have auto fill sms you should use this
//     otpTextFieldsController.otpValue.value = otpValue;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SingleChildScrollView(
//         physics: const AlwaysScrollableScrollPhysics(),
//     child: Container(padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
//     child: Column(crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//     const Text("Verification Code",
//     style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),),
//     const Padding(
//     padding: EdgeInsets.all(8.0),
//     child: Column(
//     children: [
//     Text("We Sent you a code.", style: TextStyle(
//     fontSize:18, fontWeight: FontWeight.bold),),
//     Text("Please enter it below.", style: TextStyle(
//     fontSize: 18, fontWeight: FontWeight.bold),),
//     ],
//     ),
//     ), const SizedBox(height: 50),
//       OTPTextFieldV2(
//         controller: otpController,
//         length: 5,
//         width: MediaQuery.of(context).size.width,
//         textFieldAlignment: MainAxisAlignment.spaceAround,
//         fieldWidth:55,
//         fieldStyle: FieldStyle.underline,
//         outlineBorderRadius: 15,
//         style: TextStyle(fontSize:35,color: purplefav),
//         onChanged: (pin) {
//           print("Changed: " + pin);
//         },
//         onCompleted: (pin) {
//           print("Completed: " + pin);
//         },hasError:false,
//       ),
//       Text("${otpController}")
//       ]),
//     )));
//   }
//   TextStyle defaultTextStyle(BuildContext context, String style) {
//     // Define your logic for different text styles here
//     switch (style) {
//       case 'blwd2':
//         return TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black);
//       default:
//         return TextStyle(fontSize: 18, color: Colors.black);
//     }
//   }
//   // OtpTextFields(
//   // onChanged: (otpValue, isFinished) {
//   //
//   // },onSubmitKeyboardPressed: () {
//   //
//   // },
//   // otpLength:5,
//   // otpTextFieldsController: OtpTextFieldsController(),
//   // defaultTextStyle: const TextStyle(fontSize:30, color: Colors.black),
//   // // textStyleLoading: defaultTextStyle(context, StyleText.blwd2).copyWith(color: Colors.grey),
//   // textStyleSuccess: defaultTextStyle(context, StyleText.blwd2).copyWith(color: Colors.green),
//   // textStyleError: defaultTextStyle(context, StyleText.blwd2).copyWith(color: Colors.red),
//   // textStyleActive: defaultTextStyle(context, StyleText.blwd2).copyWith(color: Colors.blue),
//   // decorationSuccessBox: BoxDecoration(color: Colors.greenAccent),
//   // decorationErrorBox: BoxDecoration(color: Colors.redAccent),
//   // decorationLoadingBox: BoxDecoration(color: Colors.grey),
//   // decorationActiveBox: BoxDecoration(color: Colors.blueAccent),
//   // decorationFilledBox: BoxDecoration(color: Colors.black12),
//   // decorationEmptyBox: BoxDecoration(color:Color(0xFFF99BBD).withOpacity(0.3)),
//   // ),
// } class StyleText {
//   static const String blwd2 = 'blwd2';
// }