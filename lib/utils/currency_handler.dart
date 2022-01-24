String convertCurrencyToSymbol(String currency) {
  switch (currency) {
    case "USD":
      return "\$";
    case "GBP":
      return "£";
    case "KRW":
      return "₩";
    case "JPY":
      return "¥";
    case "EUR":
      return "€";
    default:
      return "\$";
  }
}
