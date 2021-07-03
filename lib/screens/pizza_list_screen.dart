import 'package:flutter/material.dart';
import 'package:pizza_delivery/models/fav.dart';
import 'package:pizza_delivery/models/pizza.dart';
import 'package:pizza_delivery/services/database_services.dart';

class PizzaListScreen extends StatelessWidget {
  static const routeName = '/pizza-list';

  @override
  Widget build(BuildContext context) {
    final title = (ModalRoute.of(context).settings.arguments as List)[0] as String;
    final pizzas = (ModalRoute.of(context).settings.arguments as List)[1] as List<Pizza>;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<Fav>(
          future: FavDatabaseHandler.getFav,
          builder: (_, snap) {
            return ListView.builder(
              itemCount: pizzas.length,
              itemBuilder: (_, idx) => pizzaItem(pizzas[idx]),
            );
          }),
    );
  }

  Widget pizzaItem(Pizza pizza) {
    return Card(
      elevation: 3,
      child: Column(
        children: [
          Stack(
            children: [
              Opacity(
                opacity: 0.2,
                child: Image.asset(
                  pizza.imgFile,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Align(
                child: GestureDetector(
                  child: Icon(Icons.favorite_border),
                ),
              ),
            ],
          ),
          Container(
            child: Column(
              children: [
                Text(pizza.name),
                Text(pizza.priceINR.toStringAsFixed(2) + ' INR'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
