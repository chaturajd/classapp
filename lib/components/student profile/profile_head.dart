import 'package:flutter/material.dart';

class ProfileHead extends StatelessWidget {
  final name;
  final school;
  final grade;
  

  ProfileHead(this.name,{Key key, this.school, this.grade}) : super(key: key);

  final nameStyle = TextStyle(fontSize: 56, color: Colors.blue);
  final subStyle = TextStyle(fontSize: 16, color: Colors.black38);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: CircleAvatar(
          //     minRadius: 30,
          //     backgroundColor: Theme.of(context).colorScheme.primary,
          //     child: Text(
          //       "J",
          //       style: TextStyle(
          //         // fontFamily: 'cassette',
          //         fontSize: 26,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: nameStyle,
                ),
                
                if (school != null) 
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    school,
                    style: subStyle,
                  ),
                ),

                if(grade !=null)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    grade,
                    style: subStyle,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
