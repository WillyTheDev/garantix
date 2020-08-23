import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garantix_flutter/Constants.dart';
import 'package:garantix_flutter/Widgets/UserAuthWidget.dart';

class ForgotPassPage extends StatefulWidget {
  @override
  _ForgotPassPageState createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();

  bool emailValid = true;
  String email = "";
  bool _isLoading = false;

  inputField(lable, IconData icon, validate, isValid,
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
          errorText: isValid ? null : "Please enter a valid $lable",
          border: new OutlineInputBorder(),
          prefixIcon: Icon(
            icon,
            color: kPrimaryColor,
          ),
        ),
        keyboardType: keyboard,
      ),
    );
  }

  mailValidate(value) {
    setState(() {
      emailValid = false;
    });
    email = value.trim();
    if (email.length > 3 && email.contains("@")) {
      setState(() {
        emailValid = true;
      });
    }
  }

  handleSendLink() async {
    if (emailValid) {
      setState(() {
        _isLoading = true;
      });
      await UserAuthWidget.forgotPassword(email, _scaffoldKey);

      setState(() {
        _isLoading = false;
      });
    }
  }

  buttonContainer(label) {
    return _isLoading
        ? Center(child: kShowCircularProgressIndicator())
        : GestureDetector(
            onTap: () => handleSendLink(),
            child: Center(
              child: Container(
                height: 60,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: kPrimaryColor,
                ),
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: kThemeColor,
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black45,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      key: _scaffoldKey,
      body: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100),
            Text(
              "Forgot Password?",
              style: TextStyle(
                letterSpacing: 1.2,
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 35,
              ),
            ),
            Text(
              "Please enter your email. We'll send link to your email",
              style: TextStyle(
                color: Colors.black.withOpacity(0.4),
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 30),
            inputField("Email", Icons.email, mailValidate, emailValid),
            buttonContainer("Send Link"),
          ],
        ),
      ),
    );
  }
}
