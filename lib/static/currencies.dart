class SupportedCurrencies {
  final List<String> currencies = ["USD", "EUR", "GBP", "KRW", "JPY"];
  final List<String> stockCurrencies = [
    "USD",
    "USD",
    "USD",
    "EUR",
    "TRY",
    "EUR",
    "GBP",
    "CHF",
    "JPY",
    "HKD",
    "TWD",
    "CNY"
  ];
  final List<String> commodityCurrencies = ["USD"];
  final List<String> cryptoCurrencies = ["USD"];

  SupportedCurrencies._privateConstructor();

  static final SupportedCurrencies _instance =
      SupportedCurrencies._privateConstructor();

  factory SupportedCurrencies() {
    return _instance;
  }
}
