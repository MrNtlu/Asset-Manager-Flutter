String convertIndexNameToFlag(String index) {
  switch (index) {
    case "Nasdaq 100":
    case "S&P 500":
    case "Dow Jones Industrial Average":
      return "us";
    case "DAX":
      return "de";
    case "BIST 100":
      return "tr";
    case "CAC 40":
      return "eu";
    case "FTSE 100":
      return "gb";
    case "SMI":
      return "ch";
    case "Nikkei 225":
      return "jp";
    case "Hang Seng":
      return "hk";
    case "Taiwan Weighted":
      return "tw";
    case "Shanghai Composite":
      return "cn";
    default:
      return "us";
  }
}
