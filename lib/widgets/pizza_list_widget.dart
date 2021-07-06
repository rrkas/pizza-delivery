import 'package:flutter/material.dart';

import '../models/demo_data.dart';
import '../models/pizza.dart';
import '../services/database_services.dart';
import '../utils/ref_utils.dart';

class PizzaListWidget extends StatefulWidget {
  final Pizza pizza;
  final void Function(void Function()) refresh;

  const PizzaListWidget({Key key, this.pizza, this.refresh}) : super(key: key);

  @override
  _PizzaListWidgetState createState() => _PizzaListWidgetState();
}

class _PizzaListWidgetState extends State<PizzaListWidget> {
  @override
  Widget build(BuildContext context) {
    final fav = FavDatabaseHandler.fav;
    final isFav = fav != null && ((fav.pizzas ?? []) + (fav.pizzaManias ?? [])).contains(widget.pizza);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3),
      child: Card(
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Center(
                  child: Opacity(
                    opacity: 0.7,
                    child: Image.asset(
                      widget.pizza.imgFile,
                      height: 120,
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width - 150,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () async {
                      await FavDatabaseHandler.togglePizza(widget.pizza);
                      setState(() {});
                      if (widget.refresh != null) widget.refresh(() {});
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      color: Colors.white70,
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        size: 30,
                        color: isFav ? Colors.red : Colors.black,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(2),
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: widget.pizza.veg ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    child: Text(
                      RefUtils.INR + '' + widget.pizza.priceINR.toStringAsFixed(2),
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.pizza.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.pizza.desc,
                    style: TextStyle(fontSize: 16),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: RaisedButton(
                      color: Colors.white,
                      child: Text('Add To Cart'),
                      onPressed: () async {
                        final cart = await CartDatabaseHandler.getCart;
                        if (DemoData.pizzas[true].contains(widget.pizza) || DemoData.pizzas[false].contains(widget.pizza)) {
                          cart.pizzas.update(widget.pizza, (value) => value + 1, ifAbsent: () => 1);
                        } else {
                          cart.pizzaManias.update(widget.pizza, (value) => value + 1, ifAbsent: () => 1);
                        }
                        CartDatabaseHandler.setCart(cart);
                        Scaffold.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Text(widget.pizza.name + ' added to cart!'),
                            ),
                          );
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
