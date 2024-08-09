import 'package:countnumberbutton/countnumberbutton.dart';
import 'package:flutter/material.dart';
import 'package:item_count_number_button/item_count_number_button.dart';


class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
          body: Column(
            children: [
              CountNumberButton(
                    textsize:15,
                    width:110,
                    height:35,
                    initValue:1,
                    minValue: 0,
                    maxValue:20,
                    iconColor: Colors.white,
                    iconSize:10.0,
                    buttonColor:const Color.fromRGBO(103, 0, 92, 4),
                    textColor: Colors.black,
                    icon_left: const Icon(Icons.remove,size: 12,),
                    icon_right: const Icon(Icons.add,size:12,),
                    onChanged: (value) {
                      // q= value;
                    },
                  ),
              ItemCount(
                buttonSizeHeight:30,
                color: Color.fromRGBO(103, 0, 92, 4),
                minValue: 0,
                maxValue:20,
                initialValue: 0,
                decimalPlaces: 0,
                onChanged: (value) {
                  // Handle counter value changes
                  print('Selected value: $value');
                },
              ),
            ],
          ),
    );
  }
}

class ShippingPage extends StatefulWidget {
  const ShippingPage({super.key});

  @override
  _ShippingPageState createState() => _ShippingPageState();
}

class _ShippingPageState extends State<ShippingPage> {
  String selectedAddress = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ADDRESS',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                selectedAddress = 'My Home';
              });
            },
            child: Card(
              color: selectedAddress == 'My Home' ? Colors.lightGreen[100] : null,
              child: ListTile(
                title: const Text('My Home'),
                subtitle: const Text('997 Bekasi West Java, Indonesia, 94012'),
                trailing: TextButton(
                  onPressed: () {
                    // Handle edit address
                  },
                  child: const Text('Edit'),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                selectedAddress = 'Office';
              });
            },
            child: Card(
              color: selectedAddress == 'Office' ? Colors.lightGreen[100] : null,
              child: ListTile(
                title: const Text('Office'),
                subtitle: const Text('987 Jakarta, Indonesia, 92102'),
                trailing: TextButton(
                  onPressed: () {
                    // Handle edit address
                  },
                  child: const Text('Edit'),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () {
              // Handle add new address
            },
            icon: const Icon(Icons.add),
            label: const Text('Add New'),
          ),
          const SizedBox(height: 16),
          const Text(
            'DELIVERY ESTIMATE',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                selectedAddress = 'Instant Delivery';
              });
            },
            child: Card(
              color: selectedAddress == 'Instant Delivery' ? Colors.lightGreen[100] : null,
              child: const ListTile(
                title: Text('Instant Delivery'),
                subtitle: Text('30-40 Min'),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                selectedAddress = 'Standard Delivery';
              });
            },
            child: Card(
              color: selectedAddress == 'Standard Delivery' ? Colors.lightGreen[100] : null,
              child: const ListTile(
                title: Text('Standard Delivery'),
                subtitle: Text('Same Day'),
              ),
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              // Handle next action
              // You may want to navigate to the next tab
              TabController? controller = DefaultTabController.of(context);
              controller.animateTo(1);
                        },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightGreen, // Background color
            ),
            child: const Center(
              child: Text(
                'Next',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Payment Page'));
  }
}

class ReviewPage extends StatelessWidget {
  const ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Review Page'));
  }
}
