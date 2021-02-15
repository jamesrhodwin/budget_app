import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection {
  setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'budget_app_database_final');
    var database =
        await openDatabase(path, version: 1, onCreate: _onCreatingDatabase);
    return database;
  }

  _onCreatingDatabase(Database database, int version) async {
    await database.execute(
        "CREATE TABLE `category` ( `category_id` INTEGER PRIMARY KEY AUTOINCREMENT, `category_name` varchar(255), `category_max_budget` INTEGER, `category_rem_budget` INTEGER, `category_date` DATETIME );");
    await database.execute(
        "CREATE TABLE `item` ( `item_id` INTEGER PRIMARY KEY AUTOINCREMENT, `item_name` varchar(255), `item_amount` INTEGER, `item_date` DATETIME, `category_id` INTEGER, FOREIGN KEY (category_id) REFERENCES category (category_id) );");
  }
}
