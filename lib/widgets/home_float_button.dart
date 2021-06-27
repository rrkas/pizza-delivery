import 'package:flutter/material.dart';

class HomeFloatButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function() onClick;
  final BorderRadius borderRadius;

  const HomeFloatButton({
    Key key,
    this.icon,
    this.text,
    this.onClick,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: Theme.of(context).primaryColor,
        ),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            Text(
              text,
              style: TextStyle(fontSize: 17, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
