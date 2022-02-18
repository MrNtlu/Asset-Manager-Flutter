import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/sub_error_view.dart';
import 'package:asset_flutter/content/providers/subscription_stats.dart';
import 'package:asset_flutter/content/widgets/subscription/cb_info_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubscriptionCurrencyBar extends StatefulWidget {
  const SubscriptionCurrencyBar();

  @override
  State<SubscriptionCurrencyBar> createState() => _SubscriptionCurrencyBarState();
}

class _SubscriptionCurrencyBarState extends State<SubscriptionCurrencyBar> {
  final List<String> _dropdownList = ["Monthly", "Total"];
  late String _dropdownValue;
  bool _isInit = false;
  bool _isDisposed = false;
  ViewState _state = ViewState.init;
  String? _error;

  @override
  void initState() {
    super.initState();
    _dropdownValue = _dropdownList[0];
  }

  void _getSubscriptionStats() {
    setState(() {
      _state = ViewState.loading;
    });
    
    Provider.of<SubscriptionStatsProvider>(context, listen: false).getSubscriptionStats().then((response){
      _error = response.error;

      if (!_isDisposed) {
        setState(() {
          if (response.code != null || response.error != null) {
            _state = ViewState.error;
          } else {
            _state = response.data.isEmpty
              ? ViewState.empty 
              : ViewState.done;
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
      _getSubscriptionStats();
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case ViewState.loading:
        return const LoadingView("Loading");
      case ViewState.empty:
      case ViewState.done:
        return Container(
          margin: const EdgeInsets.only(top: 12, bottom: 8),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                child: Row(
                  children: [
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _dropdownValue,
                        items: _dropdownList.map((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                value,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _dropdownValue = value;
                            });
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        (_dropdownValue == "Monthly" 
                        ? "Payments"
                        : "Paid"),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              CurrencyBarInfoCard(_dropdownValue == _dropdownList[0]),
            ],
          ),
        );
      case ViewState.error:
        return SubErrorView(_error ?? "Unknown error.", _getSubscriptionStats);
      default:
        return const LoadingView("Loading");
    }
  }
}