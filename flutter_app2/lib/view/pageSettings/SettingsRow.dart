import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class SettingsRow extends StatefulWidget {
  String name;
  String value;
  Function onclick;

  SettingsRow(
      {@required this.name, @required this.value, @required this.onclick});

  @override
  _SettingsRowState createState() => _SettingsRowState();
}

class _SettingsRowState extends State<SettingsRow>
    with AutomaticKeepAliveClientMixin<SettingsRow>, TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    //print(widget.anime.id.toString() + " " + widget.anime.title);
    return Container(
      margin: const EdgeInsets.only(bottom: 8, right: 4, left: 4, top: 4),
      child: Row(
        children: [
          Expanded(
              child: Text(this.widget.name, style: TextStyle(fontSize: 20))),
          InkWell(
            onTap: () => this.widget.onclick(),
            child: Text(
              this.widget.value,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
