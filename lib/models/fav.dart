import 'dart:convert';

import 'beverage.dart';
import 'demo_data.dart';
import 'pizza.dart';
import 'topping.dart';

class Fav {
  List<Pizza> pizzas, pizzaManias;
  List<Beverage> beverages;
  List<Topping> toppings;

  Fav({this.beverages = const [], this.toppings = const [], this.pizzaManias = const [], this.pizzas = const []});

  Fav.fromDB(String data) {
    final d = json.decode(data);
    pizzas = (json.decode(d['pizzas']) as List).map((e) => DemoData.findPizzaById(e)).toList();
    pizzaManias = (json.decode(d['pizzaManias']) as List).map((e) => DemoData.findPizzaById(e)).toList();
    beverages = (json.decode(d['beverages']) as List).map((e) => DemoData.findBeverageById(e)).toList();
    toppings = (json.decode(d['toppings']) as List).map((e) => DemoData.findToppingById(e)).toList();
  }

  String get toDB => json.encode(
        {
          'pizzas': json.encode((pizzas?.map((e) => e.id)?.toList() ?? [])..sort()),
          'pizzaManias': json.encode((pizzaManias?.map((e) => e.id)?.toList() ?? [])..sort()),
          'toppings': json.encode((toppings?.map((e) => e.id)?.toList() ?? [])..sort()),
          'beverages': json.encode((beverages?.map((e) => e.id)?.toList() ?? [])..sort()),
        },
      );
}
