import '../Constant/productcontroller.dart';
import '../main.dart';

class upload_data{
  upload_data(){
    print("uuuuuuuuuuuppppppppppppl");
    upload_trend();
    upload_Bracelets();
    upload_Necklaces();
    upload_Earrings();
    upload_Pendants();
    upload_Rings();
  }
  upload_trend()async{
    var response = await productcontroller.get_data();
    var trendingProducts = response.where((product) => product.trend == '1').toList();
    List serializedResponse = trendingProducts.map((data) => data.toJson()).toList();
    await mybox?.put('trend', serializedResponse);
  }
  upload_Rings()async{
   var response = await productcontroller.get_data();
   var Products = response.where((product) => product.catagory =='Rings').toList();
   List serializedResponse = Products.map((data) => data.toJson()).toList();
    await mybox?.put('Rings', serializedResponse);
  }
  upload_Bracelets()async{
    var response = await productcontroller.get_data();
    var Products = response.where((product) => product.catagory =='Bracelets').toList();
    List serializedResponse = Products.map((data) => data.toJson()).toList();
    await mybox?.put('Bracelets', serializedResponse);
  }
  upload_Necklaces()async{
    var response = await productcontroller.get_data();
    var Products = response.where((product) => product.catagory =='Necklaces').toList();
    List serializedResponse = Products.map((data) => data.toJson()).toList();
    await mybox?.put('Necklaces', serializedResponse);
  }
  upload_Earrings()async{
    var response = await productcontroller.get_data();
    var Products = response.where((product) => product.catagory =='Earrings').toList();
    List serializedResponse = Products.map((data) => data.toJson()).toList();
    await mybox?.put('Earrings', serializedResponse);
  }
  upload_Pendants()async{
    var response = await productcontroller.get_data();
    var Products = response.where((product) => product.catagory =='Pendants').toList();
    List serializedResponse = Products.map((data) => data.toJson()).toList();
    await mybox?.put('Pendants', serializedResponse);
  }

}