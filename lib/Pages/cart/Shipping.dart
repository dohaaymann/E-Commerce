import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test0/Constant/colors.dart';
import 'package:test0/Pages/User Pages/Address/add_address.dart';
import 'package:test0/Pages/User Pages/Address/address.dart';

import '../../Models/Paypal.dart';
import '../../Models/database.dart';
import '../../main.dart';
import 'cart.dart';
import 'order_completed.dart';
class Shipping extends StatefulWidget {
  var total, items;
  Shipping(this.total, this.items, {super.key});

  @override
  State<Shipping> createState() => _ShippingState();
}

class _ShippingState extends State<Shipping> {
  var _tasks, id;
  var db = database();

  get_address() async {
     return await mybox?.get("Address");
  }

  @override
  void initState() {
    super.initState();
    _tasks = get_address();
  }

  String selectedPaymentMethod = '';
  String selectedAddress = '';
  String selectedDelivery = '';

  @override
  Widget build(BuildContext context) {
    final appBarHeight = AppBar().preferredSize.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Get.to(() => const cart());
          },
          icon: const Icon(Icons.arrow_back, size: 30, color: Colors.black),
        ),
        title: const Text("Checkout"),
      ),
      body: WillPopScope(
        onWillPop: () async {
          // Handle back navigation if necessary
          Get.to(() => const cart()); // Or use Get.back() depending on your requirement
          return false; // Return false to prevent default back navigation
        },
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "ADDRESS",
                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 19),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            Get.to(() => add_address(onPressed: () {
                              Navigator.of(context).pop();
                            }));
                          },
                          child: const Text(
                            "+ AddNew",
                            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 19),
                          ),
                        )
                      ],
                    ),
                    FutureBuilder(
                      future: _tasks,
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text("Error: ${snapshot.error}"));
                        } else if (!snapshot.hasData) {
                          return const SizedBox(
                            height: 50,
                            child: Center(
                              child: Text(
                                "Add your address to continue payment",
                                style: TextStyle(color: Colors.black54, fontSize: 18),
                              ),
                            ),
                          );
                        } else if (snapshot.hasData) {
                          print(snapshot.data);
                          var data = snapshot.data;
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
                                    title: Text(
                                      "${data[i]['Name_add']}",
                                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                                    ),
                                    subtitle: Text(
                                      "${data[i]['State']},${data[i]['City']} ,${data[i]['Street']}",
                                      style: const TextStyle(fontSize: 16, color: Colors.black54),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        return Text("data");
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text("Payment Method", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 19)),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedPaymentMethod = "Paypal";
                              });
                            },
                            child: Card(
                              color: selectedPaymentMethod == "Paypal"
                                  ? purplefav.withOpacity(0.4)
                                  : null,
                              child: Container(
                                height: 50,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(7),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset("images/paypal.png", height: 30),
                                    const Text(" Paypal", style: TextStyle(fontSize: 18)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedPaymentMethod = "Cash";
                              });
                            },
                            child: Card(
                              color: selectedPaymentMethod == "Cash"
                                  ? purplefav.withOpacity(0.4)
                                  : null,
                              child: Container(
                                height: 50,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(7),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(FontAwesomeIcons.moneyBill, color: Colors.red),
                                    Text("   Cash", style: TextStyle(fontSize: 18)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text("DELIVERY ESTIMATE", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 19)),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDelivery = "Instant Delivery";
                        });
                      },
                      child: Card(
                        color: selectedDelivery == 'Instant Delivery'
                            ? purplefav.withOpacity(0.4)
                            : null,
                        child: const ListTile(
                          leading: Icon(FontAwesomeIcons.vanShuttle),
                          title: Text(
                            "Instant Delivery",
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            "1-2 Day",
                            style: TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDelivery = "Standard Delivery";
                        });
                      },
                      child: Card(
                        color: selectedDelivery == 'Standard Delivery'
                            ? purplefav.withOpacity(0.4)
                            : null,
                        child: const ListTile(
                          leading: Icon(FontAwesomeIcons.vanShuttle),
                          title: Text(
                            "Standard Delivery",
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            "Same Day",
                            style: TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10,0,10,20),
              child: SizedBox(
                width: double.infinity,
                height:50,
                child: FloatingActionButton(
                  backgroundColor:selectedDelivery != '' &&
                      selectedPaymentMethod != '' &&
                      selectedAddress != ''?purplefav:Colors.grey ,
                  onPressed: selectedDelivery != '' &&
                      selectedPaymentMethod != '' &&
                      selectedAddress != ''
                      ? () {
                    if (selectedPaymentMethod == 'Paypal') {
                      Get.to(() => paypal("${widget.total}", widget.items));
                    } else {
                      Get.to(() => const order_completed());
                    }
                  }: null,
                  child: const Text(
                    "Confirm and Continue",
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
