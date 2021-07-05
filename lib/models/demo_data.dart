import 'dart:math';

import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:pizza_delivery/services/database_services.dart';

import 'beverage.dart';
import 'pizza.dart';
import 'topping.dart';

class DemoData {
  static Map<bool, List<Pizza>> pizzas = {};
  static Map<bool, List<Pizza>> pizzaManias = {};
  static List<Pizza> bestSellers = [];
  static List<Beverage> beverages = [];
  static List<Topping> toppings = [];

  static Future init() async {
    int totalCount = 6, vegCount = 4;
    await _loadPizza();
    await _loadPizzaMania();
    await _loadBeverages();
    await _loadToppings();
    final t = pizzas[true] + pizzas[false] + pizzaManias[true] + pizzaManias[false];
    while (bestSellers.length < vegCount) {
      final idx = Random().nextInt(t.length);
      if (bestSellers.contains(t[idx]) || !t[idx].veg) continue;
      bestSellers.add(t[idx]);
    }
    while (bestSellers.length < totalCount) {
      final idx = Random().nextInt(t.length);
      if (bestSellers.contains(t[idx]) || t[idx].veg) continue;
      bestSellers.add(t[idx]);
    }
    bestSellers.shuffle();
    FavDatabaseHandler.getFav;
  }

  static Future _loadPizza() async {
    try {
      final pizzaFileStr = await rootBundle.loadString('assets/data/pizza_data.csv');
      final pizzaData = CsvToListConverter().convert(pizzaFileStr);
      for (var d in pizzaData.sublist(1)) {
        final pizza = Pizza.fromList(d);
        print(pizza);
        pizzas.update(
          d[3].toString().trim() == 'true',
          (value) => value..add(pizza),
          ifAbsent: () => [pizza],
        );
      }
    } catch (e) {
      print(e);
    }
  }

  static Future _loadPizzaMania() async {
    try {
      final pizzaFileStr = await rootBundle.loadString('assets/data/pizza_mania_data.csv');
      final pizzaData = CsvToListConverter().convert(pizzaFileStr);
      for (var d in pizzaData.sublist(1)) {
        final pizza = Pizza.fromList(d);
        print(pizza);
        pizzaManias.update(
          d[3].toString().trim() == 'true',
          (value) => value..add(pizza),
          ifAbsent: () => [pizza],
        );
      }
    } catch (e) {
      print(e);
    }
  }

  static Future _loadBeverages() async {
    try {
      final beverageFileStr = await rootBundle.loadString('assets/data/beverage_data.csv');
      final beverageData = CsvToListConverter().convert(beverageFileStr);
      for (var d in beverageData.sublist(1)) {
        final bev = Beverage.fromList(d);
        print(bev);
        beverages.add(bev);
      }
    } catch (e) {
      print(e);
    }
  }

  static Future _loadToppings() async {
    try {
      final beverageFileStr = await rootBundle.loadString('assets/data/toppings_data.csv');
      final beverageData = CsvToListConverter().convert(beverageFileStr);
      for (var d in beverageData.sublist(1)) {
        final top = Topping.fromList(d);
        print(top);
        toppings.add(top);
      }
    } catch (e) {
      print(e);
    }
  }

  static Pizza findPizzaById(int id) {
    return (pizzas[true] + pizzas[false] + pizzaManias[true] + pizzaManias[false]).firstWhere(
      (element) => element.id == id,
      orElse: () => null,
    );
  }

  static Beverage findBeverageById(int id) {
    return beverages.firstWhere((element) => element.id == id, orElse: () => null);
  }

  static Topping findToppingById(int id) {
    return toppings.firstWhere((element) => element.id == id, orElse: () => null);
  }
}
