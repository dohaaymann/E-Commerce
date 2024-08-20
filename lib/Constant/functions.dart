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
      var response=await db.postRequest(linkgetdata, {});
      var item = response['data'].firstWhere((item) => item['idp'] == '${fav[i]}', orElse: () => null);
      res.add(item['data']);
    }
    for (var innerList in res) {
      for (var innerMap in innerList) {
        price .add(innerMap['price']);
        name .add(innerMap['name']);
        idp .add(innerMap['idp']);
        image .add(innerMap['image'].replaceAll(' ', ''));
        image_details .add(innerMap['image_details']);
      }
    }
  }
  List name_c=[],idp_c=[],price_c=[],image_c=[],image_details_c=[];
  get_carts()async{
    var res=await sql.read("Cart");
    for (var innerMap in res) {
      price_c.add(innerMap['price']);
      name_c.add(innerMap['name']);
      idp_c.add(innerMap['idp']);
      image_c.add(innerMap['image'].replaceAll(' ', ''));
      image_details_c.add(innerMap['image_details']);
    }
    return res;
  }
  get_sum(){
    return price.reduce((value, element) => value + element);
  }

}
