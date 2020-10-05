import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final Function action;
  const Button({Key key, this.action, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => (action()),
      child: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4, right: 4),
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[300],
                    offset: Offset(2, 2),
                    blurRadius: 2)
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 12),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                text != null ? text : "Button",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
