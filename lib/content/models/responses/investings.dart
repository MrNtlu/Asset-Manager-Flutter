import 'package:flutter/material.dart';

class Investings {
  final String name;
  final String symbol;

  const Investings(this.name, this.symbol);

  @override
  bool operator == (Object other) =>
    other is Investings &&
    runtimeType == other.runtimeType &&
    (symbol == other.symbol ||
    name == other.name);

  @override
  int get hashCode => hashValues(name, symbol);    
}
