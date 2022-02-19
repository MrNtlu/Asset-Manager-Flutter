import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/error_view.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/no_item_holder.dart';
import 'package:asset_flutter/content/providers/subscription.dart';
import 'package:asset_flutter/content/providers/subscriptions.dart';
import 'package:asset_flutter/content/widgets/portfolio/section_title.dart';
import 'package:asset_flutter/content/widgets/subscription/sl_cell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubscriptionList extends StatefulWidget {
  @override
  State<SubscriptionList> createState() => _SubscriptionListState();
}

class _SubscriptionListState extends State<SubscriptionList> {
  bool _isInit = false;
  bool _isDisposed = false;
  ListState _state = ListState.init;
  late final SubscriptionsProvider _subscriptionsProvider;
  String? _error;

  void _getSubscriptions(){
    setState(() {
      _state = ListState.loading;
    });
    
    _subscriptionsProvider.getSubscriptions().then((response){
      _error = response.error;
      if (!_isDisposed) {
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
    _isDisposed = true;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _subscriptionsProvider = Provider.of<SubscriptionsProvider>(context);
      _getSubscriptions();
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _data = _subscriptionsProvider.items;

    return SizedBox(
      child: _body(_data),
    );
  }

  Widget _body(List<Subscription> _data) {
    switch (_state) {
      case ListState.loading:
        return const LoadingView("Fetching subscriptions");
      case ListState.empty:
        return Column(
          children: const [
            SectionTitle("Investments", ""),
            NoItemView("Couldn't find subscription.")
          ],
        );
      case ListState.done:
        return Column(
          children: [
            const SectionTitle("Subscriptions", "",),
            Expanded(
              child: ListView.builder(itemBuilder: ((context, index) {
                if(index == _data.length) {
                  return const SizedBox(height: 75);
                }
                final data = _data[index];
                return ChangeNotifierProvider.value(
                  value: data,
                  child: SubscriptionListCell()
                );
              }),
              itemCount: _data.length + 1,
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              ),
            ),
          ],
        );
      case ListState.error:
        return ErrorView(_error ?? "Unknown error!", _getSubscriptions);
      default:
        return const LoadingView("Fetching subscriptions");
    }
  }
}