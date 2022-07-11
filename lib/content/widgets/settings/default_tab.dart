import 'dart:io';

import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/static/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultTabListSettings extends StatefulWidget {
  const DefaultTabListSettings({Key? key}) : super(key: key);

  @override
  State<DefaultTabListSettings> createState() => _DefaultTabListSettingsState();
}

class _DefaultTabListSettingsState extends State<DefaultTabListSettings> {
  late int defaultIndex;
  bool isInit = false;

  final _tabList = ["Portfolio", "Subscriptions", "Wallet"];
  final _tabIconList = [Icons.attach_money_rounded, Icons.subscriptions_rounded, Icons.account_balance_wallet_rounded];

  @override
  void didChangeDependencies() {
    if (!isInit) {
      defaultIndex = SharedPref().getDefaultTab();
      isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) => ListTile(
              leading: Icon(
                _tabIconList[index],
                color: index == defaultIndex 
                  ? Theme.of(context).colorScheme.bgTextColor 
                  : Theme.of(context).colorScheme.bgTransparentColor 
              ),
              onTap: () {
                setState(() {
                  defaultIndex = index;
                });
              },
              title: Text(
                _tabList[index],
                style: TextStyle(
                  color: index == defaultIndex 
                  ? Theme.of(context).colorScheme.bgTextColor 
                  : Theme.of(context).colorScheme.bgTransparentColor 
                ),
              ),
              trailing: index == defaultIndex
              ? Icon(
                  Icons.check_rounded,
                  color: Theme.of(context).colorScheme.bgTextColor
                ) 
              : null,
            ),
            separatorBuilder: (_, __) => const Divider(),
            itemCount: 3
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Platform.isIOS || Platform.isMacOS
            ? CupertinoButton(
              child: const Text('Cancel'), 
              onPressed: () => Navigator.pop(context)
            )
            : Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: TextButton(
                  onPressed: () => Navigator.pop(context), 
                  child: const Text('Cancel')
                ),
              ),
            ),
            Platform.isIOS || Platform.isMacOS
            ? CupertinoButton.filled(
              child: const Text('Apply', style: TextStyle(color: Colors.white)), 
              onPressed: () {
                SharedPref().setDefaultTab(defaultIndex);
                Navigator.pop(context);
              }
            )
            : Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ElevatedButton(
                  onPressed: () {
                    SharedPref().setDefaultTab(defaultIndex);
                    Navigator.pop(context);
                  }, 
                  child: const Text('Apply', style: TextStyle(color: Colors.white))
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}