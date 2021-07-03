import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeExploreMenuWidget extends StatelessWidget {
  final String imgName, name, routeName;
  final List items;

  const HomeExploreMenuWidget({Key key, this.imgName, this.name, this.routeName, this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(routeName, arguments: [name, items]);
      },
      child: Card(
        elevation: 4,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey[100], width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (imgName != null) ...[
                Expanded(
                  child: Image.asset(
                    'assets/images/menus/' + imgName,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 5),
              ],
              Text(
                name,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
