import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/beverage.dart';
import '../models/order.dart';
import '../models/pizza.dart';
import '../models/topping.dart';
import '../services/database_services.dart';

class OrderListScreen extends StatelessWidget {
  static const routeName = '/order-list';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      body: FutureBuilder<List<Order>>(
          future: OrderDatabaseHandler.orders,
          builder: (ctx, snap) {
            final data = snap.connectionState != ConnectionState.done ? null : snap.data.where((element) => element.orderStatus == OrderStatus.Delivered).toList();
            return snap.connectionState != ConnectionState.done
                ? Center(
                    child: Text('Loading...'),
                  )
                : (!snap.hasData || (snap.hasData && snap.data.isEmpty))
                    ? Center(
                        child: Text(
                          'No Orders Yet!\n'
                          'Make one now!',
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : snap.data.length != data.length && data.isEmpty
                        ? Center(
                            child: Text(
                              'Some orders are on the way!',
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Column(
                            children: [
                              if (snap.data.length != data.length)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    'More ${snap.data.length - data.length} order${snap.data.length - data.length > 1 ? 's' : ''} on the way!',
                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              Expanded(
                                child: ListView.builder(
                                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                  itemCount: data.length,
                                  itemBuilder: (_, idx) => _OrderWidget(data[idx]),
                                ),
                              ),
                            ],
                          );
          }),
    );
  }
}

class _OrderWidget extends StatelessWidget {
  final Order _order;

  const _OrderWidget(this._order);

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
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Divider(indent: 40, thickness: 1, color: Colors.grey[400]),
        Container(
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
