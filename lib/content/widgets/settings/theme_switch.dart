import 'package:asset_flutter/content/providers/settings/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsThemeSwitch extends StatelessWidget {

  const SettingsThemeSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return SettingsTile.switchTile(
      onToggle: (value) => themeProvider.toggleTheme(value),
      initialValue: themeProvider.isDarkMode,
      leading: const Icon(Icons.format_paint),
      title: const Text('Enable Dark Theme'),
    );
  }
}