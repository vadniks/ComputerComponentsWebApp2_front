
import 'dart:convert';
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
  late final Type _type;
  late final ScrollController _controller;
  late final List<Component> _items;
  var _isFetching = false;
  var _hasFetched = false;
  var _fetchFrom = 0;

  late final TextEditingController _searchController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final dynamic args = ModalRoute.of(context)?.settings.arguments;
    if (args == null || args is! int) throw ArgumentError(null);
    _type = Type.create(args)!;
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(() {});
    _searchController = TextEditingController()..addListener(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(() {});
    _searchController.removeListener(() {});
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

  Future<List<Component>> testFetch([int initial = 0]) async { // TODO: test only
    await Future.delayed(const Duration(seconds: 3));
    final list = <Component>[];
    for (int i = initial, j = 'a'.codeUnitAt(0); j < 'z'.codeUnitAt(0); i++, j++) {
      final char = String.fromCharCode(j);
      list.add(Component(title: char, type: _type, description: char * 2, cost: i));
    }
    return list;
  }

  Future<void> _loadItems(bool firstTime) async {
    if (!firstTime && _controller.position.extentAfter >= 30 ||
        _isFetching) return;
    setState(() => _isFetching = true);

    final items = await testFetch(_fetchFrom); // TODO: test only
    if (items.isNotEmpty) setState(() => _items.addAll(items));

    setState(() {
      _isFetching = false;
      _fetchFrom += fetchAmount;
      _hasFetched = true;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: BasicAppBar(buttons: [TextButton(
      onPressed: () {},
      child: const Text(home)
    )]),
    body: BasicWindow(
      titleWidgets: [
        Text('$componentsSelection ${_type.title}'),
        SizedBox(child: TextFormField(
          keyboardType: TextInputType.text,
          maxLines: 1,
          cursorColor: Colors.white70,
          controller: _searchController,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 18
          ),
          decoration: const InputDecoration(
            hintText: searchByTitle,
            hintStyle: TextStyle(color: Colors.white38)
          ),
        ))
      ],
      content: RefreshIndicator(
        backgroundColor: darkSecondaryColor,
        onRefresh: () async {},
        child: ListView.separated(
          itemBuilder: (_, index) => _makeItem(_items[index], context),
          separatorBuilder: (_, index) => const Divider(),
          itemCount: _items.length
        ),
      ),
      footerWidgets: const [],
      showLoading: _isFetching,
    ),
    bottomNavigationBar: const BasicBottomBar(),
  );
}
