import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:garantix_flutter/Pages/HomePage/CreateNewDocPage.dart';
import 'package:garantix_flutter/Pages/HomePage/ListViewPage.dart';
import 'package:garantix_flutter/Pages/HomePage/ProfilePage.dart';
import 'package:page_transition/page_transition.dart';

import '../../Constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List pages = [
    ListViewPage(),
    CreateNewDocPage(),
    ProfilePage(),
  ];

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
            width: MediaQuery.of(context).size.width / 3,
            child: Image.asset("assets/images/logo_entier.png")),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBar: ConvexAppBar(
        height: 60,
        top: -15,
        curveSize: 90,
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
        initialActiveIndex: 0, //optional, default as 0
        activeColor: kPrimaryColor,
        color: Colors.grey,
        onTap: (index) {
          setState(() {
            if (index == 1) {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade,
                      child: CreateNewDocPage()));
              return;
            }
            _index = index;
          });
        },
      ),
      body: Center(
        child: pages[_index],
      ),
    );
  }
}
