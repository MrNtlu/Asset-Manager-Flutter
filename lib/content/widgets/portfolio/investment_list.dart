import 'dart:io';

import 'package:asset_flutter/common/widgets/add_elevated_button.dart';
import 'package:asset_flutter/common/widgets/error_dialog.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/no_item_holder.dart';
import 'package:asset_flutter/content/providers/assets.dart';
import 'package:asset_flutter/content/widgets/portfolio/il_cell.dart';
import 'package:asset_flutter/content/widgets/portfolio/section_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PortfolioInvestment extends StatefulWidget {
  late final AssetsProvider _assetsProvider;

  @override
  State<PortfolioInvestment> createState() => _PortfolioInvestmentState();
}

class _PortfolioInvestmentState extends State<PortfolioInvestment> {
  bool _isLoading = false;
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      widget._assetsProvider = Provider.of<AssetsProvider>(context);
      setState(() {
        _isLoading = true;
      });
      widget._assetsProvider.getAssets().then((response){
        if (response.code != null || response.error != null) {
          showDialog(
            context: context, 
            builder: (ctx) => ErrorDialog(response.error ?? response.message ?? "Unknown error")
          );
        }
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var _data = widget._assetsProvider.items;

    return MediaQuery.of(context).orientation == Orientation.portrait  || Platform.isMacOS || Platform.isWindows ? 
    Container(
      color: Colors.white,
      child: _isLoading 
      ? const LoadingView("Fetching investments...")
      : Column(
        children: [
          const SectionTitle("Investments", ""),
          if (_data.isNotEmpty) 
          Expanded(
            child: ListView.builder(
              itemBuilder: ((context, index) {
                if(index == _data.length) {
                  return const SizedBox();
                }
                final data = _data[index];
                return PortfolioInvestmentListCell(data);
              }),
              itemExtent: 75,
              itemCount: _data.length + 1,
              padding: const EdgeInsets.only(top: 4),
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
            ),
          )
          else const NoItemHolder("Couldn't find investment."),
        ],
      ),
    )
  :
  _data.isNotEmpty ?
  Container(
    color: Colors.white,
    child: InkWell(
      onTap: (() {
        print("Investment Details Pressed");
      }),
      child: Column(
        children: [
          const SectionTitle("Investments", "See All>"),
          AddElevatedButton("Add Investment", (){

          })
        ],
      )),
    )
    :
    const NoItemHolder("Couldn't find investment.");
  }
}
