
// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';

import 'errorPage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../interop/component.dart';
import '../consts.dart';
import '../widgets/basicAppBar.dart';
import '../widgets/basicBottomBar.dart';
import '../widgets/basicWindow.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../util.dart';

class SelectPage extends StatefulWidget {
  const SelectPage({super.key});

  @override
  State<StatefulWidget> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  late final Type _type;
  final List<Component> _items = [];
  var _isFetching = false;
  var _hasFetched = false;
  var _hasSearched = false;
  var _isLeaving = false;
  late final TextEditingController _searchController;

  NavigatorState get _navigator => Navigator.of(context);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final dynamic args = getArgs(context);
    if (args == null || args is! Type) {
      _type = Type.cpu;
      _isLeaving = true;
    } else
      _type = args;
    if (!_isLeaving) _loadItems(true);
  }

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController()..addListener(_search);
  }

  @override
  void dispose() {
    _searchController.removeListener(_search);
    super.dispose();
  }

  Widget _makeItem(Component component, BuildContext context) => Card(
    child: Material(child: ListTile(
      onTap: () => _onItemClick(component),
      leading: component.image == null
        ? SvgPicture.asset(
          'pc_icon.svg',
          width: 50,
          height: 50
        )
        : Image.network(
          imageUrl + component.image! + jpgExtension,
          width: 50,
          height: 50
      ),
      title: Text(
        component.title,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text('\$${component.cost}'),
    )),
  );

  Future<List<Component>> _fetch() async {
    final response = await http.get(Uri.parse('$baseUrl/component/type/${_type.type}'));
    if (response.statusCode == 200)
      return [for (final dynamic i in jsonDecode(response.body)) Component.fromJson(i)];
    else
      return [];
  }

  Future<void> _loadItems(bool firstTime) async {
    setState(() => _isFetching = true);

    final items = await _fetch();
    if (items.isNotEmpty) setState(() => _items.addAll(items));

    setState(() {
      _isFetching = false;
      _hasFetched = true;
    });
  }

  void _resetItemsList() => setState(() {
    _items.clear();
    _hasFetched = false;
  });

  Future<List<Component>> _doSearch(String query) async {
    final results = <Component>[];
    for (final i in await _fetch())
      if (i.title.containsIgnoreCase(query)) results.add(i);
    return results;
  }

  Future<void> _search() async {
    final query = _searchController.text;
    if (query.isEmpty) {
      if (_hasSearched) _refresh();
      return;
    }

    setState(() => _isFetching = true);
    _resetItemsList();

    _items.addAll(await _doSearch(query));
    setState(() {
      _isFetching = false;
      _hasFetched = true;
      _hasSearched = true;
    });
  }

  Future<void> _refresh() async {
    _resetItemsList();
    setState(() => _hasSearched = false);
    await _loadItems(true);
  }

  // TODO: border-radius
  void _onItemClick(Component component) => showModalBottomSheet(
    constraints: const BoxConstraints(maxWidth: 600),
    context: context,
    builder: (builder) => Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        boxShadow: [BoxShadow(
          color: darkSecondaryColor,
          spreadRadius: 1,
          offset: Offset(0, 0)
        )]
      ),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 5,
                top: 5,
                right: 5
              ),
              child: Text(
                component.title,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            TextButton(
              onPressed: () => _submit(component),
              child: const Text(
                submit,
                style: TextStyle(fontSize: 18),
              )
            )
          ]
        ),
        const Divider(
          thickness: 1,
          height: 1,
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
      ]),
    )
  );

  Future<void> _submit(Component component) async {
    // await http.post(Uri.parse('$selectComponentUrl/${component.id!}'));
    if (mounted) _navigator..pop()..pop(component);
  }

  @override
  Widget build(BuildContext context)
  => _isLeaving ? const ErrorPage(error: noParametersProvidedError) : Scaffold(
    appBar: BasicAppBar(trailings: [TextButton(
      onPressed: _navigator.pop,
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
            child: makeTextField(
              controller: _searchController,
              hint: searchByTitle
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
          itemCount: _items.length
        ),
      footerWidgets: defaultFooter,
      showLoading: _isFetching,
    ),
    bottomNavigationBar: const BasicBottomBar(),
  );
}
