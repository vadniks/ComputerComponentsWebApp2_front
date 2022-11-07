
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> _makeItems() {
    final list = <Widget>[];
    for (final i in components.entries)
      list.add(Card(
        margin: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 5
        ),
        child: Material(child: ListTile(
          onTap: () {},
          leading: SvgPicture.asset(
            i.value + svgExtension,
            width: 50,
            height: 50,
          ),
          title: const Text(
            'Title',
            style: TextStyle(fontWeight: FontWeight.bold)
          ),
          subtitle: Text(i.key),
          trailing: const Text(
            '0\$',
            style: TextStyle(fontStyle: FontStyle.italic)
          ),
        )),
      ));
    return list;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: SvgPicture.asset(
          appIcon,
          width: 50,
          height: 50,
        )
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              appName,
              style: TextStyle(fontSize: 20),
            ),
            Text(
              appSince,
              style: TextStyle(fontSize: 12),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Text(
                appSlogan,
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic
                ),
              ),
            )
          ]
        ),
      ),
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
      child: Container(
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
          Row(children: const [Expanded(child: ColoredBox(
            color: darkSecondaryColor,
            child: Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text(
                componentsList,
                style: TextStyle(fontSize: 20)
              )
            )
          ))]),
          Expanded(child: RefreshIndicator(
            backgroundColor: darkSecondaryColor,
            onRefresh: () async { },
            child: ListView(children: ListTile.divideTiles(
              tiles: _makeItems(),
              color: Colors.white10
            ).toList())
          )),
          ColoredBox(
            color: darkSecondaryColor,
            child: Flex(direction: Axis.horizontal, mainAxisAlignment: MainAxisAlignment.end, children: [
              const Text(
                totalCost,
                style: TextStyle(fontSize: 16),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(clearSelection)
              ),
              TextButton(
                onPressed: () {},
                child: const Text(submitOrder)
              )
            ])
          )
        ]),
      )
    ),
  );
}
