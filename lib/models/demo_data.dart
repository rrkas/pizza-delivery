import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'beverage.dart';
import 'topping.dart';

import 'pizza.dart';

class DemoData {
  static Map<bool, List<Pizza>> pizzas = {};
  static List<Beverage> beverages = [];
  static List<Topping> toppings = [];

  static Future init() async {
    await _loadPizza();
    await _loadBeverages();
    await _loadToppings();
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
}
