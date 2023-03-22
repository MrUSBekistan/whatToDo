import 'package:flutter/material.dart';

class TaskCardWidget extends StatelessWidget {
  final String? title, desc;
  TaskCardWidget({this.title, this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 28.0,
        horizontal: 24.0,
      ),
      margin: EdgeInsets.only(
        bottom: 20.0
      ),
      decoration: BoxDecoration(
          color: Color(0xFFC9E9F0),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? "(Aufgabe benötigt, Sir.)",
            style: TextStyle(
              color: Color(0xFF000000),
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 10.0,
            ),
            child: Text(
              desc ?? "Wir benötigen eine Beschreibung, Mylord!",
              style: TextStyle(
                fontSize: 16.0,
                color: Color(0xFF000000),
                height: 1.5,
              ),
            ),
          )
        ],
      )
    );
  }
}

class TodoWidget extends StatelessWidget {
  final String? text;
  final bool isDone;
  TodoWidget({this.text, required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 8.0,
      ),
      child: Row(
        children: [
          Container(
            width: 20.0,
            height: 20.0,
            margin: EdgeInsets.only(
              right: 12.0,
            ),
            decoration: BoxDecoration(
              color: isDone ? Color(0xFF7349FE) : Colors.transparent,
              borderRadius: BorderRadius.circular(6.0),
              border: isDone ? null : Border.all(
                color: Color(0xFFC9E9F0),
                width: 1.5,
              )
            ),
            child: Image(
              image: AssetImage("assets/images/check_icon.png"),
            ),
          ),
          Flexible(
            child: Text(
              text ?? "(Unbenannte Aufgabe)",
              style: TextStyle(
                color: isDone ? Color(0xFF211551) : Color(0xFFC9E9F0),
                fontSize: 16.0,
                fontWeight: isDone ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NoGlowBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection){
    return child;
  }
}