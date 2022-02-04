import 'package:asset_flutter/content/pages/portfolio/portfolio_page.dart';
import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';

class SDEditDatePicker extends StatefulWidget {
  final TestSubscriptionData _data;
  const SDEditDatePicker(this._data, {Key? key}) : super(key: key);

  @override
  State<SDEditDatePicker> createState() => SDEditDatePickerState();
}

class SDEditDatePickerState extends State<SDEditDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              widget._data.billDate.dateToFormatDate(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: ElevatedButton.icon(
              onPressed: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: widget._data.billDate,
                  firstDate: DateTime(2015),
                  lastDate: DateTime(DateTime.now().year + 3)
                );
                if(selectedDate != null) {
                  setState(() {
                    widget._data.billDate = selectedDate;
                  });
                }
                return;
              }, 
              label: const Text("Pick Date", style: TextStyle(fontSize: 16)),
              icon: const Icon(Icons.more_time_rounded, size: 20)
            ),
          )
        ],
      ),
    );
  }
}