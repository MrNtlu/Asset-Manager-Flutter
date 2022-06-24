import 'dart:convert';
import 'dart:io';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/no_item_holder.dart';
import 'package:asset_flutter/content/providers/subscription/subscription_image_selection.dart';
import 'package:asset_flutter/content/widgets/subscription/subscription_image.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SubscriptionCreateImageSheet extends StatefulWidget {
  const SubscriptionCreateImageSheet({Key? key}) : super(key: key);

  @override
  State<SubscriptionCreateImageSheet> createState() => _SubscriptionCreateImageSheetState();
}

class _SubscriptionCreateImageSheetState extends State<SubscriptionCreateImageSheet> {
  BaseState _state = BaseState.init;
  final List<String> _itemList = [];
  String _search = '';
  
  @override
  void dispose() {
    _state = BaseState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    searchSubscription('');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case BaseState.init:
        final _searchTextController = TextEditingController(text: _search);
        return SafeArea(
          child: Container(
            decoration: Platform.isIOS || Platform.isMacOS
            ? const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16)
              ),
            )
            : null,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 4, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _searchTextController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search_rounded),
                            hintText: "Search Subscription Service",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors().bgSecondary)
                            ),
                          ),
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          onFieldSubmitted: searchSubscription,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Platform.isIOS || Platform.isMacOS
                          ? CupertinoButton(
                            child: const Text('Search', style: TextStyle(color: CupertinoColors.activeBlue, fontSize: 14)),
                            onPressed: () => searchSubscription(_searchTextController.text),
                          )
                          : TextButton(
                            child: const Text('Search', style: TextStyle(color: CupertinoColors.activeBlue, fontSize: 14)),
                            onPressed: () => searchSubscription(_searchTextController.text),
                          ),
                      )
                    ],
                  ),
                ),
                if (_itemList.isNotEmpty)
                ListView.separated(
                  separatorBuilder: (_, __) => const Divider(thickness: 0.75),
                  itemBuilder: ((_, index) {
                    return ListTile(
                      onTap: () {
                        Provider.of<SubscriptionImageSelection>(context, listen: false).imageSelected(_itemList[index]);
                        Navigator.pop(context);
                      },
                      title: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: SubscriptionImage(_itemList[index], Colors.black),
                          ),
                          Text(
                            _itemList[index],
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  itemCount: _itemList.length,
                  shrinkWrap: true,
                )
                else
                const Expanded(
                  child: Center(
                    child: NoItemView("Nothing to see here."),
                  ),
                )
              ],
            ),
          ),
        );
      default:
        return const LoadingView("Loading");
    }
  }

  void searchSubscription(String search) async {
    _search = search;
    setState(() {
      _state = BaseState.loading;
    });
    if (search.trim() == '') {
      search = "netflix";
    }
    _itemList.clear();

    var response = await http.get(
      Uri.parse("https://autocomplete.clearbit.com/v1/companies/suggest?query=$search"),
    );
    (json.decode(response.body) as List).map((e) => e as Map<String, dynamic>).forEach((element) {
        _itemList.add(element["domain"] as String);
    });

    setState(() {
      _state = BaseState.init;
    });
  }
}