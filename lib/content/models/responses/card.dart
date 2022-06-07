class CardStats {
  final CardSubscriptionStats subscriptionStats;
  final CardTransactionTotal transactionTotal;

  const CardStats(this.subscriptionStats, this.transactionTotal);
}

class CardSubscriptionStats {
  final String currency;
  final num monthlyPayment;
  final num totalPayment;

  const CardSubscriptionStats(this.currency, this.monthlyPayment, this.totalPayment);
}

class CardTransactionTotal {
  final String currency;
  final num totalTransaction;

  const CardTransactionTotal(this.currency, this.totalTransaction);
}
