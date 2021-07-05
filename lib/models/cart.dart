import 'dart:convert';

import 'beverage.dart';
import 'demo_data.dart';
import 'pizza.dart';
import 'topping.dart';

class Cart {
  Map<Pizza, int> pizzas, pizzaManias;
  Map<Beverage, int> beverages;
  Map<Topping, int> toppings;
  double totalAmt;

  Cart({this.beverages = const {}, this.toppings = const {}, this.pizzaManias = const {}, this.pizzas = const {}}) {
    totalAmt = 0;
    beverages?.forEach((key, value) => totalAmt += key.priceINR * value);
    pizzas?.forEach((key, value) => totalAmt += key.priceINR * value);
    pizzaManias?.forEach((key, value) => totalAmt += key.priceINR * value);
    toppings?.forEach((key, value) => totalAmt += key.priceINR * value);
  }

  Cart.fromDB(String data) {
    final d = json.decode(data);
    totalAmt = 0;
    pizzas = {};
    (json.decode(d['pizzas']) as List).forEach((element) {
      final pizza = DemoData.findPizzaById(element[0]);
      pizzas.putIfAbsent(pizza, () => element[1]);
      totalAmt += pizza.priceINR * element[1];
    });
    pizzaManias = {};
    (json.decode(d['pizzaManias']) as List).forEach((element) {
      final pm = DemoData.findPizzaById(element[0]);
      pizzaManias.putIfAbsent(pm, () => element[1]);
      totalAmt += pm.priceINR * element[1];
    });
    beverages = {};
    (json.decode(d['beverages']) as List).forEach((element) {
      final bev = DemoData.findBeverageById(element[0]);
      beverages.putIfAbsent(bev, () => element[1]);
      totalAmt += bev.priceINR * element[1];
    });
    toppings = {};
    (json.decode(d['toppings']) as List).forEach((element) {
      final top = DemoData.findToppingById(element[0]);
      toppings.putIfAbsent(top, () => element[1]);
      totalAmt += top.priceINR * element[1];
    });
  }

  String get toDB => json.encode(
        {
          'pizzas': json.encode(pizzas?.entries?.map((e) => [e.key.id, e.value])?.toList() ?? []),
          'pizzaManias': json.encode(pizzaManias?.entries?.map((e) => [e.key.id, e.value])?.toList() ?? []),
          'toppings': json.encode(toppings?.entries?.map((e) => [e.key.id, e.value])?.toList() ?? []),
          'beverages': json.encode(beverages?.entries?.map((e) => [e.key.id, e.value])?.toList() ?? []),
        },
      );
}
