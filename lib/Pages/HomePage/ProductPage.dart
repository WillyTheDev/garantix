import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:garantix_flutter/Constants.dart';
import 'package:garantix_flutter/Models/Product.dart';
import 'package:garantix_flutter/Pages/HomePage/EditDocPage.dart';
import 'package:garantix_flutter/Pages/HomePage/FullImagePage.dart';
import 'package:garantix_flutter/Providers/UserProvider.dart';
import 'package:garantix_flutter/Widgets/HomeItemWidget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class ProductPage extends StatefulWidget {
  final Product product;
  ProductPage({this.product});
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final List months = [
    "jan",
    "feb",
    "mar",
    "apr",
    "may",
    "jun",
    "jul",
    "aug",
    "sep",
    "oct",
    "nov",
    "dec"
  ];

  _noImage() {
    return Container(
      margin: EdgeInsets.all(10),
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.purpleAccent,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 6,
          )
        ],
      ),
      child: Center(
        child: Icon(
          Icons.file_copy_outlined,
          color: Colors.white,
          size: 80,
        ),
      ),
    );
  }

  _fullImage(url, String label) {
    if (url == null) {
      Toast.show("No Image", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      return;
    }
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.downToUp,
        child: FullImagePage(
          url: url,
          id: widget.product.productId,
          label: label,
        ),
      ),
    );
  }

  _showImage() {
    return Container(
      margin: EdgeInsets.all(10),
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.purpleAccent,
      ),
      child: ClipRRect(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: widget.product.productImage,
            placeholder: (context, url) {
              return Center(
                child: Icon(
                  Icons.file_copy_outlined,
                  color: Colors.white,
                  size: 80,
                ),
              );
            },
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  _imageView() {
    DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(
        widget.product.expiredate.microsecondsSinceEpoch);
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => _fullImage(widget.product.productImage, "photo"),
            child:
                widget.product.productImage == null ? _noImage() : _showImage(),
          ),
          Text(
            widget.product.productName,
            style: TextStyle(
              letterSpacing: 1.2,
              color: Colors.black,
              fontSize: 25,
            ),
          ),
          // kWrapChild(
          //   Container(),
          //   widget.product.productName,
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Expires on",
              ),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "${dateTime.day} ${months[dateTime.month - 1].toString().toUpperCase()} ${dateTime.year}",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Color(0xFFECECEC),
      floatingActionButton: new FloatingActionButton(
          elevation: 0.0,
          child: new Icon(Icons.edit),
          backgroundColor: kPrimaryColor,
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.downToUp,
                child: EditDocPage(
                  product: widget.product,
                ),
              ),
            );
          }),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.product.productName,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _imageView(),
            HomeItem(
              label: "Product Bill",
              onTap: () => _fullImage(widget.product.productBill, "bill"),
            ),
            HomeItem(
              label: "Warrenty Ticket",
              onTap: () => _fullImage(widget.product.warrentyTicket, "notes"),
            ),
            HomeItem(
              label: "Personal Notes",
              onTap: () => _fullImage(widget.product.personalNotes, "tickets"),
            ),
          ],
        ),
      ),
    );
  }
}
