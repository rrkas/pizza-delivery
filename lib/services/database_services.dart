import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../models/beverage.dart';
import '../models/cart.dart';
import '../models/demo_data.dart';
import '../models/fav.dart';
import '../models/order.dart';
import '../models/pizza.dart';
import '../models/topping.dart';

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

  static Future<void> updateOrder(Order order) async {
    final db = await _orderdb;
    await db.update(_tableName, order.toDB, where: 'id = ?', whereArgs: [order.id]);
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

  static Future<void> convertToOrder() async {
    final cart = await getCart;
    await setCart(Cart());
    await OrderDatabaseHandler.insertOrder(Order.fromCart(cart));
  }
}

class FavDatabaseHandler {
  static const _spName = 'fav';
  static Fav fav;

  static Future<Fav> get getFav async {
    final sp = await SharedPreferences.getInstance();
    if (sp.containsKey(_spName)) {
      fav = Fav.fromDB(sp.getString(_spName));
    } else {
      fav = Fav();
    }
    print('getFav: ' + fav.toDB);
    return fav;
  }

  static Future<void> setFav(Fav fav1) async {
    fav = fav1;
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_spName, fav.toDB);
  }

  static Future<Fav> togglePizza(Pizza pizza) async {
    if ((DemoData.pizzas[true] + DemoData.pizzas[false]).contains(pizza)) {
      if ((fav.pizzas ?? []).contains(pizza)) {
        fav.pizzas.remove(pizza);
      } else {
        if (fav.pizzas == null) {
          fav.pizzas = List.of([pizza]);
        } else {
          fav.pizzas.add(pizza);
        }
      }
    } else {
      if ((fav.pizzaManias ?? []).contains(pizza)) {
        fav.pizzaManias.remove(pizza);
      } else {
        if (fav.pizzaManias == null) {
          fav.pizzaManias = List.of([pizza]);
        } else {
          fav.pizzaManias.add(pizza);
        }
      }
    }
    await setFav(fav);
    print('togglePizza: ' + fav.toDB);
    return fav;
  }

  static Future<Fav> toggleBeverage(Beverage bev) async {
    if (fav.beverages.contains(bev)) {
      fav.beverages.remove(bev);
    } else {
      fav.beverages.add(bev);
    }
    await setFav(fav);
    print('toggleBeverage: ' + fav.toDB);
    return fav;
  }

  static Future<Fav> toggleTopping(Topping top) async {
    if (fav.toppings.contains(top)) {
      fav.toppings.remove(top);
    } else {
      fav.toppings.add(top);
    }
    await setFav(fav);
    print('toggleTopping: ' + fav.toDB);
    return fav;
  }
}
