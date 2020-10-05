import 'package:flutter/material.dart';

class PageHeader extends StatelessWidget {
  final title;
  final subtitle;

  const PageHeader(this.title, {Key key, this.subtitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 56,
              color: Theme.of(context).colorScheme.primary
            ),
          ),
        ],
      ),
    );
  }
}
