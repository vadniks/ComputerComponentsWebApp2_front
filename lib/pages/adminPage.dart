
// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:cursov_front/interop/component.dart';
import 'package:flutter/material.dart';
import '../consts.dart';
import '../interop/DatabaseTable.dart';
import '../interop/session.dart';
import '../interop/user.dart';
import '../widgets/basicAppBar.dart';
import '../widgets/basicBottomBar.dart';
import '../widgets/basicWindow.dart';
import '../interop/placeableInDbTable.dart';
import '../util.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<StatefulWidget> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  var _dbTable = DatabaseTable.components;
  final List<PlaceableInDbTable> _items = [];
  var _isFetching = false, _hasFetched = false;

  NavigatorState get _navigator => Navigator.of(context);

  @override
  void initState() {
    super.initState();
    _loadAllItems();
  }

  @Deprecated('test only')
  Future<List<Component>> _testFetchComponents() async
  => [for (int i = 0; i < 10; i++) Component(
        title: i.toString(),
        type: i % 2 == 0 ? Type.cpu : Type.gpu,
        description: (i * 10).toString(),
        cost: i * 100
      )];

  @Deprecated('test only')
  Future<List<User>> _testFetchUsers() async
  => [for (int i = 0; i < 10; i++) User(
        name: i.toString(),
        role: Role.user,
        password: (i * 10).toString()
      )];

  @Deprecated('test only')
  Future<List<Session>> _testFetchSessions() async
  => [for (int i = 0; i < 10; i++) Session(i.toString(), (i * 10).toString())];

  Future<void> _loadAllItems() async {
    setState(() => _isFetching = true);

    Future.delayed(const Duration(seconds: 1));

    final List<PlaceableInDbTable> items;
    switch (_dbTable) {
      case DatabaseTable.components: items = await _testFetchComponents(); break;
      case DatabaseTable.users: items = await _testFetchUsers(); break;
      case DatabaseTable.sessions: items = await _testFetchSessions(); break;
    }

    if (items.isNotEmpty) setState(() => _items.addAll(items));
    setState(() {
      _hasFetched = true;
      _isFetching = false;
    });
  }

  void _changeTable() {

  }

  void _select() {

  }

  void _insert() {

  }

  List<Expanded> _makeItemContent(PlaceableInDbTable? placeable) {
    final list = <Expanded>[], j = _dbTable.weightedColumns.values.iterator, k = placeable != null;
    for (final i in placeable?.values ?? _dbTable.weightedColumns.keys) {
      assert(j.moveNext());
      list.add(Expanded(
        flex: (j.current * 100).floor(),
        child: Text(
          i,
          style: TextStyle(
            fontWeight: k ? FontWeight.normal : FontWeight.bold,
            color: !k ? Colors.white54 : Colors.white70
          ),
        ),
      ));
    }
    return list;
  }

  Widget _makeItem(int index) => Material(child: ListTile(
    onTap: index == 0 ? null : () {},
    title: Row(children: _makeItemContent(index == 0 ? null : _items[index]))
  ));

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: BasicAppBar(trailings: [TextButton(
      onPressed: _navigator.pop,
      child: const Text(home)
    )]),
    body: BasicWindow(
      showLoading: _isFetching,
      titleWidgets: [
        const Text(databaseAdministration),
        Row(children: [
          TextButton(
            onPressed: _changeTable,
            child: Text(
              _dbTable.table,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white70
              )
            )
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
      content: _hasFetched && _items.isEmpty
        ? const Center(child: Text(
          empty,
          style: TextStyle(fontSize: 18),
        ))
        : ListView.separated(
          itemBuilder: (_, index) => _makeItem(index),
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemCount: _items.length
        ),
      footerWidgets: defaultFooter
    ),
    bottomNavigationBar: const BasicBottomBar(),
  );
}
