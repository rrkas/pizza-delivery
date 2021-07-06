import 'package:flutter/material.dart';

import '../../models/pizza.dart';
import '../../widgets/pizza_list_widget.dart';

class PizzaListTab extends StatelessWidget {
  final List<Pizza> pizzas;
  final bool vegOnly;

  const PizzaListTab({Key key, this.pizzas, this.vegOnly = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      itemCount: pizzas.length,
      itemBuilder: (_, idx) {
        if (!vegOnly) return PizzaListWidget(pizza: pizzas[idx]);
        return pizzas[idx].veg ? PizzaListWidget(pizza: pizzas[idx]) : SizedBox();
      },
    );
  }
}
