import 'package:test0/Models/sql.dart';
import '../Models/database.dart';
import 'links.dart';
class functions{
  database db=database();
  SQLDB sql=SQLDB();
  List Fav=[];List fav=[];
  get_Fav()async{
    var res=await sql.read("Favorite");
    Fav.addAll(res);
    // if(this.mounted){
    //   setState(() { });
    // }
    var jsonData = '$Fav';
    var dataWithoutBrackets = jsonData.substring(1, jsonData.length - 1);
    var keyValuePairs = dataWithoutBrackets.split(',');
    for (var pair in keyValuePairs) {
      var parts = pair.split(':');
      var value = parts[1].trim();
      value = value.replaceAll(RegExp(r'[{} ]'), '');
      fav.add(value);
    }
    await get_all();
  }
  List name=[],idp=[],price=[],image=[],image_details=[];
  get_all()async{
    List res=[];
    for(int i=0;i<fav.length;i++){
      var response=await db.postRequest(linkviewitem,{
        'idp':fav[i]
      });
      print(response['data']);
      res.add(response['data']);
    }
    print("--------------------");
    print(res);
    for (var innerList in res) {
      for (var innerMap in innerList) {
        price .add(innerMap['price']);
        name .add(innerMap['name']);
        idp .add(innerMap['idp']);
        image .add(innerMap['image'].replaceAll(' ', ''));
        image_details .add(innerMap['image_details']);
        // print('Price: $prices');
      }
    }
    print("--------------------");
    print(image);
    print(idp);
    print(name);
    print(price);
    print(fav);
    print("--------------------");
  }
  List name_c=[],idp_c=[],price_c=[],image_c=[],image_details_c=[];
  get_carts()async{
    var res=await sql.read("Cart");
    print(res);
    for (var innerMap in res) {
      price_c.add(innerMap['price']);
      name_c.add(innerMap['name']);
      idp_c.add(innerMap['idp']);
      image_c.add(innerMap['image'].replaceAll(' ', ''));
      image_details_c.add(innerMap['image_details']);
      // print('Price: $prices');
    }
    print(name);
    return res;
  }
  get_sum(){
    return price.reduce((value, element) => value + element);
  }

}