import 'package:flutter/material.dart';

card(leading,title,subtitle){
  return Card(
    color: Color(0xFF141E2D),
    elevation: 1,
    child: ListTile(
      leading: Icon(Icons.account_box_sharp),
      title: Text("Title"),
      titleTextStyle: TextStyle(
        fontFamily: "Work Sans",
        fontWeight: FontWeight.normal,
        color: Color(0xFFA3AED0),
      ),
      subtitleTextStyle: TextStyle(
        fontFamily: "Work Sans",
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 20,
      ),
      subtitle: Text("Subtitle"),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}