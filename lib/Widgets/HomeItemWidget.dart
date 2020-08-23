import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class HomeItem extends StatelessWidget {
  HomeItem({this.label, this.onTap});

  final String label;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: GestureDetector(
        // onTap: () {
        //   Navigator.push(
        //       context,
        //       PageTransition(
        //           type: PageTransitifitWidthonType.downToUp, child: ItemPage()));
        // },
        onTap: onTap,
        child: Container(
          width: mediaSize.width,
          height: mediaSize.height / 12,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[300],
                    blurRadius: 10.0,
                    offset: Offset(5, 5))
              ]),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Icon(
                      Icons.description,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    label,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
