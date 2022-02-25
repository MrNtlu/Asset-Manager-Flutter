import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PolicyPage extends StatelessWidget {
  final bool _isPrivacyPolicy;
  const PolicyPage(this._isPrivacyPolicy, {Key? key}) : super(key: key);

  Future<String> loadAsset(BuildContext context) async {
    var file = _isPrivacyPolicy ? "privacy_policy" : "terms_conditions";
    return await DefaultAssetBundle.of(context)
        .loadString("assets/policies/$file.md");
  }

  @override
  Widget build(BuildContext context) {
    loadAsset(context).then((value) => null);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: AppColors().primaryColor,
      ),
      body: FutureBuilder(
        future: loadAsset(context),
        builder: (_, mdSnapshot) {
          if (mdSnapshot.connectionState == ConnectionState.done) {
            return Markdown(data: mdSnapshot.data as String);
          } else {
            return Center(
              child: const CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
