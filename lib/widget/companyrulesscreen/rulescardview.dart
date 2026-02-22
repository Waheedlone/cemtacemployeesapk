import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class RulesCardView extends StatelessWidget {
  final String title;
  final String description;

  RulesCardView(this.title, this.description);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 1,
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
        child: ExpandableTheme(
          data: const ExpandableThemeData(
            iconPadding: EdgeInsets.all(0),
            iconColor: Colors.black,
            tapHeaderToExpand: true,
            animationDuration: Duration(milliseconds: 500),
          ),
          child: ExpandablePanel(
              header: Text(
                title,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              collapsed: Html(
                shrinkWrap: true,
                style: {
                  "body": Style(color: Colors.grey, fontSize: FontSize.medium,maxLines: 1)
                },
                data: description,
              ),
              expanded: Html(
                shrinkWrap: true,
                style: {
                  "body": Style(color: Colors.grey, fontSize: FontSize.medium)
                },
                data: description,
              )
          ),
        ),
      ),
    );
  }
}
