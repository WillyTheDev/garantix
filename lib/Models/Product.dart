import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  Product();
  String productName;
  String productImage;
  String productBill;
  String productId;
  String warrentyTicket;
  String personalNotes;
  Timestamp expiredate;

  factory Product.formJson(json) {
    Product product = Product();
    product.productName = json['productName'];
    product.productImage = json['productImage'];
    product.productBill = json['productBill'];
    product.warrentyTicket = json['warrentyBill'];
    product.personalNotes = json['personalNotes'];
    product.expiredate = json['expiredate'];
    product.productId = json['productId'];

    return product;
  }
}
