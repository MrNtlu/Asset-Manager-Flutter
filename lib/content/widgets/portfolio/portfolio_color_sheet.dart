import 'dart:io';
import 'package:asset_flutter/content/widgets/portfolio/pl_text.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/static/shared_pref.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PortfolioColorSheet extends StatefulWidget {
  const PortfolioColorSheet({Key? key}) : super(key: key);

  @override
  State<PortfolioColorSheet> createState() => _PortfolioColorSheetState();
}

class _PortfolioColorSheetState extends State<PortfolioColorSheet> {
  late int _selectedColor;

  @override
  void didChangeDependencies() {
    _selectedColor = SharedPref().getPortfolioColor();
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
        child: MediaQuery.of(context).orientation == Orientation.portrait
        ? _body()
        : SingleChildScrollView(child: _body()),
      ),
    );
  }

  Widget _body() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var color in PortfolioColors().portfolioColors)
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
        _portfolioBody(1000, 25),
        _portfolioBody(-1000, 25),
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
                  SharedPref().setPortfolioColor(_selectedColor);
                  Navigator.pop(context);
                }
              )
              : Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      SharedPref().setPortfolioColor(_selectedColor);
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
  );

  Widget _portfolioBody(double pl, double plPercentage) => Padding(
    padding: const EdgeInsets.only(top: 4),
    child: Container(
      padding: const EdgeInsets.only(top: 4, bottom: 2),
      margin: const EdgeInsets.only(left: 8, right: 8),
      child: Card(
        color: Color(_selectedColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 12, top: 12),
                child: Text(
                  "My Portfolio",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 6, left: 12, bottom: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'USD'.getCurrencyFromString() + " 12000",
                    softWrap: false,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width > 350 ? 36 : 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              PortfolioPLText(
                pl,
                plPercentage,
                null, 
                fontSize: MediaQuery.of(context).size.width > 350 ? 20 : 16, 
                iconSize: MediaQuery.of(context).size.width > 350 ? 22 : 18,
                plPrefix: 'USD'.getCurrencyFromString(),
              )
            ],
          ),
        ),
      ),
    ),
  );
}