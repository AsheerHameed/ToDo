import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'datamodel.dart';
class DataBase {
  Future<Database> initDB() async
  {
    String path = await getDatabasesPath();
    return openDatabase(
        join(path,"MYDb.db"),
            onCreate: (database,version) async{
          await database.execute(
            """
            CREATE TABLE MyTable(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            subtitle TEXT NOT NULL  
            )
           """
          );
            },
            version: 1,
    );
  }
  Future<bool> insertData(DataModel dataModel) async{
    final Database db = await initDB();
    db.insert("MyTable",dataModel.toMap());
    return true;
  }
  Future<List<DataModel>> getData() async
  {
    final Database db = await initDB();
    final List<Map<String,Object?>>datas=await db.query("MyTable");
    return datas.map((e) => DataModel.fromMap(e)).toList();
  }
  Future<void> update (DataModel dataModel,int id) async
  {
    final Database db = await initDB();
    await db.update("MyTable", dataModel.toMap(),where: "id=?" ,whereArgs: [id]);
  }
  Future<void> delete (int id) async
  {
    final Database db = await initDB();
    await db.delete("MyTable",where: "id=?" ,whereArgs: [id]);
  }
}