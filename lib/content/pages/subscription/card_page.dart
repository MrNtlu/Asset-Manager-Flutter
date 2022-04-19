import 'dart:io';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/error_view.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/no_item_holder.dart';
import 'package:asset_flutter/content/providers/subscription/cards.dart';
import 'package:asset_flutter/static/colors.dart';
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
  //late final CardStateProvider _cardStateProvider;

  void _getCreditCards(){
    setState(() {
      _state = ListState.loading;
    });
    
    _cardProvider.getCreditCards().then((response){
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

  @override
  void dispose() {
    _state = ListState.disposed;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == ListState.init) {
      _cardProvider = Provider.of<CardProvider>(context);
      _getCreditCards();

      // _cardStateProvider = Provider.of<CardStateProvider>(context);
      // _cardStateProvider.addListener(() {
      //   if (_state != ListState.disposed && _cardStateProvider.shouldRefresh) {
      //     _getSubscriptions();
      //   }
      // });
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
          "Credit Cards", 
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: MediaQuery.of(context).orientation == Orientation.portrait || Platform.isMacOS || Platform.isWindows
        ? _portraitBody()
        : Container()
      )
    );
  }

  Widget _portraitBody() {
    switch (_state) {
      case ListState.loading:
        return const LoadingView("Fetching credit cards");
      case ListState.error:
        return ErrorView(_error ?? "Unknown error!", _getCreditCards);
      case ListState.empty:
      case ListState.done:
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              _state == ListState.empty
                ? const NoItemView("Couldn't find credit card.")
                : Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: ListView.builder(
                    itemCount: _cardProvider.items.length,
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      var _creditCard = _cardProvider.items[index];
                      return CreditCard(
                        cardNumber: "XXXX XXXX XXXX ${_creditCard.lastDigits}",
                        cardHolderName: "Burak Fidan", //TODO: Implement name
                        bankName: _creditCard.name,
                        cardType: CardType.masterCard,
                        showBackSide: false,
                        frontBackground: Container(
                          width: double.maxFinite,
                          height: double.maxFinite,
                          color: Colors.black,
                        ),
                        backBackground: CardBackgrounds.white,
                        showShadow: true,
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