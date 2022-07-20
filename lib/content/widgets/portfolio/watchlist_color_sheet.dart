import 'dart:io';
import 'package:asset_flutter/content/models/responses/favourite_investment.dart';
import 'package:asset_flutter/content/providers/portfolio/portfolio_state.dart';
import 'package:asset_flutter/content/widgets/portfolio/watchlist_cell.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/static/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistColorSheet extends StatefulWidget {
  const WatchlistColorSheet({Key? key}) : super(key: key);

  @override
  State<WatchlistColorSheet> createState() => _WatchlistColorSheetState();
}

class _WatchlistColorSheetState extends State<WatchlistColorSheet> {
  late int _selectedColor;
  late final PortfolioWatchlistRefreshProvider _watchlistRefreshProvider;

  @override
  void didChangeDependencies() {
    _selectedColor = SharedPref().getWatchlistColor();
    _watchlistRefreshProvider = Provider.of<PortfolioWatchlistRefreshProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: Platform.isIOS || Platform.isMacOS
        ? const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            topLeft: Radius.circular(16)
          ),
        )
        : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var color in WatchlistColors().watchlistColors)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColor = color.value;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: (_selectedColor == color.value)
                                    ? Colors.orangeAccent
                                    : Colors.transparent),
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: color,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: WatchlistCell(
                  FavouriteInvesting(
                    '', '', const FavouriteInvestingID('BTC', 'crypto', 'CoinMarketCap'), 
                    40000, 'USD', 1
                  ),
                  color: _selectedColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Platform.isIOS || Platform.isMacOS
                    ? CupertinoButton(
                      child: const Text('Cancel'), 
                      onPressed: () => Navigator.pop(context)
                    )
                    : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextButton(
                          onPressed: () => Navigator.pop(context), 
                          child: const Text('Cancel')
                        ),
                      ),
                    ),
                    Platform.isIOS || Platform.isMacOS
                    ? CupertinoButton.filled(
                      child: const Text('Save', style: TextStyle(color: Colors.white)), 
                      onPressed: () {
                        SharedPref().setWatchlistColor(_selectedColor);
                        _watchlistRefreshProvider.setRefresh(true);
                        Navigator.pop(context);
                      }
                    )
                    : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ElevatedButton(
                          onPressed: () {
                            SharedPref().setWatchlistColor(_selectedColor);
                            _watchlistRefreshProvider.setRefresh(true);
                            Navigator.pop(context);
                          }, 
                          child: const Text('Save', style: TextStyle(color: Colors.white))
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}