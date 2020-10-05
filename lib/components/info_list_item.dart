import 'package:flutter/material.dart';

class InfoListItem extends StatelessWidget {
  final title;
  final subtitle1;
  final subtitle2;
  final subtitle1Alignment;
  final subtitle2Alignment;

  const InfoListItem(
    this.title, {
    Key key,
    this.subtitle1 ,
    this.subtitle2 ,
    this.subtitle1Alignment = Alignment.centerLeft,
    this.subtitle2Alignment = Alignment.centerLeft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0, right: 16),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w500,
              ),
            ),
            
            if(subtitle1 != null)
            Align(
              alignment: subtitle1Alignment,
              child: Text(subtitle1),
            ),

            if(subtitle2 != null)
            Align(
              alignment: subtitle2Alignment,
              child: Text(
                subtitle2,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.grey[400]
                ),
              ),
            ),
            Divider(
              color: Colors.blue,
            )
          ],
        ),
      ),
    );
  }
}
