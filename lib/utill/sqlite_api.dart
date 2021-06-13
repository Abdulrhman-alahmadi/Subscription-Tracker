import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:p2021/class/subscription.dart';
import 'package:p2021/utill/const.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

class SqliteApi {

  Future <Database> _database;

  Future<Database> get database  async{
    if (_database != null) return _database;
    _database = initializeDb();
    return _database;

  }

  Future<Database> initializeDb() async {
    // Open the database and store the reference.
    final database = openDatabase(
      join(await getDatabasesPath(), 'subs_database.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE subscription(name TEXT, price INTEGER, desc TEXT, date TEXT, img TEXT, color TEXT)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
    // create the table if not exists.
    return database;
  }

  Future<void> insertSub(Subscription sub) async {
    final Database db = await database;
    print(db);
    var row = await db.insert(
      'subscription',
      sub.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(row);
  }

  Future<List<Subscription>> retrieveSubs() async {
    // Get a reference to the database.
    final Database db = await database;
    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('subscription');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {

      // holder for now
      Color currentSubColor = Colors.blue;
      for(var sub in Constants.subs){
       if( sub.name.toLowerCase() == maps[i]['name'].toString().toLowerCase() ){
         currentSubColor = sub.color;
         break;
       }
       print(currentSubColor);
      }
print(maps[i]['date']);
      return Subscription(
          maps[i]['name'],
          double.parse(maps[i]['price'].toString()),
          maps[i]['desc'],
          DateTime.parse(maps[i]['date']),
          DateTime.now(),
          maps[i]['img'],
          currentSubColor);
    });
  }

  void deleteSub(Subscription sub) async{
    final db = await database;
    db.delete("subscription",where: 'name = ? and price = ? and desc = ? and date = ?', whereArgs:[sub.name,sub.price,sub.desc,DateFormat('yyyy-MM-dd').format(sub.startDate)]);
  }
}
