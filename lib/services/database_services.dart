import 'package:path/path.dart';
import 'package:pizza_delivery/models/order.dart';
import 'package:sqflite/sqflite.dart';

class OrderDatabaseHandler {
  static Database _db;
  static final _tableName = 'orders';

  static Future<Database> get _orderdb async {
    if (_db != null) return _db;
    _db = await openDatabase(
      join(await getDatabasesPath(), '$_tableName.db'),
      onCreate: (db, v) {
        return db.execute(
          'CREATE TABLE $_tableName('
          'id INTEGER PRIMARY KEY,'
          'datetime TEXT,'
          'pizzas TEXT,'
          'pizzaManias TEXT,'
          'beverages TEXT,'
          'toppings TEXT,'
          'totalAmt REAL'
          ')',
        );
      },
      version: 1,
    );
    return _db;
  }

  static Future<int> insertOrder(Order order) async {
    final db = await _orderdb;
    return await db.insert(_tableName, order.toDB, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Order>> get orders async {
    final db = await _orderdb;
    List<Map<String, dynamic>> data = await db.query(_tableName);
    data = data.reversed.toList();
    return data.map((e) => Order.fromDB(e)).toList();
  }
}
