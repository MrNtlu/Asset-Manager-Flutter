import 'dart:io';
import 'package:asset_flutter/content/providers/asset.dart';
import 'package:asset_flutter/content/providers/assets.dart';
import 'package:asset_flutter/content/widgets/portfolio/il_cell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PortfolioInvestmentList extends StatelessWidget {
  const PortfolioInvestmentList();

  @override
  Widget build(BuildContext context) {
    var _data = Provider.of<AssetsProvider>(context).items;
    var _isPortrait = MediaQuery.of(context).orientation == Orientation.portrait  || Platform.isMacOS || Platform.isWindows;

    return _isPortrait
      ? _portraitListView(_data)
      : _landscapeListView(_data);
  }

  Widget _portraitListView(List<Asset> _data) => Expanded(
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
  );

  Widget _landscapeListView(List<Asset> _data) => SizedBox(
    height: _data.length < 6 ? _data.length * 75 : 450,
    child: ListView.builder(
      itemBuilder: ((context, index) {
        final data = _data[index];
        return PortfolioInvestmentListCell(data);
      }),
      itemExtent: 75,
      itemCount: _data.length,
      padding: const EdgeInsets.only(top: 4),
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
    ),
  );
}
