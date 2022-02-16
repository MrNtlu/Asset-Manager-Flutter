import 'dart:io';

import 'package:asset_flutter/auth/pages/login_page.dart';
import 'package:asset_flutter/auth/pages/register_page.dart';
import 'package:asset_flutter/content/providers/asset_logs.dart';
import 'package:asset_flutter/content/providers/asset_stats.dart';
import 'package:asset_flutter/content/providers/assets.dart';
import 'package:asset_flutter/content/providers/subscriptions.dart';
import 'package:flutter/material.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:provider/provider.dart';

void main() {
  setWindowForPC();
  runApp(const MyApp());
}

Future setWindowForPC() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isMacOS) {
    const minSize = Size(525, 850);
    DesktopWindow.setMinWindowSize(minSize);
    DesktopWindow.setWindowSize(minSize);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments as Map<String, String>?;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: SubscriptionsProvider()
        ),
        ChangeNotifierProvider.value(
          value: AssetLogProvider()
        ),
        ChangeNotifierProvider.value(
          value: AssetStatsProvider()
        ),
        ChangeNotifierProvider.value(
          value: AssetsProvider()
        )
      ],
      child: MaterialApp(
        title: 'Wealth Manager',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
        ),
        home: LoginPage(),
        routes: {
          LoginPage.routeName: (ctx) => LoginPage(),
          RegisterPage.routeName: (ctx) => RegisterPage(),
        },
      ),
    );
  }
}
