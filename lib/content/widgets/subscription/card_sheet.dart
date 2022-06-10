import 'dart:io';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/error_view.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/no_item_holder.dart';
import 'package:asset_flutter/content/providers/subscription/card.dart';
import 'package:asset_flutter/content/providers/subscription/card_sheet_state.dart';
import 'package:asset_flutter/content/providers/subscription/cards.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore_for_file: must_be_immutable
class CardSelectionSheet extends StatefulWidget {
  CreditCard? selectedCard;

  CardSelectionSheet(this.selectedCard, {Key? key}) : super(key: key);

  @override
  State<CardSelectionSheet> createState() => _CardSelectionSheetState();
}

class _CardSelectionSheetState extends State<CardSelectionSheet> {
  ListState _state = ListState.init;
  String? _error;
  late final List<bool> _selectionList = [];
  late bool isPortraitOrDesktop;
  late final CardProvider _cardProvider;
  late final CardSheetSelectionStateProvider _cardSelectionProvider;

  void _getCreditCards(){
    setState(() {
      _state = ListState.loading;
    });
    
    _cardProvider.getCreditCards().then((response){
      _error = response.error;
      if (_state != ListState.disposed) {
        final _data = response.data;
        for (var i = 0; i < _data.length; i++) {
          _selectionList.insert(
            i,
            (widget.selectedCard != null && _data[i].id == widget.selectedCard!.id)
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
    _cardSelectionProvider.onDisposed();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_state == ListState.init) {
      _cardProvider = Provider.of<CardProvider>(context);
      _cardSelectionProvider = Provider.of<CardSheetSelectionStateProvider>(context, listen: false);
      _getCreditCards();
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
                  final data = _cardProvider.items[index];
                  final currencySelection = _selectionList[index];
            
                  return ListTile(
                    onTap: () => handleSelection(index),
                    title: Text(
                      "${data.name} ${data.lastDigits}",
                      style: currencySelection 
                      ? const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      )
                      : TextStyle(fontSize: 18, color: AppColors().lightBlack),
                    ),
                    trailing: currencySelection ? Icon(Icons.check, color: Theme.of(context).colorScheme.bgTextColor, size: 26) : null
                  );
                }),
                separatorBuilder: (_, __) => const Divider(), 
                shrinkWrap: true,
                itemCount: _cardProvider.items.length,
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
                  child: const Text('Apply', style: TextStyle(color: Colors.white)), 
                  onPressed: () {
                    _cardSelectionProvider.cardSelectionChanged(
                      _selectionList.contains(true)
                      ? _cardProvider.items[_selectionList.indexOf(true)]
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
                        _cardSelectionProvider.cardSelectionChanged(
                          _selectionList.contains(true)
                          ? _cardProvider.items[_selectionList.indexOf(true)]
                          : null
                        );
                        Navigator.pop(context);
                      }, 
                      child: const Text('Apply', style: TextStyle(color: Colors.white))
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
          child: ErrorView(_error ?? "Unknown error!", _getCreditCards),
        );
      case ListState.loading:
        return const LoadingView("Getting credit cards");
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
        widget.selectedCard = _cardProvider.items[index];
        _selectionList[index] = true;
      });
    }
  }
}