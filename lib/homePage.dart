// import 'package:convex_bottom_bar/convex_bottom_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:garantix_flutter/AdditionalPage.dart';
// import 'package:garantix_flutter/ItemPage.dart';

// import 'package:page_transition/page_transition.dart';
// import 'package:show_up_animation/show_up_animation.dart';

// class HomePage extends StatefulWidget {
//   static String id = "HomePage";

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   String _scanBarcode = 'Unknown';
//   Future<void> scanBarcodeNormal() async {
//     String barcodeScanRes;
//     try {
//       barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
//           "#ff6666", "Cancel", true, ScanMode.BARCODE);
//       print(barcodeScanRes);
//     } on PlatformException {
//       barcodeScanRes = 'Failed to get platform version.';
//     }
//     if (!mounted) return;

//     setState(() {
//       _scanBarcode = barcodeScanRes;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final mediaSize = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Garantix",
//           style: TextStyle(color: Colors.black),
//         ),
//         automaticallyImplyLeading: false,
//         backgroundColor: Color(0xFFECECEC),
//         actions: [
//           IconButton(
//             onPressed: () {},
//             icon: Icon(Icons.more_vert),
//             color: Colors.black,
//           )
//         ],
//       ),
//       backgroundColor: Colors.white,
//       bottomNavigationBar: ConvexAppBar(
//           height: mediaSize.height / 14,
//           style: TabStyle.fixedCircle,
//           backgroundColor: Colors.white,
//           items: [
//             TabItem(
//               icon: Icons.home,
//             ),
//             TabItem(
//               icon: Icons.add,
//             ),
//             TabItem(
//               icon: Icons.person,
//             ),
//           ],
//           initialActiveIndex: 0, //optional, default as 0
//           activeColor: Colors.redAccent,
//           color: Colors.grey,
//           onTap: (int i) {
//             print(i);
//             if (i == 0) {
//               Navigator.push(
//                   context,
//                   PageTransition(
//                       type: PageTransitionType.fade, child: HomePage()));
//             } else if (i == 1) {
//               scanBarcodeNormal();
//             } else if (i == 2) {
//               Navigator.push(
//                   context,
//                   PageTransition(
//                       type: PageTransitionType.fade, child: AdditionalPage1()));
//             }
//           }),
//       body: WillPopScope(
//         onWillPop: () async {
//           SystemChannels.platform.invokeMethod('SystemNavigator.pop');
//           return Future.value(false);
//         },
//         child: ListView(
//           padding: EdgeInsets.all(8.0),
//           children: [
//             ShowUpList(children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   "Mes Appareils",
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontSize: mediaSize.width / 8,
//                       fontWeight: FontWeight.w700),
//                 ),
//               ),
//               HomeItem(),
//               HomeItem(),
//               HomeItem(),
//               HomeItem(),
//               HomeItem(),
//               HomeItem(),
//               HomeItem(),
//               HomeItem(),
//               HomeItem()
//             ])
//           ],
//         ),
//       ),
//     );
//   }
// }

// class HomeItem extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final mediaSize = MediaQuery.of(context).size;
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: GestureDetector(
//         onTap: () {
//           Navigator.push(
//               context,
//               PageTransition(
//                   type: PageTransitionType.downToUp, child: ItemPage()));
//         },
//         child: Container(
//           width: mediaSize.width,
//           height: mediaSize.height / 12,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(5.0),
//               color: Colors.black,
//               boxShadow: [
//                 BoxShadow(
//                     color: Colors.grey[300],
//                     blurRadius: 10.0,
//                     offset: Offset(5, 5))
//               ]),
//           child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                     child: Icon(
//                       Icons.description,
//                       color: Colors.white,
//                     ),
//                   ),
//                   Text(
//                     "Ultimate Ears Boom 3 - Lagoon Blue",
//                     style: TextStyle(color: Colors.white),
//                   )
//                 ],
//               )),
//         ),
//       ),
//     );
//   }
// }
