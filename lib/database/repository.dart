import 'package:budget_app/database/database_connection.dart';
import 'package:sqflite/sqflite.dart';

class Repository {
  DatabaseConnection _databaseConnection;

  Repository() {
    //INITIALIZE DATABASE CONNECTION
    _databaseConnection = DatabaseConnection();
  }

  static Database _database;

  //CHECK IF DATABASE EXISTS OR NOT
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _databaseConnection.setDatabase();
    return _database;
  }

//INSERT DATA TO TABLE
  insertData(table, data) async {
    var connection = await database;
    return await connection.insert(table, data);
  }

  //READ DATA FROM TABLE
  readData(table) async {
    var connection = await database;
    return await connection.query(table);
  }

// READ DATA BY ID
  readDataById(table, categoryId) async {
    var connection = await database;
    return await connection
        .query(table, where: 'category_id=?', whereArgs: [categoryId]);
  }

//UPDATE CATEGORY
  updateData(table, data) async {
    var connection = await database;
    return await connection.update(table, data,
        where: "category_id=?", whereArgs: [data['category_id']]);
  }

//DEELTE DATA
  deleteData(table, categoryId) async {
    var connection = await database;
    return await connection
        .rawDelete("DELETE FROM $table WHERE category_id = $categoryId");
  }

  //INSERT DATA TO TABLE
  insertItem(table, data) async {
    var connection = await database;
    return await connection.insert(table, data);
  }

  //READ DATA FROM TABLE
  readItem(table, categoryId) async {
    var connection = await database;
    return await connection
        .query(table, where: 'category_id=?', whereArgs: [categoryId]);
  }

  //READ ALL DATA FROM TABLE
  readAllItem(table) async {
    var connection = await database;
    return await connection.query(table);
  }

// READ DATA BY ID
  readItemById(table, itemId) async {
    var connection = await database;
    return await connection
        .query(table, where: 'item_id=?', whereArgs: [itemId]);
  }

//UPDATE item
  updateItem(table, data) async {
    var connection = await database;
    return await connection
        .update(table, data, where: "item_id=?", whereArgs: [data['item_id']]);
  }

//DEELTE DATA
  deleteItem(table, itemId) async {
    var connection = await database;
    return await connection
        .rawDelete("DELETE FROM $table WHERE item_id = $itemId");
  }
}
