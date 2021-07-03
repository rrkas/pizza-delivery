import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pizza_delivery/models/beverage.dart';
import 'package:pizza_delivery/models/cart.dart';
import 'package:pizza_delivery/models/pizza.dart';
import 'package:pizza_delivery/models/topping.dart';
import 'package:pizza_delivery/services/database_services.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      body: FutureBuilder<Cart>(
        future: CartDatabaseHandler.getCart,
        builder: (ctx, snap) {
          return snap.connectionState != ConnectionState.done
              ? Center(
                  child: Text('Loading'),
                )
              : snap.data.totalAmt == 0
                  ? Center(
                      child: FittedBox(
                        child: Center(
                          child: Text(
                            'Nothing in cart!\nAdd something to cart!',
                            style: TextStyle(fontSize: 17),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  : _CartWidget(
                      cart: snap.data,
                      updateCart: (cart) async {
                        await CartDatabaseHandler.setCart(cart);
                        setState(() {});
                      },
                    );
        },
      ),
    );
  }
}

class _CartWidget extends StatelessWidget {
  final Cart cart;
  final void Function(Cart) updateCart;

  const _CartWidget({Key key, this.cart, this.updateCart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            children: [
              if (cart.pizzaManias.isNotEmpty) ...[
                ...cart.pizzaManias.entries
                    .map(
                      (e) => pizzaItem(
                        e,
                        (c) {
                          if (c == 0) {
                            cart.pizzaManias.remove(e.key);
                          } else {
                            cart.pizzaManias.update(e.key, (value) => c);
                          }
                          updateCart(cart);
                        },
                      ),
                    )
                    .toList(),
              ],
              if (cart.pizzas.isNotEmpty) ...[
                ...cart.pizzas.entries
                    .map(
                      (e) => pizzaItem(
                        e,
                        (c) {
                          if (c == 0) {
                            cart.pizzas.remove(e.key);
                          } else {
                            cart.pizzas.update(e.key, (value) => c);
                          }
                          updateCart(cart);
                        },
                      ),
                    )
                    .toList(),
              ],
              if (cart.toppings.isNotEmpty) ...[
                ...cart.toppings.entries
                    .map(
                      (e) => toppingItem(
                        e,
                        (c) {
                          if (c == 0) {
                            cart.toppings.remove(e.key);
                          } else {
                            cart.toppings.update(e.key, (value) => c);
                          }
                          updateCart(cart);
                        },
                      ),
                    )
                    .toList(),
              ],
              if (cart.beverages.isNotEmpty) ...[
                ...cart.beverages.entries
                    .map(
                      (e) => beverageItem(
                        e,
                        (c) {
                          if (c == 0) {
                            cart.beverages.remove(e.key);
                          } else {
                            cart.beverages.update(e.key, (value) => c);
                          }
                          updateCart(cart);
                        },
                      ),
                    )
                    .toList(),
              ],
            ],
          ),
        ),
        totalAmt(cart.totalAmt),
      ],
    );
  }

  Widget pizzaItem(MapEntry<Pizza, int> e, Function(int) update) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Row(
          children: [
            Image.asset(
              e.key.imgFile,
              height: 70,
              width: 70,
            ),
            SizedBox(width: 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      vegIndicator(e.key.veg),
                      Text(e.key.name, style: TextStyle(fontSize: 17)),
                    ],
                  ),
                  Row(
                    children: [
                      counterWidget(e.value, update),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('x'),
                      ),
                      Text(
                        e.key.priceINR.toStringAsFixed(2) + ' INR',
                        style: GoogleFonts.robotoMono(),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      (e.key.priceINR * e.value).toStringAsFixed(2) + ' INR',
                      style: GoogleFonts.robotoMono(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget beverageItem(MapEntry<Beverage, int> e, Function(int) update) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Row(
          children: [
            Image.asset(
              e.key.imgFile,
              height: 70,
              width: 70,
            ),
            SizedBox(width: 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      vegIndicator(true),
                      Text(e.key.name, style: TextStyle(fontSize: 17)),
                    ],
                  ),
                  Row(
                    children: [
                      counterWidget(e.value, update),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('x'),
                      ),
                      Text(
                        e.key.priceINR.toStringAsFixed(2) + ' INR',
                        style: GoogleFonts.robotoMono(),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      (e.key.priceINR * e.value).toStringAsFixed(2) + ' INR',
                      style: GoogleFonts.robotoMono(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget toppingItem(MapEntry<Topping, int> e, Function(int) update) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Row(
          children: [
            Image.asset(
              e.key.imgFile,
              height: 70,
              width: 70,
            ),
            SizedBox(width: 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      vegIndicator(true),
                      Text(e.key.name, style: TextStyle(fontSize: 17)),
                    ],
                  ),
                  Row(
                    children: [
                      counterWidget(e.value, update),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('x'),
                      ),
                      Text(
                        e.key.priceINR.toStringAsFixed(2) + ' INR',
                        style: GoogleFonts.robotoMono(),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      (e.key.priceINR * e.value).toStringAsFixed(2) + ' INR',
                      style: GoogleFonts.robotoMono(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget totalAmt(double total) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      width: double.infinity,
      child: Text(total.toStringAsFixed(2) + ' INR'),
    );
  }

  Widget vegIndicator(bool veg) {
    return Container(
      height: 10,
      width: 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: veg ? Colors.green : Colors.red,
      ),
    );
  }

  Widget counterWidget(int c, Function(int) update) {
    return Card(
      elevation: 2,
      child: IntrinsicHeight(
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                update(c - 1);
              },
              child: Container(
                color: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                child: Text(
                  '—',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            VerticalDivider(width: 0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                c.toString(),
                style: TextStyle(fontSize: 17),
              ),
            ),
            VerticalDivider(width: 0),
            GestureDetector(
              onTap: () {
                update(c + 1);
              },
              child: Container(
                color: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                child: Text(
                  '+',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
