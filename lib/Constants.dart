import 'dart:io';

import 'package:flutter/material.dart';
import 'package:garantix_flutter/Providers/UserProvider.dart';
import 'package:garantix_flutter/Widgets/HanldeImageFunctions.dart';

const kThemeColor = Colors.white;
const kPrimaryColor = Colors.redAccent;

kReplaceRoute(Widget widget, BuildContext context) {
  return Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => widget));
}

kRoute(Widget widget, BuildContext context) {
  return Navigator.push(
      context, MaterialPageRoute(builder: (context) => widget));
}

kShowCircularProgressIndicator() {
  return CircularProgressIndicator(
    valueColor: new AlwaysStoppedAnimation<Color>(kPrimaryColor),
  );
}

kWrapChild(Widget child, String label) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(20),
    margin: EdgeInsets.only(bottom: 20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            letterSpacing: 1.2,
            color: Colors.black,
            fontSize: 25,
          ),
        ),
        child,
      ],
    ),
  );
}

kInputField(lable, IconData icon, validate, isValid,
    {keyboard = TextInputType.text}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 10),
    child: TextField(
      onChanged: validate,
      textAlign: TextAlign.start,
      style: TextStyle(fontSize: 20, color: Colors.black87),
      decoration: InputDecoration(
        labelText: "$lable",
        labelStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
        hintText: "Enter your $lable",
        hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
        errorText: isValid ? null : "min length is 3",
        border: new OutlineInputBorder(),
        prefixIcon: Icon(
          icon,
          color: Colors.black,
        ),
      ),
      keyboardType: keyboard,
    ),
  );
}
