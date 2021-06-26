import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeNavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Container(
          color: Colors.deepOrange,
          child: Column(
            children: [
              Container(
                child: Row(
                  children: [
                    CircleAvatar(
                      child: Text(''),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(''),
                          Text(''),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      title: Text('Menu'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
