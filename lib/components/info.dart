import 'package:flutter/material.dart';

import 'info_list_item.dart';

class InfoContainer extends StatefulWidget {
  final topBorderRadius = 8.0;
  final String title;
  final isExpanded;
  final List<Map> items;

  InfoContainer(
      {Key key, @required this.title, this.isExpanded = true, this.items})
      : super(key: key);

  @override
  _InfoContainerState createState() => _InfoContainerState();
}

class _InfoContainerState extends State<InfoContainer> {
  bool _show = true;

  _toggleDetailsVisibility() {
    setState(() {
      _show = !_show;
    });
  }

  getItems() {
    if (widget.items == null)
      return [
        Center(
          child: Text("Nothing to show"),
        )
      ];

    return widget.items
        .map(
          (item) => InfoListItem(
            item["title"],
            subtitle1: item["subtitle1"],
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 18),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(widget.topBorderRadius),
            topRight: Radius.circular(widget.topBorderRadius),
          ),
        ),
        child: Column(
          children: [
            InkWell(
              child: infoTitle(),
              onTap: () => (_toggleDetailsVisibility()),
            ),
            (_show
                ? SizedBox()
                : Container(
                    height: 250,
                    child: ListView(
                      padding: EdgeInsets.only(top: 16, bottom: 16),
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: getItems(),
                        ),
                      ],
                    ),
                  ))
          ],
        ),
      ),
    );
  }

  Widget infoTitle() {
    return Container(
      decoration: BoxDecoration(
        color: ThemeData().primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(widget.topBorderRadius),
          topRight: Radius.circular(widget.topBorderRadius),
        ),
      ),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          widget.title,
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}