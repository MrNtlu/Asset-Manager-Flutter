import 'dart:io';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/error_dialog.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/premium_dialog.dart';
import 'package:asset_flutter/common/widgets/success_view.dart';
import 'package:asset_flutter/content/models/requests/card.dart';
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
  final card.CreditCard? creditCard;

  const CardCreatePage(this.isCreate, {this.creditCard, Key? key}) : super(key: key);

  @override
  State<CardCreatePage> createState() => _CardCreatePageState();
}

class _CardCreatePageState extends State<CardCreatePage> {
  CreateState _state = CreateState.init;
  final form = GlobalKey<FormState>();
  final List<String> _cardTypes = ["MasterCard", "AmericanExpress", "Visa", "Maestro"];

  late final CreditCardCreate? createData;
  late final CreditCardUpdate? updateData;
  late final CardProvider _cardProvider;

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

  @override
  void dispose() {
    _state = CreateState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == CreateState.init) {
      if (widget.isCreate) {
        createData = CreditCardCreate("Card Name", "XXXX", "Card Holder", CardColors().cardColors[0].value.toString(), "MasterCard");
      } else {
        updateData = CreditCardUpdate(widget.creditCard!.id);
      }

      _cardProvider = Provider.of<CardProvider>(context, listen: false);
    }
    _state = CreateState.editing;
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
        title: const Text("Create", style: TextStyle(color: Colors.black)),
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
          child: const SuccessView("created", shouldJustPop: true)
        );
      case CreateState.editing:
        final cardNumber = widget.isCreate ? createData!.lastDigits : widget.creditCard!.lastDigits;
        final cardHolderName = widget.isCreate ? createData!.cardHolder : widget.creditCard!.cardHolder;
        final cardName = widget.isCreate ? createData!.name : widget.creditCard!.name;
        final cardColor = widget.isCreate ? createData!.color : widget.creditCard!.color;
        final cardType = widget.isCreate ? createData!.cardType : widget.creditCard!.cardType;

        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: CreditCard(
                  cardNumber: "XXXX XXXX XXXX ${cardNumber == "" ? 'XXXX' : cardNumber}",
                  cardHolderName: cardHolderName == "" ? "Card Holder" : cardHolderName,
                  bankName: cardName == "" ? "Card Name" : cardName,
                  cardType: _cardTypeMapper(cardType),
                  showBackSide: false,
                  frontTextColor: Colors.white,
                  frontBackground: Container(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    color: Color(int.parse(cardColor)),
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
                            if (widget.isCreate) {
                              createData!.name = value; 
                            } else {
                              widget.creditCard!.name = value;
                            }
                          });
                        },
                        textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          if (value != null) {
                            if (!widget.isCreate && widget.creditCard!.name != value){
                              updateData!.name = value;
                            } else {
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
                        initialValue: "",
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
                            if (widget.isCreate) {
                              createData!.cardHolder = value; 
                            } else {
                              widget.creditCard!.cardHolder = value;
                            }
                          });
                        },
                        textInputAction: TextInputAction.next,
                        onSaved: (value) {
                          if (value != null) {
                            if (!widget.isCreate && widget.creditCard!.cardHolder != value){
                              updateData!.cardHolder = value;
                            } else {
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
                        initialValue: "",
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          labelText: "Card Holder",
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.fromLTRB(12, 16, 12, 0),
                      child: TextFormField(
                        maxLength: 4,
                        keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                        textInputAction: TextInputAction.done,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (value) {
                          setState(() {
                            if (widget.isCreate) {
                              createData!.lastDigits = value; 
                            } else {
                              widget.creditCard!.lastDigits = value;
                            }
                          });
                        },
                        onSaved: (value) {
                          if (value != null) {
                            if (!widget.isCreate && widget.creditCard!.lastDigits != value){
                              updateData!.lastDigits = value;
                            } else {
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
                        initialValue: "",
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          labelText: "Last 4 Digits",
                        ),
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
                              widget.creditCard!.color = color.value.toString();
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: (cardColor == color.value.toString())
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
                            widget.creditCard!.cardType = type;
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: (type == cardType)
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
                  padding: const EdgeInsets.all(12),
                  child: const Text(
                    "Save",
                    style: TextStyle(fontSize: 18),
                  ), 
                  onPressed: () => _createCreditCard(),
                )
                : ElevatedButton(
                  onPressed: () => _createCreditCard(),
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
        return const LoadingView("Creating Subscription");
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