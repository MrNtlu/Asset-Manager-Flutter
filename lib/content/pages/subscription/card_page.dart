import 'dart:io';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/error_view.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/no_item_holder.dart';
import 'package:asset_flutter/content/pages/subscription/card_create_page.dart';
import 'package:asset_flutter/content/providers/subscription/card_state.dart';
import 'package:asset_flutter/content/providers/subscription/cards.dart';
import 'package:asset_flutter/content/widgets/subscription/cd_stats_sheet.dart';
import 'package:awesome_card/awesome_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardPage extends StatefulWidget {
  const CardPage({Key? key}) : super(key: key);

  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  ListState _state = ListState.init;
  String? _error;
  late final CardProvider _cardProvider;
  late final CardStateProvider _cardStateProvider;

  void _getCreditCards() {
    setState(() {
      _state = ListState.loading;
    });
    
    _cardProvider.getCreditCards().then((response) {
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

  void _cardListener() {
    if (_state != ListState.disposed) {
      if (_cardProvider.items.isEmpty && _state == ListState.done) {
        setState(() {
          _state = ListState.empty;
        });
      } else if (_cardProvider.items.isNotEmpty && _state == ListState.empty) {
        setState(() {
          _state = ListState.done;
        });
      } 
    }
  }

  void _cardStateListener() {
    if (_state != ListState.disposed && _cardStateProvider.shouldRefresh) {
      _getCreditCards();
    }
  }

  @override
  void dispose() {
    _cardProvider.removeListener(_cardListener);
    _cardStateProvider.removeListener(_cardStateListener);
    _state = ListState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == ListState.init) {
      _cardProvider = Provider.of<CardProvider>(context);
      _cardProvider.addListener(_cardListener);

      _cardStateProvider = Provider.of<CardStateProvider>(context);
      _cardStateProvider.addListener(_cardStateListener);

      _getCreditCards();
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
                          MaterialPageRoute(builder: (_) => const CardCreatePage(true))
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
        )
      )
    );
  }

  Widget _portraitBody() {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait || Platform.isMacOS || Platform.isWindows;

    switch (_state) {
      case ListState.loading:
        return const LoadingView("Getting credit cards");
      case ListState.error:
        return ErrorView(_error ?? "Unknown error!", _getCreditCards);
      case ListState.empty:
      case ListState.done:
        return Stack(
          children: [
            _state == ListState.empty
            ? const Center(child: NoItemView("Couldn't find credit card."))
            : Padding(
              padding: const EdgeInsets.only(top: 8),
              child: ListView.builder(
                itemCount: _cardProvider.items.length,
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: ((context, index) {
                  var _creditCard = _cardProvider.items[index];

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
                      builder: (_) => CardDetailsStatsSheet(_creditCard.id)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                      child: CreditCard(
                        cardNumber: "XXXX XXXX XXXX ${_creditCard.lastDigits}",
                        cardHolderName: _creditCard.cardHolder,
                        bankName: _creditCard.name,
                        cardType: _cardTypeMapper(_creditCard.cardType),
                        showBackSide: false,
                        frontBackground: Container(
                          width: double.maxFinite,
                          height: double.maxFinite,
                          color: Color(int.parse(_creditCard.color)),
                        ),
                        backBackground: CardBackgrounds.white,
                        frontTextColor: index % 4 == 3 ? Colors.black : Colors.white,
                        showShadow: true,
                        horizontalMargin: 8,
                        height: isPortrait ? null : 250,
                        width: isPortrait ? null : 500,
                      ),
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