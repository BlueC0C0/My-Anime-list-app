import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/anime/userList/listStatus.dart';
import 'package:flutter_app2/view/animeList/Utils.dart';

class ChangeStatusList extends StatelessWidget {
  ChangeStatusList();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        height: 300,
        padding: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AdaptiveTheme.of(context).theme.appBarTheme.backgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            userStatusIndicator(context, ListStatus.watching),
            userStatusIndicator(context, ListStatus.completed),
            userStatusIndicator(context, ListStatus.dropped),
            userStatusIndicator(context, ListStatus.paused),
            userStatusIndicator(context, ListStatus.plan_to_watch)
          ],
        ),
      ),
    );
  }

  Widget userStatusIndicator(BuildContext context, ListStatus listStatus) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop(listStatus);
      },
      child: Container(
        width: 200,
        padding: EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
          color: Utils.getSingleton().getStatusBackgroundColor(listStatus),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          listStatus.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            color: Utils.getSingleton().getStatusTexteColor(listStatus),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
