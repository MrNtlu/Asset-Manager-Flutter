import 'package:asset_flutter/static/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class HideWatchlistSwitch extends StatefulWidget {
  const HideWatchlistSwitch({Key? key}) : super(key: key);

  @override
  State<HideWatchlistSwitch> createState() => _HideWatchlistSwitchState();
}

class _HideWatchlistSwitchState extends State<HideWatchlistSwitch> {
  @override
  Widget build(BuildContext context) {
    return SettingsTile.switchTile(
      onToggle: (value) => setState(() {
        SharedPref().setIsWatchlistHidden(value); 
      }),
      initialValue: SharedPref().getIsWatchlistHidden(),
      leading: Icon(
        SharedPref().getIsWatchlistHidden()
        ? Icons.visibility_off_rounded
        : Icons.visibility_rounded
      ),
      title: const Text('Hide Watchlist'),
    );
  }
}