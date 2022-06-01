import 'dart:io';

import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/currency_sheet.dart';
import 'package:asset_flutter/common/widgets/error_dialog.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/premium_dialog.dart';
import 'package:asset_flutter/common/widgets/success_view.dart';
import 'package:asset_flutter/content/models/requests/transaction.dart';
import 'package:asset_flutter/content/models/responses/transaction.dart';
import 'package:asset_flutter/content/providers/common/currency_sheet_state.dart';
import 'package:asset_flutter/content/providers/subscription/cards.dart';
import 'package:asset_flutter/content/providers/wallet/bank_accounts.dart';
import 'package:asset_flutter/content/providers/wallet/transaction.dart';
import 'package:asset_flutter/content/providers/wallet/transaction_state.dart';
import 'package:asset_flutter/content/providers/wallet/transactions.dart';
import 'package:asset_flutter/content/widgets/wallet/tc_datetime_picker.dart';
import 'package:asset_flutter/content/widgets/wallet/transaction_filter_sheet_category_list.dart';
import 'package:asset_flutter/content/widgets/wallet/transaction_sheet_banks.dart';
import 'package:asset_flutter/content/widgets/wallet/transaction_sheet_cards.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionCreatePage extends StatefulWidget {
  final bool isCreate;
  final String? transactionID;

  const TransactionCreatePage(this.isCreate, {this.transactionID, Key? key}) : super(key: key);

  @override
  State<TransactionCreatePage> createState() => _TransactionCreatePageState();
}

class _TransactionCreatePageState extends State<TransactionCreatePage> {
  CreateState _state = CreateState.init;
  final form = GlobalKey<FormState>();
  final List<bool> isSelected = [true, false];

  late final TransactionCreate? createData;
  late final TransactionUpdate? updateData;
  late final Transaction? _transaction;
  late final TransactionsProvider _provider;
  late final CurrencySheetSelectionStateProvider _currencySheetSelectionStateProvider;
  late final TransactionStateProvider _transactionsStateProvider;
  late final TransactionFilterSheetCategoryList _categoryList;
  late final TransactionCreateDateTimePicker _dateTimePicker;
  late final TransactionSheetCreditCards _creditCardPicker;
  late final TransactionSheetBankAccounts _bankAccPicker;

  late String transactionTitle;
  late String? transactionDescription;
  late int transactionCategory;
  late num transactionPrice;
  late String transactionCurrency;
  late TransactionMethod? transactionMethod;
  late DateTime transactionDate;
  
  int tempTransactionMethod = -1;


  void _createTransaction() {
    final isValid = form.currentState?.validate();
    if (isValid != null && !isValid) {
      return;
    }
    
    if (_categoryList.selectedCategory == null) {
      Platform.isIOS || Platform.isMacOS
      ? showCupertinoDialog(
        context: context, 
        builder: (_) => const ErrorDialog("Please select category.")
      )
      : showDialog(
        context: context, 
        builder: (_) => const ErrorDialog("Please select category.")
      );
      return;
    }

    setState(() {
      _state = CreateState.loading;
    });

    form.currentState?.save();

    createData!.transactionDate = _dateTimePicker.selectedDateTime;
    createData!.category = _categoryList.selectedCategory!.value;
    if (isSelected[0] && _bankAccPicker.selectedBankAcc != null) {
      createData!.transactionMethod = TransactionMethod(methodID: _bankAccPicker.selectedBankAcc!.id, type: 0);
    } else if (isSelected[1] && _creditCardPicker.selectedCard != null) {
      createData!.transactionMethod = TransactionMethod(methodID: _creditCardPicker.selectedCard!.id, type: 1);
    }

    _provider.createTransaction(createData!).then((value) {
      if (_state != CreateState.disposed) {
        if (value.error == null) {
          _transactionsStateProvider.setRefresh(true);
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

  void _updateTransaction() {
    final isValid = form.currentState?.validate();
    if (isValid != null && !isValid) {
      return;
    }
    setState(() {
      _state = CreateState.loading;
    });

    form.currentState?.save();

    if (_categoryList.selectedCategory!.value != _transaction!.category) {
      updateData!.category = _categoryList.selectedCategory!.value;
    }

    if (_dateTimePicker.selectedDateTime != _transaction!.transactionDate) {
      updateData!.transactionDate = _dateTimePicker.selectedDateTime;
    }

    if (transactionCurrency != _transaction!.currency) {
      updateData!.currency = transactionCurrency;
    }

    if (isSelected[0]) {
      _bankAccPicker.selectedBankAcc != null
      ? updateData!.transactionMethod = TransactionMethod(methodID: _bankAccPicker.selectedBankAcc!.id, type: 0)
      : updateData!.transactionMethod = null;
    } else if (isSelected[1]) {
      _creditCardPicker.selectedCard != null
      ? updateData!.transactionMethod = TransactionMethod(methodID: _creditCardPicker.selectedCard!.id, type: 1)
      : updateData!.transactionMethod = null;
    }

    _provider.updateTransaction(updateData!).then((value) {
      if (_state != CreateState.disposed) {
        if (value.error == null) {
          _transactionsStateProvider.setRefresh(false);
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
      transactionCurrency = widget.isCreate ? createData!.currency : _currencySheetSelectionStateProvider.symbol!;
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
      _provider = Provider.of<TransactionsProvider>(context, listen: false);
      _categoryList = TransactionFilterSheetCategoryList();

      _transactionsStateProvider = Provider.of<TransactionStateProvider>(context, listen: false);
      _currencySheetSelectionStateProvider = Provider.of<CurrencySheetSelectionStateProvider>(context);
      _currencySheetSelectionStateProvider.addListener(_currencySheetListener);

      if (widget.isCreate) {
        createData = TransactionCreate("", -1, -1, "USD", DateTime.now());
      } else {
        _transaction = _provider.findById(widget.transactionID!);
        _categoryList.selectedCategory = Category.valueToCategory(_transaction!.category);
        updateData = TransactionUpdate(widget.transactionID!);
      }

      transactionTitle = widget.isCreate ? createData!.title : _transaction!.title;
      transactionDescription = widget.isCreate ? createData!.description : _transaction!.description;
      transactionCategory = widget.isCreate ? createData!.category : _transaction!.category;
      transactionPrice = widget.isCreate ? createData!.price : _transaction!.price;
      transactionCurrency = widget.isCreate ? createData!.currency : _transaction!.currency;
      transactionMethod = widget.isCreate ? createData!.transactionMethod : _transaction!.transactionMethod;
      transactionDate = widget.isCreate ? createData!.transactionDate : _transaction!.transactionDate;

      _dateTimePicker = TransactionCreateDateTimePicker(transactionDate);
      _creditCardPicker = TransactionSheetCreditCards();
      _bankAccPicker = TransactionSheetBankAccounts();

      if (!widget.isCreate && transactionMethod != null) {
        if  (transactionMethod!.type == 0) {
          final selectedBankAcc = Provider.of<BankAccountProvider>(context, listen: false).findById(transactionMethod!.methodID);
          _bankAccPicker.selectedBankAcc = selectedBankAcc;
        } else {
          isSelected[1] = true;
          isSelected[0] = false;
          final selectedCard = Provider.of<CardProvider>(context, listen: false).findById(transactionMethod!.methodID);
          _creditCardPicker.selectedCard = selectedCard;
        }
      }

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
          color: Colors.white,
        ),
        title: Text(
          widget.isCreate ? "Create" : "Update", 
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
        ),
        backgroundColor: AppColors().primaryLightishColor,
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
              Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 4),
                child: _categoryList,
              ),
              const Divider(),
              Form(
                key: form,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.fromLTRB(12, 16, 12, 0),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          if (value != null) {
                            if (!widget.isCreate && _transaction!.title != value){
                              updateData!.title = value;
                            } else if (widget.isCreate) {
                              createData!.title = value;
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
                        initialValue: widget.isCreate ? null : transactionTitle,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          labelText: "Title",
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.fromLTRB(12, 16, 12, 0),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          if (!widget.isCreate) {
                            if (transactionDescription == null || (transactionDescription != null && transactionDescription != value)) {
                              updateData!.description = value != null ? (value.trim() != '' ? value : null) : null;
                            }
                          } else {
                            createData!.description = value != null ? (value.trim() != '' ? value : null) : null;
                          }
                        },
                        initialValue: widget.isCreate ? null : transactionDescription,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          labelText: "Description (Optional)",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 3,
                            child: SizedBox(
                              width: double.infinity,
                              child: TextFormField(
                                keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                                textInputAction: TextInputAction.done,
                                onSaved: (value) {
                                  if (value != null) {
                                    final parsedValue = double.parse(value);
                                    if (!widget.isCreate && _transaction!.price != parsedValue){
                                      updateData!.price = parsedValue;
                                    } else if (widget.isCreate) {
                                      createData!.price = parsedValue;
                                    }
                                  }
                                },
                                validator: (value) {
                                  if (value != null) {
                                    if (value.isEmpty) {
                                      return "Please don't leave this empty.";
                                    } else if (double.tryParse(value) == null) {
                                      return "Price is not valid.";
                                    }
                                  }
                          
                                  return null;
                                },
                                initialValue: widget.isCreate ? null : transactionPrice.toString(),
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(),
                                  labelText: "Price",
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 1,
                            child: TextButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(transactionCurrency, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                                builder: (_) => CurrencySheet(selectedSymbol: transactionCurrency)
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ),
              const Divider(),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
                    child: _dateTimePicker,
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Payment Method",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ToggleButtons(
                          children: const [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                "Bank Account",
                                style: TextStyle(fontSize: 14)
                              )
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                "Credit Card",
                                style: TextStyle(fontSize: 14)
                              )
                            ),
                          ],
                          constraints: const BoxConstraints(maxHeight: 37, minHeight: 37),
                          borderWidth: 0,
                          color: Colors.black,
                          selectedColor: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          fillColor: AppColors().primaryColor,
                          isSelected: isSelected,
                          onPressed: (int newIndex) {
                            setState(() {
                              var falseIndex = newIndex == 0 ? 1 : 0;
                              if (!isSelected[newIndex]) {
                                isSelected[newIndex] = true;
                                isSelected[falseIndex] = false;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  if (isSelected[0])
                  _bankAccPicker,
                  if (isSelected[1])
                  _creditCardPicker,
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                width: double.infinity,
                child: Platform.isIOS || Platform.isMacOS
                ? CupertinoButton.filled(
                  onPressed: () => widget.isCreate ? _createTransaction() : _updateTransaction(),
                  padding: const EdgeInsets.all(12),
                  child: const Text(
                    "Save",
                    style: TextStyle(fontSize: 18),
                  ), 
                )
                : ElevatedButton(
                  onPressed: () => widget.isCreate ? _createTransaction() : _updateTransaction(),
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
        return LoadingView("${widget.isCreate ? 'Creating' : 'Updating'} Transaction");
      default:
        return const LoadingView("Loading");
    }
  }
}