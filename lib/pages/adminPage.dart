
// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import '../consts.dart';
import '../interop/DatabaseTable.dart';
import '../interop/session.dart';
import '../interop/user.dart';
import '../widgets/basicAppBar.dart';
import '../widgets/basicBottomBar.dart';
import '../widgets/basicWindow.dart';
import '../interop/placeableInDbTable.dart';
import '../interop/component.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<StatefulWidget> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  var _dbTable = DatabaseTable.components;
  final List<PlaceableInDbTable> _items = [];

  NavigatorState get _navigator => Navigator.of(context);

  @override
  void initState() {
    super.initState();

  }

  void _changeTable() {

  }

  void _select() {

  }

  void _insert() {

  }

  List<Expanded> _makeItemContent(List<String>? values) {
    final list = <Expanded>[], j = _dbTable.weightedColumns.values.iterator;
    for (final i in values ?? _dbTable.weightedColumns.keys) {
      assert(j.moveNext());
      list.add(Expanded(
        flex: (j.current * 100).floor(),
        child: Text(i),
      ));
    }
    return list;
  }

  Container _makeItem(List<String>? values) => Container(
    decoration: values != null ? null : const BoxDecoration(
      color: Colors.black,
      boxShadow: [BoxShadow(
        color: darkSecondaryColor,
        offset: Offset(0, 0),
        spreadRadius: 1
      )]
    ),
    child: Row(children: _makeItemContent(values))
  );

  List<Widget> _makeItems() => [for (final i in _items) _makeItem(i.values)];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: BasicAppBar(trailings: [TextButton(
      onPressed: _navigator.pop,
      child: const Text(home)
    )]),
    body: BasicWindow(
      titleWidgets: [
        const Text(databaseAdministration),
        Row(children: [
          TextButton(
            onPressed: _changeTable,
            child: Text(_dbTable.table)
          ),
          TextButton(
            onPressed: _select,
            child: const Text(select)
          ),
          TextButton(
            onPressed: _insert,
            child: const Text(insert)
          )
        ])
      ],
      content: Column(children: [
        _makeItem(null),
        ..._makeItems()
      ]),
      footerWidgets: defaultFooter
    ),
    bottomNavigationBar: const BasicBottomBar(),
  );
}
