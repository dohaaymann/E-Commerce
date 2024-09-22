import 'package:cached_network_image/cached_network_image.dart';
import 'package:countnumberbutton/countnumberbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
import '../Bool.dart';
import '../Models/database.dart';
import '../Constant/links.dart';
import '../Models/sql.dart';
import '../main.dart';
class item extends StatefulWidget{
  @override
  final idp,name,price,image,details_image;
  const item(this.idp,this.name,this.price,this.image,this.details_image, {super.key});
  @override
  State<item> createState() => _itemState();
}

database db=database();
var quantity=1;
class _itemState extends State<item> {
  var value, amount, response;
   var check_love=false;

  // Future<bool> existInHive(var idp) async {
  //   bool exists = Hive.box('Favorite').containsKey("$idp");
  //   return exists;
  // }
  // check_Fav() async {
  //   bool exists = await existInHive(widget.idp);
  //   setState(() {
  //     check_love = exists;
  //   });
  //   return check_love;
  // }
  // check_Fav()async{
  //   var t=await sql.get(widget.idp);
  //   value=t[0]["COUNT(*)"];
  //   setState(() {
  //     if(value.toString()=='1'){
  //       check_love=true;
  //     }else{
  //       check_love=false;
  //     }
  //   });
  //   return check_love;
  // }

  // void add_to_Fav()async{
  //   if(check_love){
  //     await favbox?.delete('${widget.idp}');
  // }else{
  //     await favbox?.put("${widget.idp}", {
  //       'idp':widget.idp,
  //       'name': widget.name,
  //       'price': widget.price,
  //       'image': widget.image,
  //       'image_details': widget.details_image
  //     });
  //   setState(() {
  //    check_Fav();
  //   });
  // }}

  check_Fav()async{
    var t=await sql.get(widget.idp);
    value=t[0]["COUNT(*)"];
    setState(() {
      if(value.toString()=='1'){
        check_love=true;
      }else{
        check_love=false;
      }
    });
    return check_love;
  }
  void add_to_Fav()async{
    if(check_love){
      await sql.delete('Favorite',widget.idp);
    }else{
      await sql.insert('Favorite',{"id":widget.idp,
        'name':widget.name,
        'price':widget.price,
        'image':widget.image,
        'image_details':widget.details_image
      });}
    setState(() {
      check_Fav();
    });
  }
  get_amount() async {
    var res = await sql.select(widget.idp);
    if (mounted) {
      setState(() {
        if (res.isNotEmpty && res[0] != null ) {
          amount = res[0]['quantity'] ?? 0; // Default to 0 if 'quantity' is null
        } else {
          amount = 0; // Default to 0 if no results are found
        }
      });
    }
    // amount=res[0]['quantity']??0;
  }

  get_item()async{
 // response=await db.postRequest(linkviewitem,{
 //    'idp':widget.idp });
response=await db.postRequest(linkgetdata, {});
 if (response != null && response['status'] == 'successful') {
   // Filter the items to find the one with idp = 2
   var item = response['data'].firstWhere((item) => item['idp'] == '${widget.idp}', orElse: () => null);
   return item;
 }
  return null;
}
// late Future _tasks;
SQLDB sql=SQLDB();
@override
  void initState(){
  get_amount();
  quantity=1;
  check_Fav();
  super.initState();
}
  @override
  Widget build(BuildContext context) {
    return Consumer<provide>(
        builder: (context, Bool, child) {
      return Scaffold(
        appBar: AppBar(
          actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
            isSelected:check_love,
    icon: const FaIcon(FontAwesomeIcons.heart,size:25,),
    selectedIcon: const FaIcon(FontAwesomeIcons.solidHeart,color: Colors.red,size:25,),
    onPressed:()async{
              setState(() {
                add_to_Fav();
              });
            }
            ),
          ),],
        ),
        body:
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 400,
                          child: ImageSlideshow(
                            width: double.infinity,height:200,
                            initialPage: 0,
                            indicatorColor: Colors.black,
                            indicatorBackgroundColor: Colors.grey,
                            onPageChanged: (value) {
                            },
                            autoPlayInterval: 3000,
                            isLoop: true,
                            children: [
                             CachedNetworkImage(
                             imageUrl: "${widget.image.toString()}",
                              fit: BoxFit.cover,
                             placeholder: (context, url) => SkeletonAvatar(
                              style: SkeletonAvatarStyle(
                                width: double.infinity,
                                height: 180,
                                shape: BoxShape.rectangle,
                              ),
                            ))
                            ],
                          ),
                        ),Padding(
                          padding: const EdgeInsets.only(left: 8,top: 5,bottom:4),
                          child: Text("${widget.name}",style: const TextStyle(fontSize:24,fontWeight: FontWeight.bold),),
                        ),Row(mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(color: Colors.white,width: 100,margin: const EdgeInsets.only(left: 8),
                                child:CountNumberButton(
                                  width: 85,
                                  height: 40,
                                  initValue: quantity,
                                  minValue: 1,
                                  maxValue:16,
                                  iconColor: Colors.white,
                                  iconSize: 20.0,
                                  buttonColor:const Color.fromRGBO(103, 0, 92, 4),
                                  textColor: Colors.black,
                                  icon_left: const Icon(Icons.remove,size: 16,),
                                  icon_right: const Icon(Icons.add,size: 16,),
                                  onChanged: (value) async{
                                    quantity = value;
                                  }, textsize: 20,
                                )
                            ),const Expanded(child: SizedBox()),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text("${widget.price} EGP",style: const TextStyle(fontSize: 25,color: Colors.green),),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("ADDITIONAL INFORMATION"),
                        ), CachedNetworkImage(
                          imageUrl: "${widget.details_image.toString()}",fit: BoxFit.fill,
                          placeholder: (context, url) =>  SkeletonAvatar(
                            style: SkeletonAvatarStyle(
                              width: double.infinity,
                              height: 180,
                              shape: BoxShape.rectangle,
                              // borderRadius: BorderRadius.circular(50), // Adjust as needed
                            ),
                          ),
                          errorWidget: (context, url, error) =>Text("${widget.details_image}"),
                        )
                      ],
                    ),
                  ),
                ),Container(height: 60,width:double.infinity,color:Colors.white,child:
                Row(
                  children: [
                    const Spacer(),
                    const FaIcon(FontAwesomeIcons.cartPlus,size:30,color: Color.fromRGBO(103, 0, 92, 4),),
                    const Spacer(),
                    ElevatedButton(style:ElevatedButton.styleFrom(
                        fixedSize: const Size(260,45),
                        backgroundColor:const Color.fromRGBO(103, 0, 92, 4)

                    ),onPressed: ()async{
                      try{

                        var res=await sql.insert('Cart',{
                          "id":widget.idp,
                          'name':widget.name.toString(),
                          'price':widget.price.toString(),
                          'image':widget.image.toString(),
                          'image_details':widget.details_image.toString(),
                          'quantity':quantity,
                          'category':''
                        });
                        Bool.get_count();
                        if (res!=null){
                          Get.snackbar(
                            '', "Item added to cart", // Message
                            backgroundColor: Colors.green,
                            duration: const Duration(seconds: 2),
                            messageText: const Text(
                              "Item added to cart",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            maxWidth: 300,
                          );
                        }
                      }catch(e){
                        await get_amount();
                        var res=await sql.updateall(quantity+amount,widget.idp);
                        if (res!=null){
                          Get.snackbar(
                            '', "Item added to cart", // Message
                            backgroundColor: Colors.green,
                            duration: const Duration(seconds: 2),
                            messageText: const Text(
                              "Item added to cart",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            maxWidth: 300,
                          );                          }
                      }
                      },child:const Text("ADD TO CART",style: TextStyle(fontSize: 20,color: Colors.white),)),
                  ],
                ),)
              ],
            )
      );
        });
  }
}
