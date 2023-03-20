
import 'package:flutter/material.dart';
import '../consts.dart';

class BasicWindow extends Padding {
  final List<Widget> titleWidgets;
  final Widget content;
  final List<Widget> footerWidgets;
  final bool showLoading;
  final bool expandContent;
  final double width;
  final MainAxisAlignment footerWidgetsAlignment;

  const BasicWindow({
    super.key,
    required this.titleWidgets,
    required this.content,
    required this.footerWidgets,
    super.padding = const EdgeInsets.all(50),
    this.showLoading = false,
    this.expandContent = true,
    this.width = -1,
    this.footerWidgetsAlignment = MainAxisAlignment.end
  });

  @override
  Widget? get child => Center(child: Container(
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
    child: SizedBox(
      width: width > 0 ? width : double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ColoredBox(
            color: darkSecondaryColor,
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: titleWidgets
              )
            )
          ),
          if (showLoading) const LinearProgressIndicator(value: null),
          expandContent ? Expanded(child: content) : content,
          ColoredBox(
            color: darkSecondaryColor,
            child: Row(
              mainAxisAlignment: footerWidgetsAlignment,
              children: footerWidgets
            )
          )
        ]
      )
    )
  ));
}
