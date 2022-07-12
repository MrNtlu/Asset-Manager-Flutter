import 'dart:io';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/check_dialog.dart';
import 'package:asset_flutter/common/widgets/error_view.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/no_item_holder.dart';
import 'package:asset_flutter/content/pages/wallet/bank_account_details_sheet.dart';
import 'package:asset_flutter/content/pages/wallet/bank_create_page.dart';
import 'package:asset_flutter/content/providers/wallet/bank_account_state.dart';
import 'package:asset_flutter/content/providers/wallet/bank_accounts.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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

  void _deleteBankAccount(String id) {
    setState(() {
      _state = ListState.loading;
    });

    _bankProvider.deleteBankAccount(id).then((response) {
      _error = response.error;
      if (_state != ListState.disposed) {
        setState(() {
          _state = response.error != null
            ? ListState.error
            : (
              _bankProvider.items.isEmpty
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
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context), 
                      icon: const Icon(Icons.arrow_back_ios_new_rounded)
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const BankCreatePage(true))
                        ), 
                        icon: const Icon(Icons.add_box_rounded)
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(child: _portraitBody()),
          ],
        ),
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
        return Stack(
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
                    onTap: () => showModalBottomSheet(
                      context: context,
                      shape: Platform.isIOS || Platform.isMacOS
                      ? const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(16),
                          topLeft: Radius.circular(16)
                        ),
                      )
                      : null,
                      enableDrag: true,
                      isDismissible: true,
                      builder: (_) => BankAccountDetailsSheet(_bankAccount.id)
                    ),
                    child: Slidable(
                      endActionPane: ActionPane(
                        motion: const StretchMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (slideContext) => showDialog(
                              context: context,
                              builder: (ctx) => AreYouSureDialog("edit", (){
                                Navigator.pop(ctx);
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => BankCreatePage(false, bankAccountID: _bankAccount.id,))
                                );
                              }),
                            ),
                            backgroundColor: Theme.of(context).colorScheme.bgColor,
                            foregroundColor: Colors.orange,
                            icon: Icons.edit_rounded,
                            label: 'Edit',
                          ),
                          SlidableAction(
                            onPressed: (context) => showDialog(
                              context: context,
                              builder: (ctx) => AreYouSureDialog('delete', (){
                                Navigator.pop(ctx);
                                _deleteBankAccount(_bankAccount.id);
                              })
                            ),
                            backgroundColor: Theme.of(context).colorScheme.bgColor,
                            foregroundColor: Colors.red,
                            icon: Icons.delete_rounded,
                            label: 'Delete',
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: SizedBox(
                              height: 75,
                              child: Row(
                                children: [
                                  const Center(
                                    child: Icon(
                                      Icons.account_balance_rounded,
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
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ),
                  );
                })
              ),
            ),
          ]
        );
      default:
        return const LoadingView("Loading");
    }
  }
}