import 'package:flutter/material.dart';
import 'package:xml/xml.dart';

class News {
  String description;
  String title;
  String link;
  String imageURL;
  DateTime date;
  TimeOfDay time;

  News(this.description, this.title, this.link, this.imageURL);

  static List<News> fromXmlPage(final xml) {
    if (xml != null) {
      final document = XmlDocument.parse(xml);
      final items = document.findAllElements("item");
      //print(items.length);
      List<News> list = [];
      for (int i = 0; i < items.length; i++) {
        list.add(
          new News(
            items.elementAt(i).getElement("description").innerText.toString(),
            items.elementAt(i).getElement("title").innerText.toString(),
            items.elementAt(i).getElement("link").innerText.toString(),
            items
                .elementAt(i)
                .getElement("media:thumbnail")
                .innerText
                .toString(),
          ),
        );
      }

      return list;
    } else {
      return [];
    }
  }

  factory News.fromXmlItem(final item) {
    //print(item.runtimeType);
    News newsItem = new News(
        item.findElements("description").toString(),
        item.findElements("title").first.innerText.toString(),
        item.findElements("link").first.innerText.toString(),
        item.findElements("media:thumbnail").first.innerText.toString());
    return null;
  }
}
