import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garantix_flutter/Models/Product.dart';
import 'package:garantix_flutter/Providers/UserProvider.dart';
import 'package:garantix_flutter/Widgets/ListCardWIdget.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class ListViewPage extends StatefulWidget {
  @override
  _ListViewPageState createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserProvider>(context);
    QuerySnapshot snapshot = provider.user.savedDocs;

    return Scaffold(
      backgroundColor: Color(0xFFECECEC),
      body: snapshot.documents.length == 0
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    size: 80,
                    color: Colors.black38,
                  ),
                  Text(
                    "Upload Products",
                    style: TextStyle(color: Colors.black38, fontSize: 30),
                  ).tr()
                ],
              ),
            )
          : ListView.builder(
              itemCount: snapshot.documents.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) return SizedBox(height: 30);
                return ListCardWidget(
                    product:
                        Product.formJson(snapshot.documents[index - 1].data));
              },
            ),
      // body: Text(snapshot.toString()),
    );
  }
}
