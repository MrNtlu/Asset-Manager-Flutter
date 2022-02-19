import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/check_dialog.dart';
import 'package:asset_flutter/common/widgets/error_dialog.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/success_view.dart';
import 'package:asset_flutter/content/providers/subscription.dart';
import 'package:asset_flutter/content/providers/subscriptions.dart';
import 'package:asset_flutter/content/widgets/portfolio/sd_view_text.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubscriptionDetailsView extends StatefulWidget {
  final Subscription _data;
  bool canEnterEditMode = true;

  SubscriptionDetailsView(this._data, {Key? key}) : super(key: key);

  @override
  State<SubscriptionDetailsView> createState() => _SubscriptionDetailsViewState();
}

class _SubscriptionDetailsViewState extends State<SubscriptionDetailsView> {
  DetailState _state = DetailState.view;

  void _deleteSubscription() {
    widget.canEnterEditMode = false;

    setState(() {
      _state = DetailState.loading;
    });
    Provider.of<SubscriptionsProvider>(context, listen: false).deleteSubscription(widget._data.id).then((response){
      if (_state != DetailState.disposed) {
        if (response.error == null) {
          setState(() {
            _state = DetailState.view;
          });
          showDialog(
            barrierDismissible: false,
            barrierColor: Colors.black54,
            context: context,
            builder: (ctx) => const SuccessView("deleted")
          );
        } else {
          setState(() {
            _state = DetailState.view;
          });
          showDialog(
            context: context, 
            builder: (ctx) => ErrorDialog(response.error.toString())
          );
        }

        widget.canEnterEditMode = true;
      }
    });
  }

  @override
  void dispose() {
    _state = DetailState.disposed;
    widget.canEnterEditMode = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    switch (_state) {
      case DetailState.view:
        return Column(
          children: [
            Container(
              height: 110,
              width: double.infinity,
              color: Color(widget._data.color),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                      alignment: Alignment.bottomCenter,
                      child: AutoSizeText(
                        widget._data.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24
                        ),
                      ),
                    )
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 6),
                      alignment: Alignment.topCenter,
                      child: Text(
                        widget._data.price.toString() + ' ' + widget._data.currency,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                        ),
                      ),
                    )
                  )
                ],
              ),
            ),
            if(widget._data.description != null)
            SDViewText("Description", widget._data.description!),
            SDViewText("Initial Bill Date", widget._data.billDate.dateToFormatDate()),
            SDViewText("Bill Cycle", widget._data.billCycle.handleBillCycleString()),
            const SDViewText("Paid in Total", "1506.34"),
            Padding(
              padding: const EdgeInsets.all(12),
              child: OutlinedButton(
                onPressed: () {
                  showDialog(
                    context: context, 
                    builder: (ctx) => AreYouSureDialog('delete', (){
                      Navigator.pop(context);
                      _deleteSubscription();
                    })
                  );
                },
                child: const Text("Delete Subscription")
              ),
            )
          ],
        );
      case DetailState.loading:
      default:
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: const LoadingView("Loading")
        );
    }
  }
}