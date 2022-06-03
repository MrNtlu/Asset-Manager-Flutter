import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/error_view.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/no_item_holder.dart';
import 'package:asset_flutter/content/providers/subscription/card_subscriptions.dart';
import 'package:asset_flutter/content/widgets/subscription/sl_cell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardDetailsSubscriptionList extends StatefulWidget {
  final String _creditCardID;

  const CardDetailsSubscriptionList(this._creditCardID, {Key? key}) : super(key: key);

  @override
  State<CardDetailsSubscriptionList> createState() => _CardDetailsSubscriptionListState();
}

class _CardDetailsSubscriptionListState extends State<CardDetailsSubscriptionList> {
  ListState _state = ListState.init;
  String? _error;
  late final CardSubscriptionsProvider _cardSubscriptionsProvider;

  void _getSubscriptionsByCardID() {
    setState(() {
      _state = ListState.loading;
    });
    
    _cardSubscriptionsProvider.getSubscriptionsByCardID(cardID: widget._creditCardID).then((response){
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
      _cardSubscriptionsProvider = Provider.of<CardSubscriptionsProvider>(context);
      _getSubscriptionsByCardID();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    switch (_state) {
      case ListState.loading:
        return const LoadingView("Fetching subscriptions");
      case ListState.error:
        return ErrorView(_error ?? "Unknown error!", _getSubscriptionsByCardID);
      case ListState.empty:
      case ListState.done:
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: _state == ListState.empty
            ? const Center(child: NoItemView("Couldn't find subscription."))
            : Padding(
              padding: const EdgeInsets.all(4),
              child: ListView.builder(
                itemBuilder: ((context, index) {
                  final _data = _cardSubscriptionsProvider.items[index];
                  
                  return ChangeNotifierProvider.value(
                    value: _data,
                    child: SubscriptionListCell(_data, isCardDetails: true)
                  );
                }),
                itemExtent: 100,
                itemCount: _cardSubscriptionsProvider.items.length,
                shrinkWrap: true,
              ),
            )
        );
      default:
        return const LoadingView("Loading");
    }
  }
}