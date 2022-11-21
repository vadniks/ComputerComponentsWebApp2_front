
// ignore_for_file: curly_braces_in_flow_control_structures, empty_statements

import 'dart:convert';

import 'package:cursov_front/interop/Selection.dart';

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
import 'package:http/http.dart' as http;

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

  NavigatorState get _navigator => Navigator.of(context);

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

  Future<List<PlaceableInDbTable>> _fetchPlaceable() async {
    String which;
    PlaceableInDbTable Function(Map<String, dynamic> json) converter;

    switch (_dbTable) {
      case DatabaseTable.components:
        which = DatabaseTable.components.table;
        converter = (json) => Component.fromJson(json);
        break;
      case DatabaseTable.users:
        which = DatabaseTable.users.table;
        converter = (json) => User.fromJson(json);
        break;
      case DatabaseTable.sessions:
        which = DatabaseTable.sessions.table;
        converter = (json) => Session.fromJson(json);
        break;
      default: throw Exception(null);
    }

    final response = await http.get('$baseUrl/${which.beforeLast}'.uri);
    return response.statusCode == 200
      ? [for (final dynamic i in jsonDecode(response.body)) converter(i)]
      : [];
  }

  Future<void> _loadAllItems() async {
    setState(() => _isFetching = true);

    final List<PlaceableInDbTable> items = await _fetchPlaceable();
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

  Future<void> _reloadItemsList() async {
    _resetItemsList();
    await _checkAuthorization();
    await _loadAllItems();
  }

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
      (index) {
        final text = placeable?.values[index];
        return TextEditingController(text: text == nullString ? stub : text);
      }
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
              for (var i = 0; i < _dbTable.weightedColumns.length; i++)
                makeTextField(
                  controller: _controllers![i], // TODO: add type check i.e. text, number...
                  hint: _dbTable.weightedColumns.keys.elementAt(i) +
                    (_dbTable.nullablesMask[i] ? ' $nullable' : stub),
                  isItalic: _dbTable.nullablesMask[i]
                )
            ])))
          ]),
        )
      )
    );
  }

  PlaceableInDbTable? _fieldsToPlaceable() {
    String? txt(int index) {
      final text = _controllers![index].text;
      return text.isEmpty ? null : text;
    }
    final id = txt(0);
    try { switch (_dbTable) {
      case DatabaseTable.components: return Component(
        id: id != null ? int.tryParse(id) : null,
        title: txt(1)!,
        type: Type.create2(txt(2)!)!,
        description: txt(3)!,
        cost: int.tryParse(txt(4)!)!,
        image: txt(5)
      );
      case DatabaseTable.users:
        final phone = txt(6);
        return User(
          id: id != null ? int.tryParse(id) : null,
          name: txt(1)!,
          role: Role.create(txt(2)!),
          password: txt(3)!,
          firstName: txt(4),
          lastName: txt(5),
          phone: phone != null ? int.tryParse(phone) : null,
          address: txt(7),
          selection: txt(8)
      );
      case DatabaseTable.sessions: return Session(id!, txt(1)!);
    } } catch (_) { return null; }
  }

  void _select() => _showItemDetails(null, select, () {
    // TODO: get request
  });

  Future<void> _postOrPut(PlaceableInDbTable? old) async {
    var placeable = _fieldsToPlaceable();
    if (placeable == null) {
      if (mounted) showSnackBar(context, incorrectData);
      return;
    }

    Future<http.Response> request(Uri uri, {String? body}) async => old == null
      ? http.post(uri, headers: jsonHeader, body: body)
      : http.put(uri, headers: jsonHeader , body: body);

    final result = (await request(
      '$baseUrl/${_dbTable.table.beforeLast}${old == null ? '' : '/${old.idProperty}'}'.uri,
      body: jsonEncode(placeable.asMap)
    )).statusCode == 200;

    if (result) {
      _reloadItemsList();
      if (mounted) _navigator.pop();
    }
    if (mounted) showSnackBar(
      context,
      result ? operationSucceeded : operationFailed
    );
  }

  void _insert() => _showItemDetails(null, insert, () async => _postOrPut(null));

  Future<void> _update(PlaceableInDbTable old) async => _postOrPut(old);

  Future<void> _delete(PlaceableInDbTable old) async {
    if ((await http.delete(
        '$baseUrl/${_dbTable.table.beforeLast}/${old.idProperty}'.uri
    )).statusCode == 200) {
      if (mounted) {
        _reloadItemsList();
        _navigator.pop();
        showSnackBar(context, operationSucceeded);
      }
    } else if (mounted) showSnackBar(context, operationFailed);
  }

  List<Expanded> _makeItemContent(PlaceableInDbTable placeable) {
    final list = <Expanded>[],
      weightedColumn = _dbTable.weightedColumns.entries.iterator,
      nullables = _dbTable.nullablesMask.iterator;
    for (final value in placeable.values) {
      if (!weightedColumn.moveNext() || !nullables.moveNext()) throw Exception();
      list.add(Expanded(
        flex: (weightedColumn.current.value * 100).floor(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.white70,
                fontStyle: nullables.current ? FontStyle.italic : FontStyle.normal
              ),
            ),
            Text(
              weightedColumn.current.key,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.white38,
                fontSize: 12
              )
            )
          ]
        )
      ));
    }
    return list;
  }

  Widget _makeItem(int index) => Material(child: ListTile(
    onTap: () => _showItemDetails(
      _items[index],
      null,
      null
    ),
    title: Row(
      mainAxisSize: MainAxisSize.max,
      children: _makeItemContent(_items[index])
    )
  ));

  @override
  Widget build(BuildContext context)
  => !_authorized ? const ErrorPage(error: forbidden) : Scaffold(
    appBar: BasicAppBar(trailings: [TextButton(
      onPressed: _navigator.pop,
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
