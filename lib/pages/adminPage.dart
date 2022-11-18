
// ignore_for_file: curly_braces_in_flow_control_structures

import '../interop/component.dart';
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
import 'errorPage.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<StatefulWidget> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  var _dbTable = DatabaseTable.components;
  final List<PlaceableInDbTable> _items = [];
  var _isFetching = false, _hasFetched = false;
  List<TextEditingController>? _controllers;
  var _authorized = false;

  @override
  Future<void> initState() async {
    super.initState();
    await _checkAuthorization();
    if (_authorized) _loadAllItems();
  }

  Future<void> _checkAuthorization() async {
    final result = await authorizedAsAdmin;
    setState(() => _authorized = result);
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

    // await Future.delayed(const Duration(seconds: 2)); // TODO: test

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

  void _resetItemsList() => setState(() {
    _items.clear();
    _hasFetched = false;
  });

  Future<void> _changeTable() async {
    await _checkAuthorization();
    if (!_authorized) {
      if (mounted) showSnackBar(context, unauthorizedAsAdmin);
      return;
    }
    _resetItemsList();
    setState(() { switch (_dbTable) {
      case DatabaseTable.components: _dbTable = DatabaseTable.users; break;
      case DatabaseTable.users: _dbTable = DatabaseTable.sessions; break;
      case DatabaseTable.sessions: _dbTable = DatabaseTable.components; break;
    } });
    _loadAllItems();
  }

  Future<void> _showItemDetails(
    PlaceableInDbTable? placeable,
    String? operation,
    void Function()? action
  ) async {
    await _checkAuthorization();
    if (!_authorized) {
      if (mounted) showSnackBar(context, unauthorizedAsAdmin);
      return;
    }

    if (!(operation == null && action == null
        || operation != null && action != null))
      throw Exception(null);

    _controllers?.clear();
    _controllers = List.generate(
      _dbTable.weightedColumns.keys.length,
      (index) => TextEditingController(text: placeable?.values[index])
    );

    showModalBottomSheet(
      constraints: const BoxConstraints(maxWidth: 520),
      context: context,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          boxShadow: [BoxShadow(
            color: darkSecondaryColor,
            spreadRadius: 1,
            offset: Offset(0, 0)
          )]
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    viewDetails,
                    style: TextStyle(fontSize: 18),
                  ),
                  operation != null
                    ? TextButton(
                      onPressed: action!,
                      child: Text(operation)
                    )
                    : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () => _update(placeable!),
                          child: const Text(update)
                        ),
                        TextButton(
                          onPressed: () => _delete(placeable!),
                          child: const Text(delete)
                        )
                      ]
                    )
                ]
              )
            ),
            Expanded(child: SingleChildScrollView(child: Column(children: [
              for (int i = 0; i < _dbTable.weightedColumns.length; i++)
                makeTextField(
                  controller: _controllers![i],
                  hint: _dbTable.weightedColumns.keys.elementAt(i)
                )
            ])))
          ]),
        )
      )
    );
  }

  void _select() => _showItemDetails(null, select, () {
    // TODO: get request
  });

  void _insert() => _showItemDetails(null, insert, () {
    // TODO: post request
  });

  void _update(PlaceableInDbTable placeable) {
    // TODO: put request
  }

  void _delete(PlaceableInDbTable placeable) {
    // TODO: delete request
  }

  List<Expanded> _makeItemContent(PlaceableInDbTable? placeable) {
    final list = <Expanded>[],
      weight = _dbTable.weightedColumns.values.iterator,
      isLeading = placeable != null;
    for (final value in placeable?.values ?? _dbTable.weightedColumns.keys) {
      if (!weight.moveNext()) throw Exception();
      list.add(Expanded(
        flex: (weight.current * 100).floor(),
        child: Text(
          value,
          style: TextStyle(
            fontWeight: isLeading ? FontWeight.normal : FontWeight.bold,
            color: !isLeading ? Colors.white54 : Colors.white70
          ),
        ),
      ));
    }
    return list;
  }

  Widget _makeItem(int index) => Material(child: ListTile(
    onTap: index == 0 ? null : () => _showItemDetails(
      _items[index],
      null,
      null
    ),
    title: Row(
      mainAxisSize: MainAxisSize.max,
      children: _makeItemContent(index == 0 ? null : _items[index])
    )
  ));

  @override
  Widget build(BuildContext context)
  => !_authorized ? const ErrorPage(error: forbidden) : Scaffold(
    appBar: BasicAppBar(trailings: [TextButton(
      onPressed: Navigator.of(context).pop,
      child: const Text(home)
    )]),
    body: BasicWindow(
      showLoading: _isFetching,
      titleWidgets: [
        const Text(
          databaseAdministration,
          style: TextStyle(fontSize: 18),
        ),
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
