import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
// import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:test0/Constant/links.dart';
import 'package:test0/Models/database.dart';
import '../Models/productmodel.dart';

class productcontroller{
   static get_data()async{
    var url="https://81cc-41-40-153-55.ngrok-free.app/data";
    // var url=linkview;  //http://192.168.1.15/JW store/view.php;
    var db=database();
    // var response = await db.postRequest(linkviewtrend, {});
    List<Data> results=[];
    try{
      Dio dio=Dio();
      DioCacheManager dioCacheManager=DioCacheManager(CacheConfig());
      Options myoptions=buildCacheOptions(Duration(days: 365),forceRefresh: true);
      dio.interceptors.add(dioCacheManager.interceptor);
      var res=await dio.get(url,options: myoptions);
      // print("Ressssssssssss::::$res");
      // print("res:::::::::::::::$response");
      results = getList(res.data);
      // print("results::::$results");

      // print(results);
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) {
        print('Error 404: Resource not found');
        // Handle 404 error specifically
      } else {
        print('DioError: ${e.message}');
      }
    } catch (e) {
      print('Unexpected Error: $e');
    }
    return results;
 }

  static getList(body) {
    List<Data> items = [];
    var data = body['data'];
    data.forEach((e) {
      items.add(Data.fromJson(e));
    });
    return items;
  }
}