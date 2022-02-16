class SupportedCurrencies {
  final List<String> subCurrencies = ["USD", "EUR", "GBP", "KRW", "JPY", "TL"];
  final List<String> currencies = ["USD", "EUR", "GBP", "KRW", "JPY"];
  
  SupportedCurrencies._privateConstructor();

  static final SupportedCurrencies _instance =
      SupportedCurrencies._privateConstructor();

  factory SupportedCurrencies() {
    return _instance;
  }
}
