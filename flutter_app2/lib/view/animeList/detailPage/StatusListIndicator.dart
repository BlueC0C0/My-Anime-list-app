import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/anime/userList/listStatus.dart';
import 'package:flutter_app2/view/animeList/Utils.dart';

class StatusListIndicator extends StatefulWidget {
  ListStatus _listStatus;
  ListStatus _currentStatus;
  Function _ontap;

  StatusListIndicator(this._listStatus, this._currentStatus, this._ontap);

  @override
  _StatusListIndicatorState createState() => _StatusListIndicatorState();
}

class _StatusListIndicatorState extends State<StatusListIndicator> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget._ontap();
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: widget._currentStatus == widget._listStatus
              ? Utils.getSingleton()
                  .getStatusBackgroundColor(widget._listStatus)
              : Color.fromRGBO(28, 30, 39, 1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: AnimatedSize(
          duration: Duration(milliseconds: 100),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Icon(
                  Utils.getSingleton().getStatusIcon(widget._listStatus),
                  color: widget._currentStatus == widget._listStatus
                      ? Utils.getSingleton()
                          .getStatusTexteColor(widget._listStatus)
                      : AdaptiveTheme.of(context).theme.backgroundColor,
                  size: 35,
                ),
                widget._currentStatus == widget._listStatus
                    ? Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          widget._listStatus.name,
                          style: TextStyle(
                              color: Utils.getSingleton()
                                  .getStatusTexteColor(widget._listStatus),
                              fontWeight: FontWeight.w700),
                          overflow: TextOverflow.ellipsis,
                        ),
                        width: 90,
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
