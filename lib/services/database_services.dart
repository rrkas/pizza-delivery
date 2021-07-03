import 'package:path/path.dart';
import 'package:pizza_delivery/models/cart.dart';
import 'package:pizza_delivery/models/fav.dart';
import 'package:pizza_delivery/models/order.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
          'totalAmt REAL,'
          'orderStatus TEXT'
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

class CartDatabaseHandler {
  static const _spName = 'cart';

  static Future<Cart> get getCart async {
    final sp = await SharedPreferences.getInstance();
    if (sp.containsKey(_spName)) {
      return Cart.fromDB(sp.getString(_spName));
    }
    return Cart();
  }

  static Future<void> setCart(Cart cart) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(_spName, cart.toDB);
  }
}

class FavDatabaseHandler {
  static const _spName = 'fav';

  static Future<Fav> get getFav async {
    final sp = await SharedPreferences.getInstance();
    if (sp.containsKey(_spName)) {
      return Fav.fromDB(sp.getString(_spName));
    }
    return Fav();
  }

  static Future<void> setFav(Fav fav) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(_spName, fav.toDB);
  }
}
