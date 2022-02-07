import 'package:asset_flutter/content/models/subscription.dart';
import 'package:asset_flutter/content/pages/tabs_page.dart';
import 'package:asset_flutter/content/widgets/portfolio/sd_edit.dart';
import 'package:asset_flutter/content/widgets/portfolio/sd_view.dart';
import 'package:flutter/material.dart';

class SubscriptionDetailsPage extends StatefulWidget {
  final Subscription _data;

  const SubscriptionDetailsPage(this._data, {Key? key}) : super(key: key);

  @override
  State<SubscriptionDetailsPage> createState() =>
      _SubscriptionDetailsPageState();
}

class _SubscriptionDetailsPageState extends State<SubscriptionDetailsPage> {
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
      title: Text(
        _isEditing ?
        "Edit"
        :
        ''
      ),
      backgroundColor: TabsPage.primaryLightishColor,
      actions: [
        !_isEditing ?
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            tooltip: 'Enter Edit State',
            onPressed: () {
              setState(() {
                _isEditing = true;
              });
            },
          )
        :
        IconButton(
          icon: const Icon(Icons.save_rounded),
          tooltip: 'Exit Edit State',
          onPressed: () {
            setState(() {
              _isEditing = false;
            });
          },
        )
      ],
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        child: !_isEditing ?
        SubscriptionDetailsView(widget._data)
        :
        SubscriptionDetailsEdit(widget._data)
      ),
    ),
    );
  }
}
