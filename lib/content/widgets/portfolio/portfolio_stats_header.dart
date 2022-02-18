import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/sub_error_view.dart';
import 'package:asset_flutter/content/providers/asset_stats.dart';
import 'package:asset_flutter/content/widgets/portfolio/portfolio.dart';
import 'package:asset_flutter/content/widgets/portfolio/stats.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PortfolioStatsHeader extends StatefulWidget {
  const PortfolioStatsHeader({Key? key}) : super(key: key);

  @override
  State<PortfolioStatsHeader> createState() => _PortfolioStatsHeaderState();
}

class _PortfolioStatsHeaderState extends State<PortfolioStatsHeader> {
  bool _isInit = false;
  bool _isDisposed = false;
  ViewState _state = ViewState.init;
  String? _error;

  void _getAssetStats() {
    setState(() {
      _state = ViewState.loading;
    });

    Provider.of<AssetStatsProvider>(context, listen: false).getAssetStats().then((response){
      _error = response.message;
      if (!_isDisposed) {
        setState(() {
          if (response.data == null) {
            _state = ViewState.error;
          } else {
            _state = (response.data!.currency != '') 
              ? ViewState.done 
              : ViewState.empty;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _getAssetStats();
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //TODO: If data null show something else
    switch (_state) {
      case ViewState.loading:
        return const LoadingView("Loading");
      case ViewState.empty:
      case ViewState.done:
        return Column(
          children: const [
            Portfolio(),
            PortfolioStats(false),
          ],
        );
      case ViewState.error:
        return SubErrorView(_error ?? "Unknown error.", _getAssetStats);
      default:
        return const LoadingView("Loading");
    }
  }
}
