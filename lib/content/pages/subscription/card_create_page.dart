import 'dart:io';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/currency_sheet.dart';
import 'package:asset_flutter/common/widgets/error_dialog.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/premium_dialog.dart';
import 'package:asset_flutter/common/widgets/success_view.dart';
import 'package:asset_flutter/content/models/requests/card.dart';
import 'package:asset_flutter/content/providers/common/currency_sheet_state.dart';
import 'package:asset_flutter/content/providers/subscription/card_state.dart';
import 'package:asset_flutter/content/providers/subscription/cards.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:awesome_card/awesome_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:asset_flutter/content/providers/subscription/card.dart' as card;
import 'package:provider/provider.dart';

class CardCreatePage extends StatefulWidget {
  final bool isCreate;
  final String? creditCardID;

  const CardCreatePage(this.isCreate, {this.creditCardID, Key? key}) : super(key: key);

  @override
  State<CardCreatePage> createState() => _CardCreatePageState();
}

class _CardCreatePageState extends State<CardCreatePage> {
  CreateState _state = CreateState.init;
  final form = GlobalKey<FormState>();
  final List<String> _cardTypes = ["MasterCard", "AmericanExpress", "Visa", "Maestro"];

  late final CreditCardCreate? createData;
  late final CreditCardUpdate? updateData;
  late final card.CreditCard? _creditCard;
  late final CardProvider _cardProvider;
  late final CardStateProvider _cardStateProvider;
  late final CurrencySheetSelectionStateProvider _currencySheetSelectionStateProvider;

  late String cardNumber;
  late String cardHolderName;
  late String cardName;
  late String cardColor;
  late String cardType;
  late String currency;

  void _createCreditCard() {
    final isValid = form.currentState?.validate();
    if (isValid != null && !isValid) {
      return;
    }
    setState(() {
      _state = CreateState.loading;
    });

    form.currentState?.save();

    _cardProvider.addCreditCard(createData!).then((value) {
      if (_state != CreateState.disposed) {
        if (value.error == null) {
          setState(() {
            _state = CreateState.success;
          });
        } else {
          if (value.error!.startsWith("free members")) {
            showDialog(
              context: context, 
              builder: (ctx) => PremiumErrorDialog(value.error!)
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

  void _updateCreditCard() {
    final isValid = form.currentState?.validate();
    if (isValid != null && !isValid) {
      return;
    }
    setState(() {
      _state = CreateState.loading;
    });

    form.currentState?.save();
    if (cardColor != _creditCard!.color) {
      updateData!.color = _creditCard!.color;
    }

    if (cardType != _creditCard!.cardType) {
      updateData!.cardType = _creditCard!.cardType;
    }

    if (currency != _creditCard!.currency) {
      updateData!.currency = currency;
    }

    _creditCard!.updateCard(updateData!).then((value) {
      if (_state != CreateState.disposed) {
        if (value.error == null) {
          _cardStateProvider.setRefresh(true);
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
      currency = widget.isCreate ? createData!.currency : _currencySheetSelectionStateProvider.symbol!;
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
      _cardProvider = Provider.of<CardProvider>(context, listen: false);
      _cardStateProvider = Provider.of<CardStateProvider>(context, listen: false);

      _currencySheetSelectionStateProvider = Provider.of<CurrencySheetSelectionStateProvider>(context);
      _currencySheetSelectionStateProvider.addListener(_currencySheetListener);

      if (widget.isCreate) {
        createData = CreditCardCreate("Card Name", "XXXX", "Card Holder", CardColors().cardColors[0].value.toString(), "MasterCard", 'USD');
      } else {
        _creditCard = _cardProvider.findById(widget.creditCardID!);
        updateData = CreditCardUpdate(widget.creditCardID!);
      }

      cardNumber = widget.isCreate ? createData!.lastDigits : _creditCard!.lastDigits;
      cardHolderName = widget.isCreate ? createData!.cardHolder : _creditCard!.cardHolder;
      cardName = widget.isCreate ? createData!.name : _creditCard!.name;
      cardColor = widget.isCreate ? createData!.color : _creditCard!.color;
      cardType = widget.isCreate ? createData!.cardType : _creditCard!.cardType;
      currency = widget.isCreate ? createData!.currency : _creditCard!.currency;

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
        final cardColorPick = widget.isCreate ? createData!.color : _creditCard!.color;
        final cardTypePick = widget.isCreate ? createData!.cardType : _creditCard!.cardType;

        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: CreditCard(
                  cardNumber: "XXXX XXXX XXXX ${cardNumber == "" ? 'XXXX' : cardNumber}",
                  cardHolderName: cardHolderName == "" ? "Card Holder" : cardHolderName,
                  bankName: cardName == "" ? "Card Name" : cardName,
                  cardType: _cardTypeMapper(cardTypePick),
                  showBackSide: false,
                  frontTextColor: Colors.white,
                  frontBackground: Container(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    color: Color(int.parse(cardColorPick)),
                  ),
                  backBackground: CardBackgrounds.white,
                  showShadow: true,
                  horizontalMargin: 12,
                ),
              ),
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
                            cardName = value;
                          });
                        },
                        textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          if (value != null) {
                            if (!widget.isCreate && _creditCard!.name != value){
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
                        initialValue: widget.isCreate ? null : cardName,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          labelText: "Card Name",
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
                            cardHolderName = value;
                          });
                        },
                        textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          if (value != null) {
                            if (!widget.isCreate && _creditCard!.cardHolder != value){
                              updateData!.cardHolder = value;
                            } else if (widget.isCreate) {
                              createData!.cardHolder = value;
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
                        initialValue: widget.isCreate ? null : cardHolderName,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          labelText: "Card Holder",
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
                                maxLength: 4,
                                keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                                textInputAction: TextInputAction.done,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                onChanged: (value) {
                                  setState(() {
                                    cardNumber = value;
                                  });
                                },
                                onSaved: (value) {
                                  if (value != null) {
                                    if (!widget.isCreate && _creditCard!.lastDigits != value){
                                      updateData!.lastDigits = value;
                                    } else if (widget.isCreate) {
                                      createData!.lastDigits = value;
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
                                initialValue: widget.isCreate ? null : cardNumber,
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(),
                                  labelText: "Last 4 Digits",
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
                                    Text(currency, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                                  builder: (_) => CurrencySheet(selectedSymbol: currency)
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
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 4, right: 4, bottom: 24),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for(var color in CardColors().cardColors)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (widget.isCreate) {
                              createData!.color = color.value.toString(); 
                            } else {
                              _creditCard!.color = color.value.toString();
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: (cardColorPick == color.value.toString())
                                    ? Colors.orangeAccent
                                    : Colors.transparent),
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: color,
                          ),
                        ),
                      ),
                    ],
                  )
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for(var type in _cardTypes)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (widget.isCreate) {
                            createData!.cardType = type; 
                          } else {
                            _creditCard!.cardType = type;
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: (type == cardTypePick)
                                  ? Colors.orangeAccent
                                  : Colors.transparent),
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.black,
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: getCardTypeIcon(cardType: _cardTypeMapper(type)),
                          ),
                        ),
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
                  onPressed: () => widget.isCreate ? _createCreditCard() : _updateCreditCard(),
                  padding: const EdgeInsets.all(12),
                  child: const Text(
                    "Save",
                    style: TextStyle(fontSize: 18),
                  ), 
                )
                : ElevatedButton(
                  onPressed: () => widget.isCreate ? _createCreditCard() : _updateCreditCard(),
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

  CardType _cardTypeMapper(String cardType) {
    switch (cardType) {
      case "AmericanExpress":
        return CardType.americanExpress;
      case "MasterCard":
        return CardType.masterCard;
      case "Visa":
        return CardType.visa;
      case "Maestro":
        return CardType.maestro;
      default:
        return CardType.masterCard;
    }
  }
}