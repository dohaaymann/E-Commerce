import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class SQLDB{
  static Database? _db;
  Future<Database?> get db async{
    if(_db==null){
      _db=await initialdb();
      return _db;
    }else{
      return _db;
    }
  }
  var path;
  initialdb()async{
    var database=await getDatabasesPath();
    path=join(database,"JWstore.db");
    var mydb=await openDatabase(path,onCreate: create,version:1,onUpgrade: upgrade);
    return mydb;
  }
  upgrade(Database db,int oldversion,int newversion)async{
    create(db, newversion);
  }
  create(Database db, int version) async {
    await db.execute('''
    CREATE TABLE Cart(
      id INTEGER PRIMARY KEY NOT NULL ,
      name TEXT,
      price INTEGER,
      image TEXT,
      image_details TEXT,
      category TEXT,
      quantity INTEGER
    )
  ''');
    await db.execute('''
    CREATE TABLE Favorite(
      id INTEGER PRIMARY KEY NOT NULL ,
      name TEXT,
      price INTEGER,
      image TEXT,
      image_details TEXT
    )
  ''');
  }
  insert(var table,var values)async{
    Database? mydb=await db;
    // var res= await mydb?.rawInsert(sql);
    var res= await mydb?.insert('$table',values);
    return res;
  }
  read(var table)async{
    Database? mydb=await db;
    var res= await mydb?.query("$table");
    return res;
  }
  select(var idp)async{
    Database? mydb=await db;
    var res= await mydb?.rawQuery('SELECT quantity FROM Cart WHERE id=$idp');
    return res;
  }
  selectsum()async{
    Database? mydb=await db;
    var res= await mydb?.rawQuery('SELECT COUNT(*) FROM Cart');
    return res;
  }
  existornot(var idp)async{
    Database? mydb=await db;
    var res= await mydb?.rawQuery("SELECT EXISTS(SELECT * FROM Favorite WHERE id = $idp)");
    return res;
  }
  exist(var idp)async{
    Database? mydb=await db;
    var res= await mydb?.rawQuery("SELECT EXISTS(SELECT 1 FROM Favorite WHERE id = $idp)");
    int exists = Sqflite.firstIntValue(res!) ?? 0;
    return exists;
  }
  get(var idp) async {
    Database? mydb = await db;
    var res = await mydb?.rawQuery("SELECT COUNT(*) FROM Favorite WHERE id =$idp");
    return res;
  }

  update(var value,var mywhere)async{
    Database? mydb=await db;
    var res= await mydb?.update('Favorite',value,where:"quantity" );
    // var res= await mydb?.rawUpdate(sql);
    return res;
  }
  updateall(var q,var id)async{
    Database? mydb=await db;
    var res= await mydb?.rawUpdate("UPDATE Cart SET quantity=$q where id=$id");
    // var res= await mydb?.rawUpdate(sql);
    return res;
  }
  delete(var table,var idp) async {
    Database? mydb = await db;
    var res = await mydb?.rawDelete("DELETE FROM $table WHERE id = $idp");
    return res;
  }

}
