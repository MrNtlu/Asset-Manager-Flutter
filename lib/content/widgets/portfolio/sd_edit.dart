import 'package:asset_flutter/common/widgets/dropdown.dart';
import 'package:asset_flutter/common/widgets/textfield.dart';
import 'package:asset_flutter/content/pages/portfolio/portfolio_page.dart';
import 'package:flutter/material.dart';

class SubscriptionDetailsEdit extends StatelessWidget {
  final TestSubscriptionData _data;
  late final Dropdown dropdown;


  SubscriptionDetailsEdit(this._data, {Key? key}) : super(key: key){
    dropdown = Dropdown(
      const ["USD", "EUR", "GBP", "KRW", "JPY"],
      dropdownColor: Color(_data.color),
      textStyle: const TextStyle(color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 135,
          width: double.infinity,
          color: Color(_data.color),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                alignment: Alignment.center,
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  maxLines: 1,
                  initialValue: _data.name,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Name",
                    hintStyle: TextStyle(
                      color: Colors.white
                    ),
                    enabledBorder: UnderlineInputBorder(      
                      borderSide: BorderSide(color: Colors.white),   
                    ),  
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),  
                  )
                )
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        maxLines: 1,
                        initialValue: _data.price.toString(),
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: "Price",
                          hintStyle: TextStyle(
                            color: Colors.white
                          ),
                          enabledBorder: UnderlineInputBorder(      
                            borderSide: BorderSide(color: Colors.white),   
                          ),  
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),  
                        )
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: dropdown,
                    )
                  ],
                )
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 8, right: 8, top: 16),
          child: TextFormField(
            keyboardType: TextInputType.name,
            maxLines: 1,
            initialValue: _data.description ?? '',
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(),
              labelText: "Description",
            ),
          ),
        ),
        //Date Picker https://www.youtube.com/watch?v=yMZpwXQcP2E
        //Bill Cycle Multiple Dropdown
        //Color picker https://www.youtube.com/watch?v=Q67qNgSVVpA&t=1414s
      ],
    );
  }
}