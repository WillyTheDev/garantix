import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:garantix_flutter/Constants.dart';
import 'package:garantix_flutter/Models/Product.dart';
import 'package:garantix_flutter/Providers/UserProvider.dart';
import 'package:garantix_flutter/Widgets/AddImageWidget.dart';
import 'package:garantix_flutter/Widgets/HanldeImageFunctions.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uuid/uuid.dart';

class EditDocPage extends StatefulWidget {
  final Product product;
  EditDocPage({this.product});

  @override
  _CreateNewDocPageState createState() => _CreateNewDocPageState();
}

class _CreateNewDocPageState extends State<EditDocPage> {
  bool docNameValid = true;
  String docName = "";
  File productImage;
  File productBill;
  File warrentyTicket;
  File personalNotes;
  bool _isLoading = false;
  DateTime dateTime;
  String post_id;

  @override
  void initState() {
    super.initState();
    docName = widget.product.productName;
    dateTime = DateTime.fromMicrosecondsSinceEpoch(
      widget.product.expiredate.microsecondsSinceEpoch,
    );
    post_id = widget.product.productId;
  }

  docNameValidate(value) {
    setState(() {
      docNameValid = false;
    });
    docName = value.trim();
    if (docName.length >= 3) {
      setState(() {
        docNameValid = true;
      });
    }
  }

  List months = [
    "jan".tr(),
    "feb".tr(),
    "mar".tr(),
    "apr".tr(),
    "may".tr(),
    "jun".tr(),
    "jul".tr(),
    "aug".tr(),
    "sep".tr(),
    "oct".tr(),
    "nov".tr(),
    "dec".tr()
  ];

  _dateBlock(String label) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: EdgeInsets.only(right: 10),
        child: Column(
          children: [
            Container(height: 2, width: 70, color: kPrimaryColor),
            SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            SizedBox(height: 5),
            Container(height: 2, width: 70, color: kPrimaryColor),
          ],
        ),
      ),
    );
  }

  pickDate() {
    return GestureDetector(
      onTap: () {
        showDatePicker(
          context: context,
          initialDate: dateTime,
          firstDate: DateTime(2000),
          lastDate: DateTime(3000),
        ).then((value) {
          if (value == null) return;
          setState(() {
            dateTime = value;
          });
        });
      },
      child: Container(
        margin: EdgeInsets.only(top: 30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Row(
                    children: [
                      _dateBlock("${dateTime.day}"),
                      _dateBlock("${months[dateTime.month - 1]}".toUpperCase()),
                      _dateBlock("${dateTime.year}"),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              "Tap to change".tr(),
              style: TextStyle(color: kPrimaryColor, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  handleSetStateFile(String label, File file) {
    if (label == "a") {
      productImage = file;
    } else if (label == "b") {
      productBill = file;
    } else if (label == "c") {
      warrentyTicket = file;
    } else if (label == "d") {
      personalNotes = file;
    }
    setState(() {});
  }

  hanldeClose(String label) {
    if (label == "a") {
      productImage = null;
    } else if (label == "b") {
      productBill = null;
    } else if (label == "c") {
      warrentyTicket = null;
    } else if (label == "d") {
      personalNotes = null;
    }
    setState(() {});
  }

  kSelectImage(parentContext, UserProvider provider, String label) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return Container(
          child: SimpleDialog(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      "Select Image".tr(),
                      style: TextStyle(fontSize: 25),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            File file = await handleChooseFromGallary(
                                context, provider);
                            handleSetStateFile(label, file);
                          },
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.photo_library,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            File file =
                                await handleTakePhoto(context, provider);
                            handleSetStateFile(label, file);
                          },
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.photo_camera_outlined,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _showImage(url, String doc) {
    return Stack(
      overflow: Overflow.visible,
      children: [
        Container(
          margin: EdgeInsets.all(10),
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.purpleAccent,
          ),
          child: ClipRRect(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: url,
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
        ),
        Positioned(
          right: -10,
          top: -15,
          child: GestureDetector(
            onTap: () => _hanldeShowDialogBox(
                "Do you want to delete this file peremenently?".tr(),
                () => _handleDeleteImage(url, doc)),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.transparent,
              child: CircleAvatar(
                backgroundColor: kPrimaryColor,
                radius: 15,
                child: Center(
                  child: Icon(Icons.close, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _hanldeShowDialogBox(String label, Function fun) {
    return showDialog(
      context: context,
      child: SimpleDialog(children: [
        Container(
          margin: EdgeInsets.all(20),
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      fun();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 40,
                        width: 80,
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            "Yes".tr(),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 40,
                        width: 80,
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            "No".tr(),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }

  _handleUpdateDoc(UserProvider provider) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String productImage;
      String productBill;
      String warrentyTicket;
      String personalNotes;

      if (this.productImage != null) {
        productImage =
            await uploadImage(this.productImage, this.post_id, "photo");
      }
      if (this.productBill != null) {
        productBill = await uploadImage(this.productBill, this.post_id, "bill");
      }
      if (this.warrentyTicket != null) {
        warrentyTicket =
            await uploadImage(this.warrentyTicket, this.post_id, "ticket");
      }
      if (this.personalNotes != null) {
        personalNotes =
            await uploadImage(this.personalNotes, this.post_id, "notes");
      }
      await Firestore.instance
          .collection("users")
          .document(provider.user.uid)
          .collection("savedDocs")
          .document(post_id)
          .updateData({
        "productName": docName,
        "productId": this.post_id,
        "productImage":
            productImage == null ? widget.product.productImage : productImage,
        "productBill":
            productBill == null ? widget.product.productBill : productBill,
        "warrentyBill": warrentyTicket == null
            ? widget.product.warrentyTicket
            : warrentyTicket,
        "personalNotes": personalNotes == null
            ? widget.product.personalNotes
            : personalNotes,
        "expiredate": dateTime,
      });

      await provider.refetchUserdata();

      Toast.show("Sucessfully uploaded!", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    } catch (error) {
      Toast.show("Unexpected Error occured", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context);
    Navigator.pop(context);
  }

  _deletePic(String url) async {
    StorageReference reference =
        await FirebaseStorage.instance.getReferenceFromUrl(url);
    await reference.delete();
  }

  _hanldeDeleteWholeDoc() async {
    setState(() {
      _isLoading = true;
    });
    var provider = Provider.of<UserProvider>(context, listen: false);
    if (widget.product.productImage != null) {
      productImage = await _deletePic(widget.product.productImage);
    }
    if (widget.product.productBill != null) {
      productBill = await _deletePic(widget.product.productBill);
    }
    if (widget.product.warrentyTicket != null) {
      warrentyTicket = await _deletePic(widget.product.warrentyTicket);
    }
    if (widget.product.personalNotes != null) {
      personalNotes = await _deletePic(widget.product.personalNotes);
    }
    await Firestore.instance
        .document(
            "users/${provider.user.uid}/savedDocs/${widget.product.productId}")
        .delete();
    await provider.refetchUserdata();

    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context);
    Navigator.pop(context);
    Toast.show("Sucessfully deleted!", context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
  }

  _handleDeleteImage(String url, String doc) async {
    setState(() {
      _isLoading = true;
    });
    try {
      StorageReference path =
          await FirebaseStorage.instance.getReferenceFromUrl(url);
      await FirebaseStorage.instance.ref().child(await path.getName()).delete();
      var provider = Provider.of<UserProvider>(context, listen: false);
      await Firestore.instance
          .document(
              "users/${provider.user.uid}/savedDocs/${widget.product.productId}")
          .updateData({
        doc.toString(): null,
      });
      await provider.refetchUserdata();
      if (doc == "productImage") {
        widget.product.productImage = null;
      } else if (doc == "productBill") {
        widget.product.productBill = null;
      } else if (doc == "warrentyBill") {
        widget.product.warrentyTicket = null;
      } else {
        widget.product.personalNotes = null;
      }
      Toast.show("Sucessfully updated!", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    } catch (e) {
      print(e.message);

      Toast.show("Unexpected Error occured", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserProvider>(context);
    return LoadingOverlay(
      isLoading: _isLoading,
      progressIndicator: SpinKitPouringHourglass(color: kPrimaryColor),
      color: Colors.black,
      opacity: 0.7,
      child: Scaffold(
        backgroundColor: Color(0xFFECECEC),
        appBar: AppBar(
          elevation: 0,
          title: Text(
            "Edit Product".tr(),
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          actions: [
            IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  size: 30,
                  color: kPrimaryColor,
                ),
                onPressed: () => _hanldeShowDialogBox(
                    "Do you want to delete the entire Document?".tr(),
                    _hanldeDeleteWholeDoc)),
          ],
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () => Navigator.pop(context)),
          // actions: [
          //   IconButton(
          //     onPressed: () {},
          //     icon: Icon(Icons.close),
          //     color: Colors.black,
          //   )
          // ],
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 30),
                SizedBox(height: 10),
                kWrapChild(
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        docName = value;
                      });
                    },
                    controller: TextEditingController()..text = docName,
                    decoration: InputDecoration(
                      hintText: "Add the product name".tr(),
                    ),
                  ),
                  "Product Name".tr(),
                ),
                kWrapChild(
                    widget.product.productImage != null
                        ? _showImage(
                            widget.product.productImage, "productImage")
                        : AddImageWiget(
                            file: productImage,
                            onClose: () => hanldeClose("a"),
                            onTap: () => kSelectImage(context, provider, "a")),
                    "Product Image".tr()),
                kWrapChild(
                    widget.product.productBill != null
                        ? _showImage(widget.product.productBill, "productBill")
                        : AddImageWiget(
                            file: productBill,
                            onClose: () => hanldeClose("b"),
                            onTap: () => kSelectImage(context, provider, "b")),
                    "Product Bill".tr()),
                kWrapChild(
                    widget.product.warrentyTicket != null
                        ? _showImage(
                            widget.product.warrentyTicket, "warrentyBill")
                        : AddImageWiget(
                            file: warrentyTicket,
                            onClose: () => hanldeClose("c"),
                            onTap: () => kSelectImage(context, provider, "c")),
                    "Warrenty Ticket".tr()),
                kWrapChild(
                    widget.product.personalNotes != null
                        ? _showImage(
                            widget.product.personalNotes, "personalNotes")
                        : AddImageWiget(
                            file: personalNotes,
                            onClose: () => hanldeClose("d"),
                            onTap: () => kSelectImage(context, provider, "d")),
                    "Personal Notes".tr()),
                kWrapChild(pickDate(), "Expire Date".tr()),
                GestureDetector(
                  onTap: this.docName == ""
                      ? null
                      : () => _handleUpdateDoc(provider),
                  child: Container(
                    decoration: BoxDecoration(
                      color: this.docName == ""
                          ? kPrimaryColor.withOpacity(0.4)
                          : kPrimaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    height: 60,
                    width: 150,
                    child: Center(
                      child: Text(
                        "Upload".tr(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
