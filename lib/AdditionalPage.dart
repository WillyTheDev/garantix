import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garantix_flutter/Pages/HomePage/HomePage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'ItemPage.dart';
import 'homePage.dart';

class AdditionalPage1 extends StatefulWidget {
  static String id = "AdditionnalPage1";

  @override
  _AdditionalPage1State createState() => _AdditionalPage1State();
}

class _AdditionalPage1State extends State<AdditionalPage1> {
  String _scanBarcode = 'Unknown';
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Garantix",
          style: TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFECECEC),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert),
            color: Colors.black,
          )
        ],
      ),
      bottomNavigationBar: ConvexAppBar(
          height: mediaSize.height / 14,
          style: TabStyle.fixedCircle,
          backgroundColor: Colors.white,
          items: [
            TabItem(
              icon: Icons.home,
            ),
            TabItem(
              icon: Icons.add,
            ),
            TabItem(
              icon: Icons.person,
            ),
          ],
          initialActiveIndex: 2, //optional, default as 0
          activeColor: Colors.redAccent,
          color: Colors.grey,
          onTap: (int i) {
            print(i);
            if (i == 0) {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade, child: HomePage()));
            } else if (i == 1) {
              scanBarcodeNormal();
            } else if (i == 2) {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade, child: AdditionalPage1()));
            }
          }),
      body: ListView(
        children: [
          ShowUpList(children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CircleAvatar(
                maxRadius: mediaSize.width / 5,
                backgroundImage: NetworkImage("https://picsum.photos/200"),
              ),
            ),
            Text(
              "Username",
              style: TextStyle(
                  fontSize: mediaSize.width / 12, fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xFFECECEC),
                ),
                width: mediaSize.width,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                      child: Text(
                    "Version gratuite",
                    style: TextStyle(fontSize: mediaSize.width / 18),
                  )),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xFFECECEC),
                ),
                width: mediaSize.width,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                      child: Text(
                    "Garanties enregistrées 10/15",
                    style: TextStyle(fontSize: mediaSize.width / 18),
                  )),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xFFECECEC),
                ),
                width: mediaSize.width,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                      child: Text(
                    "Option supplémentaire",
                    style: TextStyle(fontSize: mediaSize.width / 18),
                  )),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xFFECECEC),
                ),
                width: mediaSize.width,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                      child: Text(
                    "Options supplémentaire",
                    style: TextStyle(fontSize: mediaSize.width / 18),
                  )),
                ),
              ),
            ),
          ])
        ],
      ),
    );
  }
}
