import 'package:flutter/material.dart';

import '../../models/topping.dart';
import '../../widgets/topping_list_widget.dart';

class ToppingListTab extends StatelessWidget {
  final List<Topping> toppings;

  const ToppingListTab({Key key, this.toppings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      itemCount: toppings.length,
      itemBuilder: (_, idx) => ToppingListWidget(topping: toppings[idx]),
    );
  }
}
