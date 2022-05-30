import 'dart:io';

import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/currency_sheet.dart';
import 'package:asset_flutter/common/widgets/error_dialog.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/premium_dialog.dart';
import 'package:asset_flutter/common/widgets/success_view.dart';
import 'package:asset_flutter/content/models/requests/bank_account.dart';
import 'package:asset_flutter/content/providers/common/currency_sheet_state.dart';
import 'package:asset_flutter/content/providers/wallet/bank_account.dart';
import 'package:asset_flutter/content/providers/wallet/bank_account_state.dart';
import 'package:asset_flutter/content/providers/wallet/bank_accounts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BankCreatePage extends StatefulWidget {
  final bool isCreate;
  final String? bankAccountID;

  const BankCreatePage(this.isCreate, {this.bankAccountID, Key? key}) : super(key: key);

  @override
  State<BankCreatePage> createState() => _BankCreatePageState();
}

class _BankCreatePageState extends State<BankCreatePage> {
  CreateState _state = CreateState.init;
  final form = GlobalKey<FormState>();

  late final BankAccountCreate? createData;
  late final BankAccountUpdate? updateData;
  late final BankAccount? _bankAccount;
  late final BankAccountProvider _bankAccProvider;
  late final BankAccountStateProvider _bankAccStateProvider;
  late final CurrencySheetSelectionStateProvider _currencySheetSelectionStateProvider;

  late String bankAccName;
  late String bankAccIban;
  late String bankAccHolder;
  late String bankAccCurrency;

  void _createBankAccount() {
    final isValid = form.currentState?.validate();
    if (isValid != null && !isValid) {
      return;
    }
    setState(() {
      _state = CreateState.loading;
    });

    form.currentState?.save();

    _bankAccProvider.addBankAccount(createData!).then((value) {
      if (_state != CreateState.disposed) {
        if (value.error == null) {
          setState(() {
            _state = CreateState.success;
          });
        } else {
          if (value.error!.startsWith("Free members")) {
            showDialog(
              context: context, 
              builder: (ctx) => PremiumErrorDialog(value.error!, MediaQuery.of(context).viewPadding.top)
            );
          } else {
            showDialog(
              context: context, 
              builder: (ctx) => ErrorDialog(value.error!)
            );
          }
          setState(() {
            _state = CreateState.editing;
          });
        } 
      }
    });
  }

  void _updateBankAccount() {
    final isValid = form.currentState?.validate();
    if (isValid != null && !isValid) {
      return;
    }
    setState(() {
      _state = CreateState.loading;
    });

    form.currentState?.save();

    if (bankAccCurrency != _bankAccount!.currency) {
      updateData!.currency = bankAccCurrency;
    }

    _bankAccount!.updateBankAccount(updateData!).then((value) {
      if (_state != CreateState.disposed) {
        if (value.error == null) {
          _bankAccStateProvider.setRefresh(true);
          setState(() {
            _state = CreateState.success;
          });
        } else {
          showDialog(
            context: context, 
            builder: (ctx) => ErrorDialog(value.error!)
          );
          
          setState(() {
            _state = CreateState.editing;
          });
        } 
      }
    });
  }

  void _currencySheetListener() {
    if (_state != ListState.disposed && _currencySheetSelectionStateProvider.symbol != null) {
      if (widget.isCreate) {
        createData!.currency = _currencySheetSelectionStateProvider.symbol!;
      }
      bankAccCurrency = widget.isCreate ? createData!.currency : _currencySheetSelectionStateProvider.symbol!;
    }
  }

   @override
  void dispose() {
    _currencySheetSelectionStateProvider.removeListener(_currencySheetListener);
    _state = CreateState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == CreateState.init) {
      _bankAccProvider = Provider.of<BankAccountProvider>(context, listen: false);
      _bankAccStateProvider = Provider.of<BankAccountStateProvider>(context, listen: false);

      _currencySheetSelectionStateProvider = Provider.of<CurrencySheetSelectionStateProvider>(context);
      _currencySheetSelectionStateProvider.addListener(_currencySheetListener);

      if (widget.isCreate) {
        createData = BankAccountCreate("", "", "", 'USD');
      } else {
        _bankAccount = _bankAccProvider.findById(widget.bankAccountID!);
        updateData = BankAccountUpdate(widget.bankAccountID!);
      }

      bankAccIban = widget.isCreate ? createData!.iban : _bankAccount!.iban;
      bankAccHolder = widget.isCreate ? createData!.accountHolder : _bankAccount!.accountHolder;
      bankAccName = widget.isCreate ? createData!.name : _bankAccount!.name;
      bankAccCurrency = widget.isCreate ? createData!.currency : _bankAccount!.currency;

      _state = CreateState.editing;
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
        title: Text(
          widget.isCreate ? "Create" : "Update", 
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: _body(),
      ),
    );
  }

  Widget _body() {
    switch (_state) {
      case CreateState.success:
        return Container(
          color: Colors.black54, 
          child: SuccessView(widget.isCreate ? "created" : "updated", shouldJustPop: true)
        );
      case CreateState.editing:
        return SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: form,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.fromLTRB(12, 16, 12, 0),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          setState(() {
                            bankAccName = value;
                          });
                        },
                        textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          if (value != null) {
                            if (!widget.isCreate && _bankAccount!.name != value){
                              updateData!.name = value;
                            } else if (widget.isCreate) {
                              createData!.name = value;
                            }
                          }
                        },
                        validator: (value) {
                          if (value != null) {
                            if (value.isEmpty) {
                              return "Please don't leave this empty.";
                            }
                          }

                          return null;
                        },
                        initialValue: widget.isCreate ? null : bankAccName,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          labelText: "Bank Account Name",
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.fromLTRB(12, 16, 12, 0),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          setState(() {
                            bankAccHolder = value;
                          });
                        },
                        textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          if (value != null) {
                            if (!widget.isCreate && _bankAccount!.accountHolder != value){
                              updateData!.accountHolder = value;
                            } else if (widget.isCreate) {
                              createData!.accountHolder = value;
                            }
                          }
                        },
                        validator: (value) {
                          if (value != null) {
                            if (value.isEmpty) {
                              return "Please don't leave this empty.";
                            }
                          }

                          return null;
                        },
                        initialValue: widget.isCreate ? null : bankAccHolder,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          labelText: "Account Holder",
                        ),
                      ),
                    ),
                    SizedBox(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              width: double.infinity,
                              margin: const EdgeInsets.fromLTRB(12, 16, 12, 0),
                              child: TextFormField(
                                keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                                textInputAction: TextInputAction.done,
                                onChanged: (value) {
                                  setState(() {
                                    bankAccIban = value;
                                  });
                                },
                                onSaved: (value) {
                                  if (value != null) {
                                    if (!widget.isCreate && _bankAccount!.iban != value){
                                      updateData!.iban = value;
                                    } else if (widget.isCreate) {
                                      createData!.iban = value;
                                    }
                                  }
                                },
                                validator: (value) {
                                  if (value != null) {
                                    if (value.isEmpty) {
                                      return "Please don't leave this empty.";
                                    }
                                  }
                          
                                  return null;
                                },
                                initialValue: widget.isCreate ? null : bankAccIban,
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(),
                                  labelText: "Bank Account No",
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: TextButton(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(bankAccCurrency, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    const Icon(Icons.arrow_drop_down_rounded, size: 30)
                                  ],
                                ),
                                onPressed: () => showModalBottomSheet(
                                  context: context, 
                                  shape: Platform.isIOS || Platform.isMacOS
                                  ? const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(16),
                                      topLeft: Radius.circular(16)
                                    ),
                                  )
                                  : null,
                                  enableDrag: false,
                                  isDismissible: true,
                                  isScrollControlled: true,
                                  builder: (_) => CurrencySheet(selectedSymbol: bankAccCurrency)
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                width: double.infinity,
                child: Platform.isIOS || Platform.isMacOS
                ? CupertinoButton.filled(
                  onPressed: () => widget.isCreate ? _createBankAccount() : _updateBankAccount(),
                  padding: const EdgeInsets.all(12),
                  child: const Text(
                    "Save",
                    style: TextStyle(fontSize: 18),
                  ), 
                )
                : ElevatedButton(
                  onPressed: () => widget.isCreate ? _createBankAccount() : _updateBankAccount(),
                  child: const Text("Save",
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold
                    )
                  ),
                ),
              ),
            ],
          ),
        );
      case CreateState.loading:
        return LoadingView("${widget.isCreate ? 'Creating' : 'Updating'} Subscription");
      default:
        return const LoadingView("Loading");
    }
  }
}
