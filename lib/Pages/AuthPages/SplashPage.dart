import 'package:flutter/material.dart';
import 'package:garantix_flutter/Pages/AuthPages/LoginPage.dart';
import 'package:garantix_flutter/Providers/AuthProvider.dart';
import 'package:garantix_flutter/Widgets/LoadingWidget.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    var provider = Provider.of<AuthProvider>(context, listen: false);
    provider.loadIsAuth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Consumer<AuthProvider>(builder: (context, myModel, child) {
        return myModel.isAuth == null || myModel.isAuth == false
            ? LoginPage()
            : LoadingWidget();
      }),
    );
  }
}
