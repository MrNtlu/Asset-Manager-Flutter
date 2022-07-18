class FavouriteInvesting {
  final String id;
  final String uid;
  final FavouriteInvestingID investingID;
  final num price;
  final String currency;
  int priority;

  FavouriteInvesting(
    this.id, this.uid, this.investingID, 
    this.price, this.currency, this.priority)
  ;
}

class FavouriteInvestingID {
  final String symbol;
  final String type;
  final String market;

  const FavouriteInvestingID(this.symbol, this.type, this.market);
}
