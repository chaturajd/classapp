import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  // final IconData icon;
  final String title;
  final String imageLink;

  const MenuItem(this.title, {Key key, this.imageLink = "images/paper.png"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 80,
            width: 130,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
                image: DecorationImage(
                  fit: BoxFit.fitHeight,
                  image: AssetImage(imageLink),
                )),
          ),
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 24
            ),
          )
        ],
      ),
    );
  }
}
