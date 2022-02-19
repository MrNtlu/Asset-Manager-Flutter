class SupportedCurrencies {
  final List<String> subCurrencies = [
    "AED",
    "ARS",
    "AUD",
    "BRL",
    "CAD",
    "CHF",
    "CNH",
    "CNY",
    "DKK",
    "EGP",
    "EUR",
    "GBP",
    "HKD",
    "HRK",
    "IDR",
    "ILS",
    "INR",
    "JPY",
    "KRW",
    "MXN",
    "NGN",
    "NOK",
    "PHP",
    "PKR",
    "PLN",
    "RUB",
    "SAR",
    "THB",
    "TRY",
    "USD",
    "UYU",
  ];
  final List<String> currencies = ["USD", "EUR", "GBP", "KRW", "JPY"];

  SupportedCurrencies._privateConstructor();

  static final SupportedCurrencies _instance =
      SupportedCurrencies._privateConstructor();

  factory SupportedCurrencies() {
    return _instance;
  }
}
