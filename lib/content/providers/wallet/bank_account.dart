import 'package:flutter/material.dart';

class BankAccount with ChangeNotifier {
  final String id;
  late String name;
  late String iban;
  late String accountHolder;
  late String currency;

  BankAccount(this.id, this.name, this.iban, this.accountHolder, this.currency);

  //TODO: UpdateBankAccount
}
