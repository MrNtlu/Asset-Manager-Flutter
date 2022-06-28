import 'package:asset_flutter/content/providers/portfolio/portfolio_filter.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvestmentFilterList extends StatefulWidget {
  const InvestmentFilterList({Key? key}) : super(key: key);

  @override
  State<InvestmentFilterList> createState() => _InvestmentFilterListState();
}

class _InvestmentFilterListState extends State<InvestmentFilterList> {
  final filterList = ["Crypto", "Stock", "Exchange", "Commodity"];
  late final PortfolioFilterProvider _provider;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _provider = Provider.of<PortfolioFilterProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4, left: 8),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final isSelected = _provider.filterList.contains(filterList[index]);
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: FilterChip(
                label: Text(
                  filterList[index],
                  style: TextStyle(
                    color: isSelected ? Theme.of(context).colorScheme.toggleTextColor : Colors.white
                  ),
                ),
                selected: isSelected,
                selectedColor: Theme.of(context).colorScheme.toggleColor,
                checkmarkColor: Theme.of(context).colorScheme.toggleTextColor,
                backgroundColor: Theme.of(context).colorScheme.bgTransparentColor,
                onSelected: (value) {
                  setState(() {
                    if (isSelected) {
                      _provider.filterSelectionRemoved(filterList[index]);
                    } else {
                      _provider.filterSelectionAdded(filterList[index]);
                    }
                  });
                }
              ),
            );
          },
          itemCount: filterList.length,
        ),
      ),
    );
  }
}