// import 'package:dio/dio.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:test0/stripe_payment/stripe_keys.dart';
//
// abstract class PaymentManager{
//
//   Future<void> MakePayment(int amount,String currency)async {
//     try{
//       var Clientsecret=await getClientsecret((amount*100).toString(),currency);
//       await _initializePaymentSheet(Clientsecret);
//       await Stripe.instance.presentPaymentSheet();
//     }catch(e){
//       throw Exception(e.toString());
//     }
//
//   }
//   Future _initializePaymentSheet(var Clientsecret)async{
//     await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
//        paymentIntentClientSecret: Clientsecret,
//       merchantDisplayName:"Jw Store"
//     ));
//   }
//   Future getClientsecret(String amount,String currency)async{
//     var dio=Dio();
//     var response= await dio.post(
//       'https://api.stripe.com/v1/payment_intents',
//       options: Options(
//         headers: {
//           'Authorization': 'Bearer ${ApiKeys.secretKey}',
//           'Content-Type': 'application/x-www-form-urlencoded'
//         },
//       ),
//       data: {
//         'amount': amount,
//         'currency': currency,
//       },
//     );
//   }
//
// }