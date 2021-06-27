import 'beverage.dart';
import 'pizza.dart';
import 'topping.dart';

class Cart {
  Map<Pizza, int> pizzas, pizzaManias;
  Map<Beverage, int> beverages;
  Map<Topping, int> toppings;
  double totalAmt;

  Cart({this.beverages, this.toppings, this.pizzaManias, this.pizzas});
}
