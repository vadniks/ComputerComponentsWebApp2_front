
// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
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
  late final ScrollController _scrollController;
  final List<Component> _items = [];
  var _isFetching = false;
  var _hasFetched = false;
  var _fetchFrom = 0;
  var _hasSearched = false;
  var _isSearching = false;

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
    _scrollController = ScrollController()..addListener(() => _loadItems(false));
    _searchController = TextEditingController()..addListener(_search);
    _loadItems(true);
  }

  @override
  void dispose() {
    _scrollController.removeListener(() => _loadItems(false));
    _searchController.removeListener(_search);
    super.dispose();
  }

  Image _decodeImage(String base64) =>
    Image.memory(const Base64Decoder().convert(base64));

  Widget _makeItem(Component component, BuildContext context) => Card(
    child: Material(child: ListTile(
      onTap: () {},
      leading: SvgPicture.asset('pc_icon.svg', width: 50, height: 50),//component.image != null ? _decodeImage(component.image!) : null,
      title: Text(component.title),
      trailing: Text('\$${component.cost}'),
    )),
  );

  @Deprecated('test only')
  Future<List<Component>> testFetch(int from, int to) async { // TODO: test only
    await Future.delayed(const Duration(seconds: 2));
    final list = <Component>[];
    for (int i = from, j = 'a'.codeUnitAt(0); i < to; i++, j++) {
      final char = String.fromCharCode(j);
      list.add(Component(title: char, type: _type, description: char * 2, cost: i));
    }
    return list;
  }

  Future<void> _loadItems(bool firstTime) async {
    if (!firstTime && _scrollController.position.extentAfter >= 10 || _isFetching || _isSearching) return;
    setState(() => _isFetching = true);

    final items = await testFetch(_fetchFrom, _fetchFrom + fetchAmount); // TODO: test only
    if (items.isNotEmpty) setState(() => _items.addAll(items));

    setState(() {
      _isFetching = false;
      _fetchFrom += fetchAmount;
      _hasFetched = true;
    });
  }

  void _resetItemsList() => setState(() {
    _items.clear();
    _fetchFrom = 0;
    _hasFetched = false;
  });

  @Deprecated('test only')
  Future<List<Component>> _testSearch(String query) async {
    await Future.delayed(const Duration(seconds: 2));
    return [
      Component(title: 'a+$query', type: _type, description: 'a', cost: 1),
      Component(title: 'b+$query', type: _type, description: 'b', cost: 2),
      Component(title: 'c+$query', type: _type, description: 'c', cost: 3),
      Component(title: 'd+$query', type: _type, description: 'c', cost: 4),
      Component(title: 'e+$query', type: _type, description: 'c', cost: 5),
      Component(title: 'f+$query', type: _type, description: 'c', cost: 6),
      Component(title: 'g+$query', type: _type, description: 'c', cost: 7),
      Component(title: 'h+$query', type: _type, description: 'c', cost: 8)
    ];
  }

  Future<void> _search() async {
    final query = _searchController.text;
    if (query.isEmpty) {
      if (_hasSearched) _refresh();
      return;
    }

    setState(() {
      _isFetching = true;
      _isSearching = true;
    });
    _resetItemsList();

    _items.addAll(await _testSearch(query));
    setState(() {
      _isFetching = false;
      _hasFetched = true;
      _hasSearched = true;
    });
  }

  Future<void> _refresh() async {
    _resetItemsList();
    setState(() {
      _hasSearched = false;
      _isSearching = false;
    });
    await _loadItems(true);
  }

  void _onItemClick(int id) => showModalBottomSheet(
    context: context,
    builder: (builder) => Column(children: [

    ])
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: BasicAppBar(buttons: [TextButton(
      onPressed: () => Navigator.of(context).pushNamed(routeHome),
      child: const Text(home)
    )]),
    body: BasicWindow(
      titleWidgets: [
        Text('$componentsSelection ${_type.title}'),
        Padding(
          padding: const EdgeInsets.all(5),
          child: SizedBox(
            width: 200,
            child: TextFormField(
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
            )
          ),
        )
      ],
      content: _hasFetched && _items.isEmpty
        ? const Center(child: Text(
          empty,
          style: TextStyle(fontSize: 18),
        ))
        : ListView.separated(
          itemBuilder: (_, index) => _makeItem(_items[index], context),
          separatorBuilder: (_, index) => const Divider(height: 2),
          itemCount: _items.length,
          controller: _scrollController,
        ),
      footerWidgets: const [],
      showLoading: _isFetching,
    ),
    bottomNavigationBar: const BasicBottomBar(),
  );
}
