import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:test0/Constant/links.dart';
import 'package:test0/Widgets/item_w.dart';

import '../Models/database.dart';
import '../page.dart';
import '../Bool.dart';
import 'item.dart';

class catagory extends StatefulWidget {
 final String cata_name;
  const catagory(this.cata_name, {super.key});

  @override
  State<catagory> createState() => _catagoryState();
}
List<bool> check_love=[];
class _catagoryState extends State<catagory> {
  @override
  database db=database();
  List loves=[];
  var value;

  check_Fav(List idp) async {
    check_love=[];
    for(var i=0;i<idp.length;i++){
      if(check_love.length==idp.length){
        break;
      }else{
        var t=await sql.exist(idp[i]);
        value=t[0]["COUNT(*)"];
        if(value.toString()=='1'){
          check_love.add(true);
        }else if(value.toString()=='0'){
          check_love.add(false);
        }else{
          break;
        }
      }
    }
  }
  get_product()async{
    var response=await db.postRequest(linkviewproduct,{
    'type':widget.cata_name
    });
    await check_Fav(await response['data'].map((item) => item['idp']).toList());
    return response;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(onPressed: (){Get.to(()=>page(0));}, icon:const Icon(Icons.arrow_back,size: 30,color: Colors.black,)),
          // backgroundColor:Color.fromRGBO(206,147,216,4),
          backgroundColor:Colors.white,
          title: Text(widget.cata_name,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 24,),),centerTitle: true,
        ),
        body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("icons/bg.jpeg"),
                fit: BoxFit.cover,
                colorFilter:
                    ColorFilter.mode(Colors.black45, BlendMode.darken),
              ),
            ),
            child: SingleChildScrollView(
              // padding: ,
              child: SizedBox(height:MediaQuery.of(context).size.height-80,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                  child: FutureBuilder(future: get_product(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if(snapshot.data['status']=='fail'){
                          return const Center(child: Text("There's no notes"),);
                        }
                        return GridView.builder(
                          shrinkWrap: true,padding: const EdgeInsets.all(0),
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 10,
                            crossAxisCount: 2,
                            // childAspectRatio:0.8
                            mainAxisExtent:260,
                          ),
                          itemCount: snapshot.data['data'].length,
                          scrollDirection: Axis.vertical,physics: const ClampingScrollPhysics(),
                          itemBuilder: (BuildContext ctx, i) {
                            return productItem(context, snapshot.data, i);
                          },
                        );
                      } if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(), // Show a loading indicator
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text("Error: ${snapshot.error}"), // Show error message
                        );
                      }
                      return const Center(child: Text("Loading.."),);
                    },
                  ),
                ),
              ),
            )));
  }
}
Widget productItem(BuildContext context, dynamic data, int index) {
  return Consumer<Bool>(builder: (context, Bool, child) {
    Bool.list_cata = check_love;
    if (index < check_love.length) { //
      return InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  item(
                    data['data'][index]['idp'],
                    data['data'][index]['name'],
                    data['data'][index]['price'],
                    data['data'][index]['image'],
                    data['data'][index]['details_image'], (){
                    Navigator.of(context).pop();
                  }
                  ),
            ),
          );
        },
        child: Column(
          children: [
            Container(
              height: 180,
              width: double.maxFinite,
              decoration: const ShapeDecoration(shape: StadiumBorder()),
              child: Image.network(
                "$linkImageRoot/${data['data'][index]['image']}",
                fit: BoxFit.fill,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left:8),
                    child: Text(
                      "${data['data'][index]['name']}",
                      style: const TextStyle(fontSize:16,fontFamily:"Rubik-Medium",fontWeight: FontWeight.bold
                      // style: TextStyle(fontSize: 20,fontFamily:"Kanit-Regular",fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "${data['data'][index]['price']} EGP",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize:18,color: Colors.green),
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      IconButton(
                        isSelected: Bool.list_cata[index],
                        icon: const FaIcon(
                          FontAwesomeIcons.heart,
                          size: 20,
                        ),
                        selectedIcon: const FaIcon(
                          FontAwesomeIcons.solidHeart,
                          color: Colors.red,
                          size: 20,
                        ),
                        onPressed: () async {
                          if (check_love[index]) {
                            await sql.delete(
                                'Favorite', data['data'][index]['idp']);
                            Bool.list_ch_cata(index, false);
                          } else {
                            await sql.insert('Favorite', {
                              "id": data['data'][index]['idp'],
                              'name': data['data'][index]['name'],
                              'price': data['data'][index]['price'],
                              'image': data['data'][index]['image'],
                              'image_details': data['data'][index]['details_image']
                            });
                            Bool.list_ch_cata(index, true);
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }
    else {
      return const SizedBox();
    }
  });
}