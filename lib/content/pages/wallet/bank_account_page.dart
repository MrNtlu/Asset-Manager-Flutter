import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/error_view.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/no_item_holder.dart';
import 'package:asset_flutter/content/pages/wallet/bank_account_details_page.dart';
import 'package:asset_flutter/content/pages/wallet/bank_create_page.dart';
import 'package:asset_flutter/content/providers/wallet/bank_account_state.dart';
import 'package:asset_flutter/content/providers/wallet/bank_accounts.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BankAccountPage extends StatefulWidget {
  const BankAccountPage({Key? key}) : super(key: key);

  @override
  State<BankAccountPage> createState() => _BankAccountPageState();
}

class _BankAccountPageState extends State<BankAccountPage> {
  ListState _state = ListState.init;
  String? _error;
  late final BankAccountProvider _bankProvider;
  late final BankAccountStateProvider _bankAccStateProvider;

  void _getBankAccounts() {
    setState(() {
      _state = ListState.loading;
    });

    _bankProvider.getBankAccounts().then((response) {
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

  void _bankListener() {
    if (_state != ListState.disposed) {
      if (_bankProvider.items.isEmpty && _state == ListState.done) {
        setState(() {
          _state = ListState.empty;
        });
      } else if (_bankProvider.items.isNotEmpty && _state == ListState.empty) {
        setState(() {
          _state = ListState.done;
        });
      } 
    }
  }

  void _bankAccStateListener() {
    if (_state != ListState.disposed && _bankAccStateProvider.shouldRefresh) {
      _getBankAccounts();
    }
  }

  @override
  void dispose() {
    _bankProvider.removeListener(_bankListener);
    _bankAccStateProvider.removeListener(_bankAccStateListener);
    _state = ListState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == ListState.init) {
      _bankProvider = Provider.of<BankAccountProvider>(context);
      _bankProvider.addListener(_bankListener);

      _bankAccStateProvider = Provider.of<BankAccountStateProvider>(context);
      _bankAccStateProvider.addListener(_bankAccStateListener);

      _getBankAccounts();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          "Bank Accounts", 
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const BankCreatePage(true))
            ), 
            icon: const Icon(Icons.add_rounded, size: 28)
          )
        ],
      ),
      body: SafeArea(
        child: _portraitBody(),
      ),
    );
  }

  Widget _portraitBody() {
    switch (_state) {
      case ListState.loading:
        return const LoadingView("Getting bank accounts");
      case ListState.error:
        return ErrorView(_error ?? "Unknown error!", _getBankAccounts);
      case ListState.empty:
      case ListState.done:
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              _state == ListState.empty
                ? const Center(child: NoItemView("Couldn't find bank account."))
                : Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: ListView.separated(
                    itemCount: _bankProvider.items.length,
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: ((context, index) {
                      var _bankAccount = _bankProvider.items[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => BankAccountDetailsPage(_bankAccount.id))
                          );
                        },
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                const Center(
                                  child: Icon(
                                    Icons.account_balance_rounded,
                                    color: Colors.black,
                                    size: 42,
                                  ),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                                    child: Text(
                                      _bankAccount.name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    _bankAccount.currency,
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    })
                  ),
                ),
          ])
        );
      default:
        return const LoadingView("Loading");
    }
  }
}