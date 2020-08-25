import 'package:flutter/material.dart';
import 'package:garantix_flutter/Constants.dart';
import 'package:garantix_flutter/Pages/AuthPages/SplashPage.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class LoadingPage extends StatefulWidget {
  static String id = "LoadingPage";

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  void loadingData() async {
    await Future.delayed(Duration(seconds: 2));
    kReplaceRoute(SplashPage(), context);
  }

  @override
  void initState() {
    loadingData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Shimmer(
        duration: Duration(seconds: 2),
        enabled: true,
        color: Colors.white.withOpacity(0.2),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/logo_entier.png",
                height: mediaSize.width / 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
