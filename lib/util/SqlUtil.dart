
import 'package:path/path.dart';
import 'package:rxbloc_sql_sp/bean/TestData.dart';
import 'package:synchronized/synchronized.dart';
import 'package:sqflite/sqflite.dart';
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  final String tableName = "table_data";
  final String columnId = "id";
  final String columnData = "data";
  final String columnTime = "time";
  static Database _dataBase;

  Future<Database> get db async {
    if (_dataBase != null) {
      return _dataBase;
    }
    _dataBase = await initDb();
    return _dataBase;
  }

  DatabaseHelper.internal();

  initDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'sqflite.db');
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  //创建数据库表
  void _onCreate(Database db, int version) async {
    await db.execute(
        "create table $tableName($columnId integer primary key,$columnData text not null ,$columnTime integer not null )");
    print("Table is created");
  }
  void createString(List li){

  }
//插入
  Future<int> saveItem(TestData user) async {
    var dbClient = await db;
    int res = await dbClient.insert("$tableName", user.toMap());
    print(res.toString());
    return res;
  }

  //查询
  Future<List> getTotalList() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName ");
    return result.toList();
  }

  //查询总数
  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery(
        "SELECT COUNT(*) FROM $tableName"
    ));
  }

//按照id查询
  Future<TestData> getItem(int id) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableName WHERE id = $id");
    if (result.length == 0) return null;
    return TestData.fromMap(result.first);
  }


  //清空数据
  Future<int> clear() async {
    var dbClient = await db;
    return await dbClient.delete(tableName);
  }


  //根据id删除
  Future<int> deleteItem(int id) async {
    var dbClient = await db;
    return await dbClient.delete(tableName,
        where: "$columnId = ?", whereArgs: [id]);
  }

  //修改
  Future<int> updateItem(TestData user) async {
    var dbClient = await db;
    return await dbClient.update("$tableName", user.toMap(),
        where: "$columnId = ?", whereArgs: [user.id]);
  }

  //关闭
  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
