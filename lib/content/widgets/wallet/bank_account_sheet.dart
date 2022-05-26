import 'dart:io';

import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/error_view.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/no_item_holder.dart';
import 'package:asset_flutter/content/providers/wallet/bank_account.dart';
import 'package:asset_flutter/content/providers/wallet/bank_account_selection_state.dart';
import 'package:asset_flutter/content/providers/wallet/bank_accounts.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class BankAccountSelectionSheet extends StatefulWidget {
  BankAccount? selectedBankAcc;

  BankAccountSelectionSheet(this.selectedBankAcc, {Key? key}) : super(key: key);

  @override
  State<BankAccountSelectionSheet> createState() => _BankAccountSelectionSheetState();
}

class _BankAccountSelectionSheetState extends State<BankAccountSelectionSheet> {
  ListState _state = ListState.init;
  String? _error;
  late final List<bool> _selectionList = [];
  late bool isPortraitOrDesktop;
  late final BankAccountProvider _bankAccountProvider;
  late final BankAccountSelectionStateProvider _bankAccSelectionProvider;

  void _getBankAccounts(){
    setState(() {
      _state = ListState.loading;
    });
    
    _bankAccountProvider.getBankAccounts().then((response){
      _error = response.error;
      if (_state != ListState.disposed) {
        final _data = response.data;
        for (var i = 0; i < _data.length; i++) {
          _selectionList.insert(
            i,
            (widget.selectedBankAcc != null && _data[i].id == widget.selectedBankAcc!.id)
            ? true 
            : false
          );
        }

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
    _bankAccSelectionProvider.onDisposed();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == ListState.init) {
      _bankAccountProvider = Provider.of<BankAccountProvider>(context);
      _bankAccSelectionProvider = Provider.of<BankAccountSelectionStateProvider>(context, listen: false);
      _getBankAccounts();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 350,
        decoration: Platform.isIOS || Platform.isMacOS
        ? const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            topLeft: Radius.circular(16)
          ),
        )
        : null,
        child: _body(),
      )
    );
  }

  Widget _body() {
    switch (_state) {
      case ListState.done:
        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemBuilder: ((context, index) {
                  final data = _bankAccountProvider.items[index];
                  final currencySelection = _selectionList[index];
            
                  return ListTile(
                    onTap: () => handleSelection(index),
                    title: Text(
                      "${data.iban} ${data.name}",
                      style: currencySelection 
                      ? const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                      )
                      : TextStyle(fontSize: 18, color: AppColors().lightBlack),
                    ),
                    trailing: currencySelection ? const Icon(Icons.check, color: Colors.black, size: 26) : null
                  );
                }),
                separatorBuilder: (_, __) => const Divider(), 
                shrinkWrap: true,
                itemCount: _bankAccountProvider.items.length,
              ),
            ),
            Row(
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
                  child: const Text('Apply'), 
                  onPressed: () {
                    _bankAccSelectionProvider.cardSelectionChanged(
                      _selectionList.contains(true)
                      ? _bankAccountProvider.items[_selectionList.indexOf(true)]
                      : null
                    );
                    Navigator.pop(context);
                  }
                )
                : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        _bankAccSelectionProvider.cardSelectionChanged(
                          _selectionList.contains(true)
                          ? _bankAccountProvider.items[_selectionList.indexOf(true)]
                          : null
                        );
                        Navigator.pop(context);
                      }, 
                      child: const Text('Apply')
                    ),
                  ),
                )
              ],
            )
          ],
        );
      case ListState.empty:
        return const SingleChildScrollView(
          child: NoItemView("Couldn't find any credit card."),
        );
      case ListState.error:
        return SingleChildScrollView(
          child: ErrorView(_error ?? "Unknown error!", _getBankAccounts),
        );
      case ListState.loading:
        return const LoadingView("Fetching credit cards");
      default:
        return const LoadingView("Loading");
    }
  }

  void handleSelection(int index) {
    if (_selectionList[index]) {
      setState(() {
        _selectionList[index] = false;
      });
    } else {

      for (var i = 0; i < _selectionList.length; i++) {
        if (index != i) {
          _selectionList[i] = false;
        }
      }

      setState(() {
        widget.selectedBankAcc = _bankAccountProvider.items[index];
        _selectionList[index] = true;
      });
    }
  }
}
