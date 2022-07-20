import 'dart:ui';

import 'package:asset_flutter/static/log.dart';
import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/error_dialog.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/no_item_holder.dart';
import 'package:asset_flutter/common/widgets/success_view.dart';
import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/static/purchase_api.dart';
import 'package:flutter/cupertino.dart';
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

    if (_state != ListState.disposed) {  
      setState(() {
        _state = offerings.isEmpty ? ListState.empty : ListState.done;
      });
    }
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors().bgSecondary,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => Navigator.pop(context), 
                child: const Text(
                  "Close",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white
                  )
                )
              )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  "assets/lottie/premium.json",
                  height: 32,
                  width: 32,
                  frameRate: FrameRate(60)
                ),
                const Text(
                  "Premium Plans",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                ),
              ],
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: AppColors().bgSecondary,
      ),
      body: _portraitBody()
    );
  }

  Widget _portraitBody() {
    switch (_state) {
      case ListState.done:
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: AppColors().bgSecondary,
              image: const DecorationImage(
                image: AssetImage("assets/images/auth_bg.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(width: 2, color: Colors.white30)
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                          child: ExpansionTile(
                            textColor: Colors.black,
                            iconColor: Colors.black,
                            collapsedTextColor: Colors.white,
                            collapsedIconColor: Colors.white,
                            title: const Text(
                              "Premium Benefits",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            expandedCrossAxisAlignment: CrossAxisAlignment.start,
                            childrenPadding: const EdgeInsets.symmetric(horizontal: 6),
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: Icon(Icons.all_inclusive_rounded, color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: Text("Unlimited Investments", style: TextStyle(color: Colors.white, fontSize: 16))
                                  )
                                ],
                              ),
                              const Divider(color: Colors.white),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: Icon(Icons.all_inclusive_rounded, color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: Text("Unlimited Subscriptions", style: TextStyle(color: Colors.white, fontSize: 16))
                                  )
                                ],
                              ),
                              const Divider(color: Colors.white),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: Icon(Icons.all_inclusive_rounded, color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: Text("Unlimited Transactions", style: TextStyle(color: Colors.white, fontSize: 16))
                                  )
                                ],
                              ),
                              const Divider(color: Colors.white),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: Icon(Icons.all_inclusive_rounded, color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: Text("Unlimited Credit Cards", style: TextStyle(color: Colors.white, fontSize: 16))
                                  )
                                ],
                              ),
                              const Divider(color: Colors.white),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: Icon(Icons.all_inclusive_rounded, color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: Text("Unlimited Bank Accounts", style: TextStyle(color: Colors.white, fontSize: 16))
                                  )
                                ],
                              ),
                              const Divider(color: Colors.white),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: Icon(Icons.trending_up_rounded, color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: Text("Stats for Longer Periods", style: TextStyle(color: Colors.white, fontSize: 16))
                                  )
                                ],
                              ),
                              const Divider(color: Colors.white),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: Icon(Icons.post_add_rounded, color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: Text("Increased Watchlist Limit", style: TextStyle(color: Colors.white, fontSize: 16))
                                  )
                                ],
                              ),
                              const Divider(color: Colors.white),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: Icon(Icons.notification_add_rounded, color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: Text("Subscription Reminder", style: TextStyle(color: Colors.white, fontSize: 16))
                                  )
                                ],
                              ),
                              const Divider(color: Colors.white),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: Icon(Icons.more_horiz_rounded, color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: Text("More soon...", style: TextStyle(color: Colors.white, fontSize: 16))
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      final package = _packages[index];
                      final product = package.product;
                              
                      return GestureDetector(
                        onTap: () async {
                          setState(() {
                            _state = ListState.loading;
                          });
                        
                          try {
                            await Purchases.purchasePackage(package);
                            Log().createLog("${product.title} ${product.identifier} purchased.");
                        
                            showDialog(
                              context: context,
                              builder: (_) => const SuccessView("purchased. Thank you for becoming a premium member")
                            );
                          } on PlatformException catch (e) {
                            if (_state != ListState.disposed) { 
                              setState(() {
                                _state = ListState.done;
                              });
                            }
                        
                            var errorCode = PurchasesErrorHelper.getErrorCode(e);
                            if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
                              final appUserID = await Purchases.appUserID;
                              final purchaserInfo = await Purchases.getPurchaserInfo();
                              Log().createLog("${product.title} failed to purchase. $appUserID $purchaserInfo ${e.message}");
                              
                              showDialog(
                                context: context,
                                builder: (_) => ErrorDialog(e.message ?? "Failed to purchase.")
                              );
                            }
                          }
                        },
                        child: ClipRRect(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors().bgSecondary,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(width: 2, color: CupertinoColors.systemBlue)
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            padding: const EdgeInsets.all(6),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            product.title.split('(')[0].split('-')[1].trimLeft(),
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if(product.identifier != "kantan_099_1m")
                                    Container(
                                      decoration: BoxDecoration(
                                        color: product.identifier == "kantan_749_1y"
                                        ? AppColors().accentColor
                                        : AppColors().greenColor,
                                        borderRadius: const BorderRadius.all(Radius.circular(4)),
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: Text(
                                        product.identifier == "kantan_749_1y"
                                        ? "Better Price"
                                        : "Best Offer",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      product.priceString + _identifierToString(product.identifier),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8, bottom: 4),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      product.identifier != "kantan_11999_unlimited"
                                      ? "Cancel anytime"
                                      : "One-time payment, cannot be canceled",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey.shade300
                                      ),
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
                ),
              ],
            ),
          ),
        );
      case ListState.empty:
        return const Center(child: NoItemView('No offer found', textColor: Colors.white,));
      default:
        return const Center(child: LoadingView("Loading", textColor: Colors.white));
    }
  }

  String _identifierToString(String identifier) {
    if(identifier == "kantan_099_1m") {
      return "/month";
    } else if(identifier == "kantan_749_1y") {
      return "/year";
    } else {
      return "";
    }
  }
}
