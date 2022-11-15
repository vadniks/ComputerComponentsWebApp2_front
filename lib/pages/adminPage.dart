
import 'package:flutter/material.dart';
import '../consts.dart';
import '../interop/DatabaseTable.dart';
import '../widgets/basicAppBar.dart';
import '../widgets/basicBottomBar.dart';
import '../widgets/basicWindow.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<StatefulWidget> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  var _dbTable = DatabaseTable.components;

  NavigatorState get _navigator => Navigator.of(context);

  void _changeTable() {

  }

  void _select() {

  }

  void _insert() {

  }

  Row _makeTopItem() {

  }

  List<Row> _makeItems() {

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
        _makeTopItem(),
        ..._makeItems()
      ]),
      footerWidgets: defaultFooter
    ),
    bottomNavigationBar: const BasicBottomBar(),
  );
}
