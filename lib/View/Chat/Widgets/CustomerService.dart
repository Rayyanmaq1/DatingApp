import 'package:flutter/material.dart';
import 'package:livu/SizedConfig.dart';
import 'package:livu/theme.dart';

class CustomerService extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [redColor, orangeColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage('assets/CustomerService.png'),
          ),
        ),
      ),
      title: Text(
        'Customer Service',
        style: TextStyle(
            color: redColor, fontSize: SizeConfig.textMultiplier * 2.3),
      ),
    );
  }
}
