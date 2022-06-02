import 'package:asset_flutter/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

// ignore_for_file: must_be_immutable
class TransactionCreateDateTimePicker extends StatefulWidget {
  DateTime selectedDateTime;

  TransactionCreateDateTimePicker(this.selectedDateTime, {Key? key}) : super(key: key);

  @override
  State<TransactionCreateDateTimePicker> createState() => _TransactionCreateDateTimePickerState();
}

class _TransactionCreateDateTimePickerState extends State<TransactionCreateDateTimePicker> {
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
      _controller = TextEditingController(text: widget.selectedDateTime.dateToFullDateTime());
      isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      enableInteractiveSelection: false,
      controller: TextEditingController(text: widget.selectedDateTime.dateToFullDateTime()),
      decoration: const InputDecoration(
        filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0)),
          border: OutlineInputBorder(borderSide: BorderSide(width: 0)),
          labelText: "Pick Date",
          suffixIcon: Icon(Icons.calendar_month_rounded, size: 20),
      ),
      onTap: () => DatePicker.showDateTimePicker(
        context,
        showTitleActions: true,

        minTime: DateTime(2021, 5, 1),
        maxTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 7, 12, 59, 59, 0, 0),
        onConfirm: (date) {
          setState(() {
            widget.selectedDateTime = date;
            _controller.text = date.dateToFullDateTime();
          });
        },
        currentTime: widget.selectedDateTime, 
        locale: LocaleType.en
      ),
    );
  }
}