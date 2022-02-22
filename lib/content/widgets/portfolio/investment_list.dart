import 'dart:io';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/error_view.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/no_item_holder.dart';
import 'package:asset_flutter/content/providers/asset.dart';
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
  ListState _state = ListState.init;
  late final AssetsProvider _assetsProvider;
  String? _error;

  void _getAssets() {
    setState(() {
      _state = ListState.loading;
    });

    _assetsProvider.getAssets().then((response){
      _error = response.error;
      if (_state != ListState.disposed) {
        setState(() {
          _state = (response.code != null || response.error != null)
            ? ListState.error
            : (
              response.data.isEmpty
                ? ListState.empty
                : ListState.done
            );
        });
      }
    });
  }

  @override
  void dispose() {
    _state = ListState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == ListState.init) {
      _assetsProvider = Provider.of<AssetsProvider>(context);
      _getAssets();
    }
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
            NoItemView("Couldn't find investment.")
          ],
        );
      case ListState.done:
        return Column(
          children: [
            const SectionTitle("Investments", ""),
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
        return ErrorView(_error ?? "Unknown error!", _getAssets);
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
            NoItemView("Couldn't find investment."),
            AddInvestmentButton()
          ],
        );
      case ListState.done:
        return Container(
          color: Colors.white,
          child: InkWell(
            onTap: (() {
              //TODO: Implement
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
