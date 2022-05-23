import 'package:asset_flutter/common/models/json_convert.dart';

class TransactionMethod implements JSONConverter {
  String methodID;
  int type;

  TransactionMethod({this.methodID = "", this.type = 0});

  @override
  Map<String, Object> convertToJson() => {"method_id": methodID, "type": type};
}
