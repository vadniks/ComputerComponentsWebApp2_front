
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
  final List<Component> _items = [];
  var _isFetching = false;
  var _hasFetched = false;
  var _fetchFrom = 0;

  late final TextEditingController _searchController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final dynamic args = ModalRoute.of(context)?.settings.arguments;
    if (args == null || args is! Type) throw ArgumentError(null);
    _type = args;
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(() => _loadItems(false));
    _searchController = TextEditingController()..addListener(_search);
    _loadItems(true);
  }

  @override
  void dispose() {
    _controller.removeListener(() => _loadItems(false));
    _searchController.removeListener(_search);
    super.dispose();
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

  @Deprecated('test only')
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

  void _resetItemsList() => setState(() {
    _isFetching = true;
    _items.clear();
    _fetchFrom = 0;
    _isFetching = false;
    _hasFetched = false;
  });

  @Deprecated('test only')
  Future<List<Component>> _testSearch(String query) async {
    Future.delayed(const Duration(seconds: 3));
    return [
      Component(title: 'a+$query', type: _type, description: 'a', cost: 1),
      Component(title: 'b+$query', type: _type, description: 'b', cost: 2),
      Component(title: 'c+$query', type: _type, description: 'c', cost: 3)
    ];
  }

  Future<void> _search() async {
    _resetItemsList();
    setState(() => _isFetching = true);

    _items.addAll(await _testSearch(_searchController.text));
    setState(() {
      _isFetching = false;
      _hasFetched = true;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: BasicAppBar(buttons: [TextButton(
      onPressed: () => Navigator.of(context).pushNamed(routeHome),
      child: const Text(home)
    )]),
    body: BasicWindow(
      titleWidgets: [
        Text(
          '$componentsSelection ${_type.title}',
          style: const TextStyle(fontSize: 20)
        ),
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
      content: _hasFetched && _items.isEmpty
        ? const Center(child: Text(
          empty,
          style: TextStyle(fontSize: 18),
        ))
        : ListView.separated(
          itemBuilder: (_, index) => _makeItem(_items[index], context),
          separatorBuilder: (_, index) => const Divider(),
          itemCount: _items.length
        ),
      footerWidgets: const [],
      showLoading: _isFetching,
    ),
    bottomNavigationBar: const BasicBottomBar(),
  );
}
