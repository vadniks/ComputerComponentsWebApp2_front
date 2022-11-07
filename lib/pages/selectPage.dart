
import 'dart:convert';
import 'dart:typed_data';

import '../component.dart';
import '../consts.dart';
import '../widgets/basicAppBar.dart';
import '../widgets/basicBottomBar.dart';
import '../widgets/basicWindow.dart';
import 'package:flutter/material.dart';

class SelectPage extends StatefulWidget {
  const SelectPage({super.key});

  @override
  State<StatefulWidget> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  late final int _which;
  late final ScrollController _controller;
  late final List<Component> _items;
  bool _isFetching = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final dynamic args = ModalRoute.of(context)?.settings.arguments;
    if (args == null || args is! int) throw ArgumentError(null);
    _which = args;
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(() {});
  }

  Image _decodeImage(String base64) =>
    Image.memory(const Base64Decoder().convert(base64));

  Widget _makeItem(Component component, BuildContext context) => Card(
    margin: const EdgeInsets.all(5),
    child: Material(child: ListTile(
      onTap: () {},
      leading: component.image != null ? _decodeImage(component.image!) : null,
      title: Text(component.title),
      trailing: Text(component.cost.toString()),
    )),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: BasicAppBar(buttons: const [

    ]),
    body: BasicWindow(
      titleWidgets: const [],
      content: RefreshIndicator(
        backgroundColor: darkSecondaryColor,
        onRefresh: () async {},
        child: ListView.separated(
          itemBuilder: (_, index) => _makeItem(_items[index], context),
          separatorBuilder: (_, index) => const Divider(),
          itemCount: _items.length
        ),
      ),
      footerWidgets: const []
    ),
    bottomNavigationBar: const BasicBottomBar(),
  );
}
