import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pizza_delivery/models/demo_data.dart';
import 'package:pizza_delivery/models/pizza.dart';
import 'package:pizza_delivery/services/database_services.dart';
import 'package:pizza_delivery/utils/ref_utils.dart';

class HomeBestSellerWidget extends StatelessWidget {
  final Pizza pizza;

  const HomeBestSellerWidget(this.pizza);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        width: 140,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Image.asset(
                    pizza.imgFile,
                    height: 200,
                    width: 150,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        pizza.name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: pizza.veg ? Colors.green[700] : Colors.red[700],
                          backgroundColor: Colors.white,
                        ),
                      ),
                      Text('${RefUtils.INR} ${pizza.priceINR.toStringAsFixed(2)}')
                    ],
                  ),
                ),
              ],
            ),
            FlatButton(
              onPressed: () async {
                final cart = await CartDatabaseHandler.getCart;
                if (DemoData.pizzas[true].contains(pizza) || DemoData.pizzas[false].contains(pizza)) {
                  cart.pizzas.update(pizza, (value) => value + 1, ifAbsent: () => 1);
                } else {
                  cart.pizzaManias.update(pizza, (value) => value + 1, ifAbsent: () => 1);
                }
                CartDatabaseHandler.setCart(cart);
                Scaffold.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(pizza.name + ' added to cart!'),
                    ),
                  );
              },
              child: Text(
                'Add To Cart',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 17,
                  shadows: [Shadow(offset: Offset(1.5, 1.5), color: Colors.grey[200])],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
