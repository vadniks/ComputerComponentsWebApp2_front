
import 'package:flutter/material.dart';
import 'consts.dart';

class BasicWindow extends Padding {
  final List<Widget> titleWidgets;
  final Widget content;
  final List<Widget> footerWidgets;

  const BasicWindow({
    super.key,
    required this.titleWidgets,
    required this.content,
    required this.footerWidgets
  }) : super(padding: const EdgeInsets.all(50));

  @override
  Widget? get child => Container(
    decoration: const BoxDecoration(
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.white10,
            spreadRadius: 2,
            blurRadius: 2,
            offset: Offset(0, 0)
          )
        ]
    ),
    child: Column(children: [
      ColoredBox(
        color: darkSecondaryColor,
        child: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Row(children: titleWidgets)
        )
      ),
      Expanded(child: content),
      ColoredBox(
        color: darkSecondaryColor,
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.end,
          children: footerWidgets
        )
      ),
    ]),
  );
}
