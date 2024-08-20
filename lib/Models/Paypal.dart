import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:get/get.dart';
import 'package:test0/Pages/cart/payment_Success.dart';
import 'package:test0/page.dart';

class paypal extends StatefulWidget {
  var total,items;
   paypal(this.total,this.items, {super.key});

  @override
  State<paypal> createState() => _paypalState();
}

class _paypalState extends State<paypal> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return PaypalCheckout(
                sandboxMode: true,
                clientId: "AbuYTRln2SCzRUfTz4An-w27-1Kz5yGX9WQFE0bI_fcSeiedpHD0yX0I1djn7YUJlsmQA3UVm-iRyms1",
                secretKey: "ECwowM73AjfnGmODfm2x13ijS04OpnOZd-jz_WT_EyhJpclq12c0eXju7rDIUZzkwcuOVMM3z8h4UAvB",
                returnURL: "www.success.snippetcoder.com",
                cancelURL: "www.cancel.snippetcoder.com",
                transactions:[
                  {
                    "amount": {
                      "total": '${widget.total}',
                      "currency": "USD",
                      "details": {
                        "subtotal": '${widget.total}',
                        "shipping": '0',
                        "shipping_discount": 0
                      }
                    },
                    "description": "The payment transaction description.",
                    "payment_options": const {
                      "allowed_payment_method":
                          "INSTANT_FUNDING_SOURCE"
                    },

                    "item_list": {
                      "items": [
                        for(int i=0;i<widget.items.length;i++)
                        {
                          // "id":"${widget.items[i]['id']}",
                          "name": "${widget.items[i]['name']}",
                          "quantity":widget.items[i]['quantity'],
                          "price": "${widget.items[i]['price']}"  ,
                          "currency": "USD"
                        }
                      ],
                      // shipping address is not required though
                      //   "shipping_address": {
                      //     "recipient_name": "Raman Singh",
                      //     "line1": "Delhi",
                      //     "line2": "",
                      //     "city": "Delhi",
                      //     "country_code": "IN",
                      //     "postal_code": "11001",
                      //     "phone": "+00000000",
                      //     "state": "Texas"
                      //  },
                    }
                  }
                ],
                note: "Contact us for any questions on your order.",
                onSuccess: (Map params) async {
                  Get.to(()=>const payment_success());
                },
                onError: (error) {
                  Navigator.pop(context);
                },
                onCancel: () {
                  Get.to(()=>page(0));
                },
              );
  }
}
