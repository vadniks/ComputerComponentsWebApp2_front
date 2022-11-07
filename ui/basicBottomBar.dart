
import 'package:flutter/material.dart';
import 'consts.dart';

class BasicBottomBar extends ColoredBox {

  const BasicBottomBar({super.key}) : super(color: darkSecondaryColor);

  @override
  Widget? get child => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Text(
        copyright,
        style: TextStyle(color: Colors.white60)
      ),
    )],
  );
}
