import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/error_dialog.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/no_item_holder.dart';
import 'package:asset_flutter/common/widgets/success_view.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/static/purchase_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class OffersSheet extends StatefulWidget {
  const OffersSheet({Key? key}) : super(key: key);

  @override
  State<OffersSheet> createState() => OffersSheetState();
}

class OffersSheetState extends State<OffersSheet> {
  ListState _state = ListState.init;
  late final List<Package> _packages;

  Future _fetchOffers() async {
    setState(() {
      _state = ListState.loading;
    });

    final offerings = await PurchaseApi().fetchOffers();
    if (offerings.isNotEmpty) {
      _packages = offerings
          .map((offer) => offer.availablePackages)
          .expand((element) => element)
          .toList();
    }

    setState(() {
      _state = offerings.isEmpty ? ListState.empty : ListState.done;
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
      _fetchOffers();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return _portraitBody();
  }

  Widget _portraitBody() {
    switch (_state) {
      case ListState.done:
        return Container(
          decoration: BoxDecoration(
            color: AppColors().primaryColor,
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                topLeft: Radius.circular(12)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          "assets/lottie/premium.json",
                          height: 32,
                          width: 32
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Text(
                            "Premium Plans",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final package = _packages[index];
                  final product = package.product;

                  return GestureDetector(
                    onTap: () async {
                      try {
                        await Purchases.purchasePackage(package);
                        showDialog(
                          context: context,
                          builder: (_) => const SuccessView("purchased. Thank you for becoming a premium member")
                        );
                      } on PlatformException catch (e) {
                        var errorCode = PurchasesErrorHelper.getErrorCode(e);
                        if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
                          showDialog(
                            context: context,
                            builder: (_) => const ErrorDialog("Purchase cancelled.")
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (_) => ErrorDialog(e.message ?? "Failed to purchase.")
                          );
                        }
                      }
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        product.title.split('(')[0],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 16
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Text(
                                      product.description,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Text(
                                  product.priceString,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: _packages.length,
              ),
            ],
          ),
        );
      case ListState.empty:
        return const NoItemView('No offer found');
      default:
        return const LoadingView("Loading");
    }
  }
}
