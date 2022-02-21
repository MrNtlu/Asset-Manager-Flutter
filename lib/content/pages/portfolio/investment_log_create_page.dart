import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:asset_flutter/content/models/requests/asset.dart';
import 'package:asset_flutter/content/providers/asset_logs.dart';
import 'package:provider/provider.dart';

class InvestmentLogCreatePage extends StatefulWidget {
  InvestmentLogCreatePage({Key? key}) : super(key: key);

  @override
  State<InvestmentLogCreatePage> createState() => _InvestmentLogCreatePageState();
}

class _InvestmentLogCreatePageState extends State<InvestmentLogCreatePage> {

  void _createInvestmentLog(BuildContext context) {
    // Provider.of<AssetLogProvider>(context, listen: false).addAssetLog(
    //   AssetCreate(_data.toAsset, _data.fromAsset, "buy", 0.1, _data.type, _data.name, boughtPrice: 44105.21)
    // );
  }

  @override
  void dispose() {
    
    super.dispose();
  }

  @override
  void didChangeDependencies() {

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Create"),
          backgroundColor: AppColors().primaryLightishColor,
          actions: [
            IconButton(
              icon: const Icon(Icons.save_rounded),
              tooltip: 'Save Investment Log',
              onPressed: () => _createInvestmentLog(context),
            )
          ],
        ),
        body: Container(),
    );
  }
}