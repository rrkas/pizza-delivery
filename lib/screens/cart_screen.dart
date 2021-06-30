import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pizza_delivery/models/cart.dart';
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
                  : SizedBox();
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
    return Container();
  }
}
