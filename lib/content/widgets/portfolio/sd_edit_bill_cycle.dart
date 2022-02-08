import 'package:asset_flutter/content/models/responses/subscription.dart';
import 'package:flutter/material.dart';

class SDEditBillCycle extends StatefulWidget {
  final List<String> billCycleList = ["Day", "Month", "Year"];
  BillCycle billCycle;
  
  SDEditBillCycle({required this.billCycle, Key? key}) : super(key: key);

  @override
  State<SDEditBillCycle> createState() => _SDEditBillCycleState();
}

class _SDEditBillCycleState extends State<SDEditBillCycle> {
  List<int> billCycleCountList = [for(var i = 1; i<12; i++) i];
  late BillCycle selectedBillCycle;

  @override
  void initState() {
    super.initState();
    selectedBillCycle = widget.billCycle;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8, top: 4),
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedBillCycle.getBillCycle().keys.elementAt(0).toString(),
                items: billCycleCountList.map((value) {
                  return DropdownMenuItem(
                    value: value.toString(),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(value.toString()),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedBillCycle.setBillCycleFrequency(int.parse(value));
                      widget.billCycle = selectedBillCycle;
                    });
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedBillCycle.getBillCycle().values.elementAt(0),
                items: widget.billCycleList.map((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(value)
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      switch (value) {
                        case "Day":
                          billCycleCountList = [for(var i = 1; i<31; i++) i];
                          break;
                        case "Year":
                          billCycleCountList = [for(var i = 1; i<10; i++) i];
                          break;
                        default:
                          billCycleCountList = [for(var i = 1; i<12; i++) i];
                          break;
                      }
                      selectedBillCycle.setBillCycleType(value);
                      selectedBillCycle.setBillCycleFrequency(1);
                      widget.billCycle = selectedBillCycle;
                    });
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}