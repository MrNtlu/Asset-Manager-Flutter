import 'package:asset_flutter/common/widgets/loading_view.dart';
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
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<AssetStatsProvider>(context, listen: false).getAssetStats().then((response){
        //TODO: error handling etc.
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
    //TODO: If data null show something else
    return _isLoading
    ? const LoadingView("Loading...")
    : Column(
      children: const [
        Portfolio(),
        PortfolioStats(false),
      ],
    );
  }
}
