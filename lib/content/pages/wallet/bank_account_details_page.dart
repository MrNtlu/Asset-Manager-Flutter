import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/no_item_holder.dart';
import 'package:asset_flutter/content/providers/wallet/bank_account.dart';
import 'package:asset_flutter/content/providers/wallet/bank_accounts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BankAccountDetailsPage extends StatefulWidget {
  final String _bankAccID;

  const BankAccountDetailsPage(this._bankAccID, {Key? key}) : super(key: key);

  @override
  State<BankAccountDetailsPage> createState() => _BankAccountDetailsPageState();
}

class _BankAccountDetailsPageState extends State<BankAccountDetailsPage> {
  ViewState _state = ViewState.init;
  late final BankAccountProvider _bankAccProvider;

  @override
  void dispose() {
    _state = ViewState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == ViewState.init) {
      _bankAccProvider = Provider.of<BankAccountProvider>(context);

      _state = ViewState.done;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    late final BankAccount _bankAcc;
    try {
      _bankAcc = _bankAccProvider.findById(widget._bankAccID);
    } catch (_) {
      _bankAcc = BankAccount('', '', '', '', '');
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          _bankAcc.name, 
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.white,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    switch (_state) {
      case ViewState.done:
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: _state == ListState.empty
            ? const Center(child: NoItemView("Couldn't find subscription."))
            : Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ListView.builder(
                itemBuilder: ((context, index) {
                  final _data = _bankAccProvider.items[index];
                  
                  return ChangeNotifierProvider.value(
                    value: _data,
                    child: Container()
                  );
                }),
                itemCount: _bankAccProvider.items.length,
                shrinkWrap: true,
              ),
            )
        );
      default:
        return const LoadingView("Loading");
    }
  }
}