
// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';
import 'errorPage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../component.dart';
import '../consts.dart';
import '../widgets/basicAppBar.dart';
import '../widgets/basicBottomBar.dart';
import '../widgets/basicWindow.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  var _isLeaving = false;
  late final TextEditingController _searchController;

  NavigatorState get _navigator => Navigator.of(context);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final dynamic args = ModalRoute.of(context)!.settings.arguments;
    if (args == null || args is! Type) {
      _type = Type.cpu;
      _isLeaving = true;
    } else
      _type = args;
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(() => _loadItems(false));
    _searchController = TextEditingController()..addListener(_search);
    if (!_isLeaving) _loadItems(true);
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
      onTap: () => _onItemClick(component),
      leading: SvgPicture.asset('pc_icon.svg', width: 50, height: 50),//component.image != null ? _decodeImage(component.image!) : null,
      title: Text(
        component.title,
        overflow: TextOverflow.ellipsis,
      ),
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

  // TODO: border-radius
  void _onItemClick(Component component) => showModalBottomSheet(
    context: context,
    builder: (builder) => Column(children: [
      ColoredBox(
        color: darkSecondaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                component.title,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            TextButton(
              onPressed: () => _submit(component),
              child: const Text(submit)
            )
          ]
        ),
      ),
      Expanded(child: Row(children: [
        SvgPicture.asset( // TODO: test
          'pc_icon.svg',
          width: 200,
          height: 200
        ),
        const VerticalDivider(thickness: 1),
        Expanded(child: Column(children: [
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              text: component.description,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white70
              )
            ),
          )
        ]))
      ]))
    ])
  );

  Future<void> _submit(Component component) async {
    // await http.post(Uri.parse('$selectComponentUrl/${component.id!}'));
    if (mounted) _navigator..pop()..pop(component);
  }

  @override
  Widget build(BuildContext context)
  => _isLeaving ? const ErrorPage(error: noParametersProvidedError) : Scaffold(
    appBar: BasicAppBar(buttons: [TextButton(
      onPressed: () => _navigator.pushNamed(routeHome),
      child: const Text(home)
    )]),
    body: BasicWindow(
      titleWidgets: [
        RichText(text: TextSpan(
          text: '$componentsSelection ',
          style: const TextStyle(color: Colors.white),
          children: [TextSpan(
            text: _type.title,
            style: const TextStyle(fontWeight: FontWeight.bold)
          )]
        )),
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
                fontSize: 14
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
      footerWidgets: const [SizedBox(height: 25)],
      showLoading: _isFetching,
    ),
    bottomNavigationBar: const BasicBottomBar(),
  );
}
