import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:pizza_delivery/services/auth_service.dart';

class HomeNavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              FutureBuilder<Auth>(
                  future: AuthService.getAuth,
                  builder: (ctx, snap) {
                    final auth = snap.hasData ? snap.data : null;
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange[900],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Text(
                              auth == null ? '' : auth.name[0],
                              style: TextStyle(fontSize: 25, color: Colors.deepOrange[900]),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  auth == null ? '' : auth.name,
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  auth == null ? '' : auth.num,
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              Expanded(
                child: ListView(
                  children: [
                    _DrawerItem(
                      icon: Icons.restaurant_menu,
                      name: 'Menu',
                    ),
                    _DrawerItem(
                      icon: Icons.local_offer_outlined,
                      name: 'Deals & Offers',
                    ),
                    Divider(),
                    _DrawerItem(
                      icon: Icons.not_listed_location_outlined,
                      name: 'Track Order',
                    ),
                    _DrawerItem(
                      icon: Icons.compare_arrows,
                      name: 'Order History',
                    ),
                    _DrawerItem(
                      icon: Icons.favorite_border,
                      name: 'My Favourites',
                    ),
                    Divider(),
                    _DrawerItem(
                      icon: Entypo.user,
                      name: 'Contact Us',
                    )
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

class _DrawerItem extends StatelessWidget {
  final String name, routeName;
  final IconData icon;

  const _DrawerItem({Key key, this.name, this.routeName, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (routeName != null) Navigator.of(context).pushNamed(routeName);
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Row(
          children: [
            Icon(icon, color: Colors.deepOrange[800]),
            SizedBox(width: 20),
            Text(
              name,
              style: TextStyle(
                color: Colors.deepOrange[800],
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
