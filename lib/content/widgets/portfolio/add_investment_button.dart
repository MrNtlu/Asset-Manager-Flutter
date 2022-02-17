import 'package:asset_flutter/common/widgets/add_elevated_button.dart';
import 'package:asset_flutter/content/pages/portfolio/investment_create_page.dart';
import 'package:flutter/material.dart';

class AddInvestmentButton extends StatelessWidget {
  final EdgeInsets edgeInsets;

  const AddInvestmentButton({
    this.edgeInsets = const EdgeInsets.all(8), 
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AddElevatedButton("Add Investment", (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: ((context) => const InvestmentCreatePage()))
        );
      },
      edgeInsets: edgeInsets,
    );
  }
}