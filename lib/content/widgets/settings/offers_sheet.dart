import 'package:asset_flutter/common/models/state.dart';
import 'package:asset_flutter/common/widgets/loading_view.dart';
import 'package:asset_flutter/common/widgets/no_item_holder.dart';
import 'package:asset_flutter/static/purchase_api.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class OffersSheet extends StatefulWidget {
  const OffersSheet({Key? key}) : super(key: key);

  @override
  State<OffersSheet> createState() => OffersSheetState();
}

//TODO:
// 1- https://youtu.be/h-jOMh2KXTA?t=1331
// 2- https://app.revenuecat.com/projects
// 3- https://play.google.com/console/
// 4- https://docs.revenuecat.com/docs/getting-started#section-configure-purchases
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
      _state = offerings.isEmpty 
        ? ListState.empty 
        : ListState.done;
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
        return ListView.builder(
          itemBuilder: (context, index) { 
            final package = _packages[index];
            final product = package.product;
            print(product.title);
            return Card(
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
                                fontWeight: FontWeight.bold,
                                fontSize: 16
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
            );
          },
          itemCount: _packages.length,
        );
      case ListState.empty:
        return const NoItemView('No offer found');
      default:
        return const LoadingView("Loading");
    }
  }
}
