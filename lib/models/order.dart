import 'dart:convert';

import 'beverage.dart';
import 'cart.dart';
import 'demo_data.dart';
import 'pizza.dart';
import 'topping.dart';

enum OrderStatus { Waiting, Processing, Delivered }

class Order {
  int id;
  DateTime datetime = DateTime.now();
  Map<Pizza, int> pizzas, pizzaManias;
  Map<Beverage, int> beverages;
  Map<Topping, int> toppings;
  double totalAmt;
  OrderStatus orderStatus;

  Order.fromCart(Cart cart) {
    pizzas = cart?.pizzas ?? {};
    pizzaManias = cart?.pizzaManias ?? {};
    toppings = cart?.toppings ?? {};
    beverages = cart?.beverages ?? {};
    totalAmt = cart.totalAmt;
    orderStatus = OrderStatus.Waiting;
  }

  Order({this.toppings, this.beverages, this.pizzas, this.pizzaManias}) {
    datetime = DateTime.now();
    totalAmt = 0;
    pizzas?.forEach((key, value) => totalAmt += key.priceINR * value);
    pizzaManias?.forEach((key, value) => totalAmt += key.priceINR * value);
    beverages?.forEach((key, value) => totalAmt += key.priceINR * value);
    toppings?.forEach((key, value) => totalAmt += key.priceINR * value);
    orderStatus = OrderStatus.Waiting;
  }

  Order.fromDB(Map<String, dynamic> map) {
    id = map['id'];
    datetime = DateTime.tryParse(map['datetime'] ?? '');
    pizzas = (json.decode(map['pizzas']) as List).fold(
      {},
      (previousValue, element) => previousValue
        ..update(
          DemoData.findPizzaById(element),
          (value) => previousValue[DemoData.findPizzaById(element)] + 1,
          ifAbsent: () => 1,
        ),
    );
    pizzaManias = (json.decode(map['pizzaManias']) as List).fold(
      {},
      (previousValue, element) => previousValue
        ..update(
          DemoData.findPizzaById(element),
          (value) => previousValue[DemoData.findPizzaById(element)] + 1,
          ifAbsent: () => 1,
        ),
    );
    beverages = (json.decode(map['beverages']) as List).fold(
      {},
      (previousValue, element) => previousValue
        ..update(
          DemoData.findBeverageById(element),
          (value) => previousValue[DemoData.findBeverageById(element)] + 1,
          ifAbsent: () => 1,
        ),
    );
    toppings = (json.decode(map['toppings']) as List).fold(
      {},
      (previousValue, element) => previousValue
        ..update(
          DemoData.findToppingById(element),
          (value) => previousValue[DemoData.findToppingById(element)] + 1,
          ifAbsent: () => 1,
        ),
    );
    totalAmt = map['totalAmt'];
    orderStatus = OrderStatus.values.firstWhere(
      (element) => element.toString() == map['orderStatus'],
      orElse: () => OrderStatus.Waiting,
    );
  }

  Map<String, dynamic> get toDB {
    final p = [];
    pizzas?.forEach((key, value) {
      for (int i = 0; i < value; i++) p.add(key.id);
    });
    final pm = [];
    pizzaManias?.forEach((key, value) {
      for (int i = 0; i < value; i++) pm.add(key.id);
    });
    final b = [];
    beverages?.forEach((key, value) {
      for (int i = 0; i < value; i++) b.add(key.id);
    });
    final t = [];
    toppings?.forEach((key, value) {
      for (int i = 0; i < value; i++) t.add(key.id);
    });
    return {
      'pizzas': json.encode(p),
      'pizzaManias': json.encode(pm),
      'beverages': json.encode(b),
      'toppings': json.encode(t),
      'totalAmt': totalAmt,
      'datetime': datetime.toIso8601String(),
      'orderStatus': orderStatus.toString(),
    };
  }

  @override
  String toString() {
    return 'Order($id): $datetime | $pizzas | $beverages | $toppings | $totalAmt';
  }
}
