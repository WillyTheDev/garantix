import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:show_up_animation/show_up_animation.dart';

class ItemPage extends StatefulWidget {
  static String id = "AdditionnalPage4";

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
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
      backgroundColor: Color(0xFFECECEC),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          "Ultimate Ears Boom 3 - Lagoon Blue",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        children: [
          ShowUpList(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: mediaSize.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                      child: Image.network("https://picsum.photos/300/300")),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: mediaSize.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Documents associés :",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      // ShowUpList(children: [
                      //   HomeItem(),
                      //   HomeItem(),
                      //   HomeItem(),
                      // ])
                    ],
                  )),
                ),
              ),
            )
          ])
        ],
      ),
    );
  }
}
