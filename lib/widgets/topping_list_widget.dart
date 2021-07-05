import 'package:flutter/material.dart';
import 'package:pizza_delivery/models/topping.dart';
import 'package:pizza_delivery/services/database_services.dart';
import 'package:pizza_delivery/utils/ref_utils.dart';

class ToppingListWidget extends StatefulWidget {
  final Topping topping;
  final void Function(void Function()) refresh;

  const ToppingListWidget({Key key, this.topping, this.refresh}) : super(key: key);

  @override
  _ToppingListWidgetState createState() => _ToppingListWidgetState();
}

class _ToppingListWidgetState extends State<ToppingListWidget> {
  @override
  Widget build(BuildContext context) {
    final fav = FavDatabaseHandler.fav;
    final isFav = fav != null && (fav.toppings ?? []).contains(widget.topping);
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
                      widget.topping.imgFile,
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
                      await FavDatabaseHandler.toggleTopping(widget.topping);
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
                        color: Colors.green,
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
                      RefUtils.INR + '' + widget.topping.priceINR.toStringAsFixed(2),
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
                    widget.topping.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.topping.desc,
                    style: TextStyle(fontSize: 16),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: RaisedButton(
                      color: Colors.white,
                      child: Text('Add To Cart'),
                      onPressed: () async {
                        final cart = await CartDatabaseHandler.getCart;
                        cart.toppings.update(widget.topping, (value) => value + 1, ifAbsent: () => 1);
                        CartDatabaseHandler.setCart(cart);
                        Scaffold.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Text(widget.topping.name + ' added to cart!'),
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
