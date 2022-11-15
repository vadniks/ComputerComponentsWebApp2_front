
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

  List<Widget> _makeItemContent(List<String>? values) {
    final list = <Widget>[],
      j = _dbTable.weightedColumns.values.iterator;
    for (final i in values ?? _dbTable.weightedColumns.keys) {
      assert(j.moveNext());
      list.add(Expanded(
        flex: (j.current * 100).floor(),
        child: Text(i),
      ));
    }
    return list;
  }

  Widget _makeItem(List<String>? values) => Container(
    decoration: values != null ? null : const BoxDecoration(
      color: Colors.black,
      boxShadow: [BoxShadow(
        color: darkSecondaryColor,
        offset: Offset(0, 0),
        spreadRadius: 1
      )]
    ),
    child: Row(children: _makeItemContent(values)),
  );

  int _weightOf<T extends PlaceableInDbTable>(T placeable, int index)
  => (placeable[index].value * 100).floor();

  Row _visualizeComponent(Component component) => Row(children: [
    Expanded(
      flex: _weightOf(component, 0),
      child: Text(component.id!.toString())
    ),
    Expanded(
      flex: _weightOf(component, 1),
      child: Text(component.title)
    ),
    Expanded(
      flex: _weightOf(component, 2),
      child: Text(component.type.name)
    ),
    Expanded(
      flex: _weightOf(component, 3),
      child: Text(component.description)
    ),
    Expanded(
      flex: _weightOf(component, 4),
      child: Text(component.cost.toString())
    ),
    Expanded(
      flex: _weightOf(component, 5),
      child: Text(component.image ?? nullString)
    )
  ]);

  Row _visualizeUser(User user) => Row(children: [
    Expanded(
      flex: _weightOf(user, 0),
      child: Text(user.id!.toString())
    ),
    Expanded(
      flex: _weightOf(user, 1),
      child: Text(user.name)
    ),
    Expanded(
      flex: _weightOf(user, 2),
      child: Text(user.role.toString())
    ),
    Expanded(
      flex: _weightOf(user, 3),
      child: Text(user.password)
    ),
    Expanded(
      flex: _weightOf(user, 4),
      child: Text(user.firstName ?? nullString)
    ),
    Expanded(
      flex: _weightOf(user, 5),
      child: Text(user.lastName ?? nullString)
    ),
    Expanded(
      flex: _weightOf(user, 6),
      child: Text(user.phone.toString())
    ),
    Expanded(
      flex: _weightOf(user, 7),
      child: Text(user.address ?? nullString)
    ),
    Expanded(
      flex: _weightOf(user, 8),
      child: Text(user.selection ?? nullString)
    )
  ]);

  Row _visualizeSession(Session session) => Row(children: [
    Expanded(
      flex: _weightOf(session, 0),
      child: Text(session.id)
    ),
    Expanded(
      flex: _weightOf(session, 1),
      child: Text(session.value)
    )
  ]);

  List<Widget> _makeItems() {
    switch (_dbTable) {
      case DatabaseTable.components: return [for (final i in _items) _visualizeComponent(i as Component)];
      case DatabaseTable.users: return [for (final i in _items) _visualizeUser(i as User)];
      case DatabaseTable.sessions: return [for (final i in _items) _visualizeSession(i as Session)];
    }
  }

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
