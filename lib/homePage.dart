
// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'consts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _itemsCount = 10;
  late final ScrollController _controller;

  List<Widget> _makeItems() {
    final list = <Widget>[];
    for (final i in components.entries)
      list.add(Row(children: [
        ImageIcon(AssetImage(i.value))
      ]));
    return list;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Row(children: [
        SvgPicture.asset(
          appIcon,
          width: appIconWidthHeight,
          height: appIconWidthHeight,
        ),
        Padding(
          padding: const EdgeInsets.only(left: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                appName,
                style: TextStyle(fontSize: 16),
              ),
              Text(
                appSince,
                style: TextStyle(fontSize: 12),
              ),
              Text(
                appSlogan,
                style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic
                ),
              )
            ]
          ),
        )
      ]),
      actions: [
        TextButton(
          onPressed: () {},
          child: const Text(home),
        ),
        TextButton(
            onPressed: () {},
            child: const Text(about)
        )
      ],
    ),
    body: Padding(
      padding: const EdgeInsets.all(50),
      child: Expanded(child: RefreshIndicator(
        backgroundColor: darkSecondaryColor,
        onRefresh: () async { },
        child: ListView(
          controller: _controller,
          children: _makeItems()
        ),
      )),
    ),
  );
}
