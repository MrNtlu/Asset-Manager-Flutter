import 'dart:io';
import 'package:asset_flutter/content/providers/subscription/subscription.dart';
import 'package:asset_flutter/content/providers/subscription/subscriptions.dart';
import 'package:asset_flutter/content/widgets/subscription/sl_cell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubscriptionList extends StatelessWidget{
  const SubscriptionList();

  @override
  Widget build(BuildContext context) {
    final _data = Provider.of<SubscriptionsProvider>(context).items;
    var _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait  || Platform.isMacOS || Platform.isWindows;

    return _isPortrait
      ? _portraitListView(_data)
      : _landscapeListView(_data);
  }

  Widget _portraitListView(List<Subscription> _data) => Expanded(
    child: ListView.builder(itemBuilder: ((context, index) {
      if(index == _data.length) {
        return const SizedBox(height: 75);
      }
      final data = _data[index];
      return ChangeNotifierProvider.value(
        value: data,
        child: SubscriptionListCell()
      );
    }),
    itemCount: _data.length + 1,
    physics: const ClampingScrollPhysics(),
    shrinkWrap: true,
    ),
  );

  Widget _landscapeListView(List<Subscription> _data) => SizedBox(
    height: _data.length < 6 ? _data.length * 110 : 650,
    child: ListView.builder(itemBuilder: ((context, index) {
      final data = _data[index];
      return ChangeNotifierProvider.value(
        value: data,
        child: SubscriptionListCell()
      );
    }),
    itemCount: _data.length,
    physics: const ClampingScrollPhysics(),
    shrinkWrap: true,
    ),
  );
}