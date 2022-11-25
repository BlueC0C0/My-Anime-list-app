import 'package:flutter/material.dart';
import 'package:flutter_app2/view/pageSettings/SettingsRow.dart';

class SettingsContainer extends StatefulWidget {
  String title;
  List<SettingsRow> children;

  SettingsContainer({@required this.title, @required this.children});

  @override
  _SettingsContainerState createState() => _SettingsContainerState();
}

class _SettingsContainerState extends State<SettingsContainer>
    with
        AutomaticKeepAliveClientMixin<SettingsContainer>,
        TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    //print(widget.anime.id.toString() + " " + widget.anime.title);
    return Container(
      margin: const EdgeInsets.only(bottom: 8, right: 4, left: 4, top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              this.widget.title,
              style: TextStyle(fontSize: 27),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 7),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(5)),
            child: Column(
              children: this.widget.children,
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
