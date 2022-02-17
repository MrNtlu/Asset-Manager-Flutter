import 'dart:io';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/error_dialog.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/no_item_holder.dart';
import 'package:asset_flutter/content/models/responses/asset.dart';
import 'package:asset_flutter/content/providers/assets.dart';
import 'package:asset_flutter/content/widgets/portfolio/add_investment_button.dart';
import 'package:asset_flutter/content/widgets/portfolio/il_cell.dart';
import 'package:asset_flutter/content/widgets/portfolio/section_title.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PortfolioInvestment extends StatefulWidget {
  @override
  State<PortfolioInvestment> createState() => _PortfolioInvestmentState();
}

class _PortfolioInvestmentState extends State<PortfolioInvestment> {
  bool _isInit = false;
  ListState _state = ListState.init;
  late final AssetsProvider _assetsProvider;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _assetsProvider = Provider.of<AssetsProvider>(context);
      setState(() {
        _state = ListState.loading;
      });
      _assetsProvider.getAssets().then((response){
        if (response.code != null || response.error != null) {
          showDialog(
            context: context, 
            builder: (ctx) => ErrorDialog(response.error ?? response.message ?? "Unknown error")
          );
        }
        setState(() {
          _state = (response.code != null || response.error != null)
            ? _state = ListState.error
            : (
              response.data.isEmpty
                ? _state = ListState.empty
                : _state = ListState.done
            );
        });
      });
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var _data = _assetsProvider.items;

    return MediaQuery.of(context).orientation == Orientation.portrait  || Platform.isMacOS || Platform.isWindows 
    ? Container(
        color: Colors.white,
        child: _portraitBody(_data),
      )
    : _landscapeBody();
  }

  Widget _portraitBody(List<Asset> _data){
    switch (_state) {
      case ListState.loading:
        return const LoadingView("Fetching investments");
      case ListState.empty:
        return Column(
          children: const[
            SectionTitle("Investments", ""),
            NoItemHolder("Couldn't find investment.")
          ],
        );
      case ListState.done:
        return Column(
          children: [
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
            ),
          ],
        );
      case ListState.error:
      //TODO Error implement
      default:
        return const LoadingView("Fetching investments");
    }
  }

  Widget _landscapeBody() {
    switch (_state) {
      case ListState.loading:
        return const LoadingView("Fetching investments");
      case ListState.empty:
        return Column(
          children: const[
            NoItemHolder("Couldn't find investment."),
            AddInvestmentButton()
          ],
        );
      case ListState.done:
        return Container(
          color: Colors.white,
          child: InkWell(
            onTap: (() {
              print("Investment Details Pressed");
            }),
            child: Column(
              children: const [
                SectionTitle("Investments", "See All>"),
                AddInvestmentButton()
              ],
            )
          ),
        );
      default:
        return const LoadingView("Fetching investments");
    }
  }
}
