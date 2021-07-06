import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/beverage.dart';
import '../models/order.dart';
import '../models/pizza.dart';
import '../models/topping.dart';
import '../services/database_services.dart';

class OrderTrackScreen extends StatefulWidget {
  static const routeName = '/order-track';

  @override
  _OrderTrackScreenState createState() => _OrderTrackScreenState();
}

class _OrderTrackScreenState extends State<OrderTrackScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Track Orders')),
      body: FutureBuilder<List<Order>>(
          future: OrderDatabaseHandler.orders,
          builder: (ctx, snap) {
            return snap.connectionState != ConnectionState.done
                ? Center(child: Text('Loading...'))
                : (!snap.hasData || (snap.hasData && snap.data.isEmpty))
                    ? Center(
                        child: Text(
                          'No Orders Yet!\n'
                          'Make one now!',
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        itemCount: snap.data.length,
                        itemBuilder: (_, idx) => _OrderWidget(snap.data[idx], setState),
                      );
          }),
    );
  }
}

class _OrderWidget extends StatelessWidget {
  final Order _order;
  final void Function(void Function()) setState;

  const _OrderWidget(this._order, this.setState);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  children: [
                    Text(
                      DateFormat('dd MMM yyyy').format(_order.datetime),
                      style: TextStyle(fontSize: 16),
                    ),
                    Spacer(),
                    Text(
                      DateFormat('HH:mm:ss').format(_order.datetime) + ' IST',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              header,
              if (_order.pizzaManias.isNotEmpty) ...[
                sectionTitle('Pizza Mania'),
                ..._order.pizzaManias.entries.map((e) => pizzaItem(e)).toList(),
              ],
              if (_order.pizzas.isNotEmpty) ...[
                sectionTitle('Pizza'),
                ..._order.pizzas.entries.map((e) => pizzaItem(e)).toList(),
              ],
              if (_order.toppings.isNotEmpty) ...[
                sectionTitle('Toppings'),
                ..._order.toppings.entries.map((e) => toppingItem(e)).toList(),
              ],
              if (_order.beverages.isNotEmpty) ...[
                sectionTitle('Beverage'),
                ..._order.beverages.entries.map((e) => beverageItem(e)).toList(),
              ],
              Divider(),
              totalAmt(_order.totalAmt),
              progress(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget progress(context) {
    final doneColor = Colors.indigo;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              progressIcon(Icons.add_outlined, doneColor),
              progressIntermediate(doneColor),
              progressIcon(Icons.local_fire_department, [OrderStatus.Delivered, OrderStatus.Processing].contains(_order.orderStatus) ? doneColor : null),
              progressIntermediate([OrderStatus.Delivered, OrderStatus.Processing].contains(_order.orderStatus) ? doneColor : null),
              progressIcon(Icons.verified, _order.orderStatus == OrderStatus.Delivered ? doneColor : null),
            ],
          ),
          if (_order.orderStatus != OrderStatus.Delivered)
            FlatButton(
              onPressed: () async {
                final idx = OrderStatus.values.indexOf(_order.orderStatus);
                _order.orderStatus = OrderStatus.values[idx + 1];
                await OrderDatabaseHandler.updateOrder(_order);
                setState(() {});
              },
              child: Text('Update order!'),
            ),
        ],
      ),
    );
  }

  Widget progressIcon(IconData icon, [Color color]) {
    if (color == null) color = Colors.grey;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 2),
        shape: BoxShape.circle,
        color: color == Colors.grey ? Colors.white : color,
      ),
      padding: EdgeInsets.all(4),
      child: Icon(icon, color: color == Colors.grey ? color : Colors.white, size: 25),
    );
  }

  Widget progressIntermediate([Color color]) {
    if (color == null) color = Colors.grey;
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: color,
        ),
        height: color == Colors.grey ? 2 : 4,
        width: double.infinity,
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Divider(indent: 40, thickness: 1, color: Colors.grey[400]),
        Container(
          color: Colors.white,
          margin: EdgeInsets.symmetric(vertical: 1),
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            title,
            style: TextStyle(fontSize: 17),
          ),
        ),
      ],
    );
  }

  Widget pizzaItem(MapEntry<Pizza, int> e) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1, horizontal: 5),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              flex: 8,
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: e.key.veg ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    height: 10,
                    width: 10,
                  ),
                  SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      e.key.name,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  e.key.priceINR.toStringAsFixed(2),
                  style: GoogleFonts.robotoMono(fontSize: 16),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  e.value.toString(),
                  style: GoogleFonts.robotoMono(fontSize: 16),
                ),
              ),
            ),
            amountField(e.value * e.key.priceINR),
          ],
        ),
      ),
    );
  }

  Widget beverageItem(MapEntry<Beverage, int> e) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1, horizontal: 5),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              flex: 8,
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    height: 10,
                    width: 10,
                  ),
                  SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      e.key.name,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  e.key.priceINR.toStringAsFixed(2),
                  style: GoogleFonts.robotoMono(fontSize: 16),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  e.value.toString(),
                  style: GoogleFonts.robotoMono(fontSize: 16),
                ),
              ),
            ),
            amountField(e.value * e.key.priceINR),
          ],
        ),
      ),
    );
  }

  Widget toppingItem(MapEntry<Topping, int> e) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1, horizontal: 5),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              flex: 8,
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    height: 10,
                    width: 10,
                  ),
                  SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      e.key.name,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  e.key.priceINR.toStringAsFixed(2),
                  style: GoogleFonts.robotoMono(fontSize: 16),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  e.value.toString(),
                  style: GoogleFonts.robotoMono(fontSize: 16),
                ),
              ),
            ),
            amountField(e.value * e.key.priceINR),
          ],
        ),
      ),
    );
  }

  Widget get header {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1, horizontal: 5),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              flex: 8,
              child: Text('Item Name'),
            ),
            Expanded(
              flex: 3,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text('Price'),
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text('Qty.'),
              ),
            ),
            Expanded(
              flex: 5,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text('Amount (INR)'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget totalAmt(double total) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              flex: 13,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Total',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            amountField(total, true),
          ],
        ),
      ),
    );
  }

  Widget amountField(double amt, [bool bold = false]) {
    return Expanded(
      flex: 5,
      child: Align(
        alignment: Alignment.centerRight,
        child: FittedBox(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              ' ' + amt.toStringAsFixed(2),
              style: GoogleFonts.robotoMono(fontSize: 16.5, fontWeight: bold ? FontWeight.bold : null),
            ),
          ),
        ),
      ),
    );
  }
}
