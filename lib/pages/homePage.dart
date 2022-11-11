
// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';

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
  final _selected = List<Component?>.filled(Type.amount, null, growable: false);

  NavigatorState get _navigator => Navigator.of(context);

  Future<void> _onItemClick(Type type) async {
    final dynamic result = await _navigator.pushNamed(
      routeSelect,
      arguments: type
    );

    if (result != null && result is! Component) throw ArgumentError(null);
    if (!mounted) return;
    result as Component;

    setState(() => _selected[result.type.index] = result);
  }

  Image _decodeImage(String base64) =>
      Image.memory(const Base64Decoder().convert(base64));

  List<Widget> _makeItems() {
    final list = <Widget>[];
    for (final i in Type.types) {
      final component = _selected[i.index];
      list.add(Card(
        margin: const EdgeInsets.all(5),
        child: Material(child: ListTile(
          onTap: () => _onItemClick(i),
          leading: component?.image != null
            ? _decodeImage(component!.image!)
            : SvgPicture.asset(
              i.icon + svgExtension,
              width: 50,
              height: 50,
            ),
          title: const Text(
            'Title',
            style: TextStyle(fontWeight: FontWeight.bold)
          ),
          subtitle: Text(
            component != null ? component.title : i.title,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            component != null ? component.cost.toString() : defaultCost,
            style: const TextStyle(fontStyle: FontStyle.italic)
          ),
        )),
      ));
    }
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
        onPressed: () => _navigator.pushNamed(routeAbout),
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
