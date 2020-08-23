import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:garantix_flutter/Models/Product.dart';
import 'package:garantix_flutter/Pages/HomePage/ProductPage.dart';
import 'package:page_transition/page_transition.dart';

class ListCardWidget extends StatelessWidget {
  final Product product;

  ListCardWidget({this.product});

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
      height: 150,
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

  _showImage() {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.purpleAccent,
      ),
      child: ClipRRect(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: product.productImage,
            placeholder: (context, url) {
              return Center(
                child: Icon(
                  Icons.file_copy_outlined,
                  color: Colors.white,
                  size: 80,
                ),
              );
            },
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }

  _exipreCard(BuildContext context) {
    DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(
        product.expiredate.microsecondsSinceEpoch);
    return Container(
      height: 50,
      width: 130,
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Expires on",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          Text(
            "${dateTime.day} ${months[dateTime.month - 1].toString().toUpperCase()} ${dateTime.year}",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(product.productImage);
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child: ProductPage(
                  product: product,
                )));
      },
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 2),
                  blurRadius: 6,
                )
              ],
            ),
            height: 250,
            width: double.infinity,
            child: Column(
              children: [
                product.productImage == null ? _noImage() : _showImage(),
                SizedBox(height: 20),
                Expanded(
                  child: Text(
                    product.productName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 26,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 20,
            top: 30,
            child: _exipreCard(context),
          )
        ],
      ),
    );
  }
}
