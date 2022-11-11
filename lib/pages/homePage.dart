
// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import '../widgets/basicAppBar.dart';
import '../widgets/basicBottomBar.dart';
import '../widgets/basicWindow.dart';
import '../consts.dart';
import '../component.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void _onItemClick(Type type) => Navigator.of(context).pushNamed(
    routeSelect,
    arguments: type
  );

  List<Widget> _makeItems() {
    final list = <Widget>[];
    for (final i in Type.types)
      list.add(Card(
        margin: const EdgeInsets.all(5),
        child: Material(child: ListTile(
          onTap: () => _onItemClick(i),
          leading: SvgPicture.asset(
            i.icon + svgExtension,
            width: 50,
            height: 50,
          ),
          title: const Text(
            'Title',
            style: TextStyle(fontWeight: FontWeight.bold)
          ),
          subtitle: Text(
            i.title,
            overflow: TextOverflow.ellipsis,
          ),
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
    appBar: BasicAppBar(buttons: [
      TextButton(
        onPressed: () {},
        child: const Text(home),
      ),
      TextButton(
        onPressed: () => Navigator.of(context).pushNamed(routeAbout),
        child: const Text(about)
      )
    ]),
    body: BasicWindow(
      titleWidgets: const [Text(
        componentsList,
        style: TextStyle(fontSize: 20)
      )],
      content: ListView(children: ListTile.divideTiles(
        tiles: _makeItems(),
        color: Colors.white10
      ).toList()),
      footerWidgets: [
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
      ],
    ),
    bottomNavigationBar: const BasicBottomBar()
  );
}
