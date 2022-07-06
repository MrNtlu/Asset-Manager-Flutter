import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SDEditDatePicker extends StatefulWidget {
  DateTime billDate;
  SDEditDatePicker({required this.billDate, Key? key}) : super(key: key);

  @override
  State<SDEditDatePicker> createState() => SDEditDatePickerState();
}

class SDEditDatePickerState extends State<SDEditDatePicker> {
  late final TextEditingController _controller;
  late bool isInit;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    isInit = false;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!isInit) {
      _controller = TextEditingController(text: widget.billDate.dateToFormatDate());
      isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
      child: TextFormField(
        readOnly: true,
        enableInteractiveSelection: false,
        controller: _controller,
        decoration: const InputDecoration(
          filled: true,
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0)),
          border: OutlineInputBorder(borderSide: BorderSide(width: 0)),
          labelText: "Initial Bill Date",
          suffixIcon: Icon(Icons.calendar_month_rounded, size: 20),
        ),
        onTap: () async {
          DateTime? selectedDate = await showDatePicker(
            context: context,
            initialDate: widget.billDate,
            firstDate: DateTime(2015),
            lastDate: DateTime(DateTime.now().year + 3)
          );
          if(selectedDate != null) {
            setState(() {
              widget.billDate = selectedDate;
              _controller.text = selectedDate.dateToFormatDate();
            });
          }
          return;
        },
      ),
    );
  }
}