class SupportedMarkets {
  final List<String> stockMarkets = [
    "Nasdaq 100",
    "S&P 500",
    "Dow Jones Industrial Average",
    "DAX",
    "BIST 100",
    "CAC 40",
    "FTSE 100",
    "SMI",
    "Nikkei 225",
    "Hang Seng",
    "Taiwan Weighted",
    "Shanghai Composite"
  ];

  final List<String> commodityMarket = ["Business Insider"];
  final List<String> exchangeMarket = ["Forex"];
  final List<String> cryptoMarket = ["CoinMarketCap"];

  SupportedMarkets._privateConstructor();

  static final SupportedMarkets _instance =
      SupportedMarkets._privateConstructor();

  factory SupportedMarkets() {
    return _instance;
  }
}
