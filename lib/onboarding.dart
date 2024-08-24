

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test0/Constant/colors.dart';
import 'package:test0/page.dart';
// import 'home.dart';

class Onboarding_1 extends StatefulWidget {
  const Onboarding_1({Key? key}) : super(key: key);

  @override
  State<Onboarding_1> createState() => _Onboarding_1State();
}

class _Onboarding_1State extends State<Onboarding_1> {
  var _controller = PageController();

  @override
  void initState() {
    _controller = PageController(initialPage: 0 );
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  // List sub_title=[,,];
  List<Map<String, String>> content = [
    {
      'image':'icons/acc3.png',
      'title': 'Explore Fashion',
      'content': "Explore the 2024's hottest fashion, jewellery, accessories and more,.."
    },
    {
      'image':'icons/acc1.png',
      'title': 'Select what you love',
      'content': "Exclusively curated selection of top brands in the palm of your hand."
    },
    {
      'image':'icons/woman-jewelry.png',
      'title': 'Be The real you',
      'content': "It brings you the latest trends and products from all over the world.."
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top:30,right: 15),
            child: Align(alignment: Alignment.topRight,
              child:InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => page(0),));
                },child: Text("Skip",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),),
            ),
          ),
          Expanded(
            child: PageView.builder(
              onPageChanged: (int index){
                setState(() {
                  numberIndex = index;
                });
              },
              controller: _controller,
              itemCount: content.length,
              itemBuilder: (_,i){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Spacer(),
                      Image.asset(
                          content[i]['image']!
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(content[i]['title']! ,textAlign: TextAlign.center,
                                style: GoogleFonts.playfairDisplay(
                                  fontStyle: FontStyle.italic,
                                    fontSize:30,fontWeight: FontWeight.bold,
                                )
                              ),
                            ),Align(
                              child:Text(
                                content[i]['content']!
                                ,textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize:18,
                                  color: Colors.black54,
                                  // fontWeight: FontWeight.bold,
                                ),

                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20 , right: 20, left: 20),
            width: double.infinity,
            height:50,
            child: FloatingActionButton(
              child:  Text( numberIndex == content.length - 1 ? "Continue" : "Next" ,
                style: TextStyle(
                  fontSize:18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),),
              onPressed: (){
                if (numberIndex == content.length - 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>page(0),
                    ),
                  );
                }
                _controller.nextPage(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                );
              },
              backgroundColor: purplefav,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35),
              ),
            ),

          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(content.length, (index) => box( index )
              ),
            ),
          ),


        ],
      ),
    );
  }

  Container box(int index ) {
    return Container(
      height: 10,
      width: numberIndex == index ? 30: 10,
      margin: EdgeInsets.only(bottom: 40 , right: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color:purplefav
      ),
    );
  }
  void textsonboarding(){
    if(numberIndex==0){

    }
  }
}
int numberIndex=0;
