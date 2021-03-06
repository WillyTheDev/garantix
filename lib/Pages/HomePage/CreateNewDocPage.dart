import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:garantix_flutter/Constants.dart';
import 'package:garantix_flutter/Providers/UserProvider.dart';
import 'package:garantix_flutter/Widgets/AddImageWidget.dart';
import 'package:garantix_flutter/Widgets/HanldeImageFunctions.dart';
import 'package:garantix_flutter/main.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CreateNewDocPage extends StatefulWidget {
  @override
  _CreateNewDocPageState createState() => _CreateNewDocPageState();
}

class _CreateNewDocPageState extends State<CreateNewDocPage> {
  bool docNameValid = true;
  String docName = "";
  File productImage;
  File productBill;
  File warrentyTicket;
  File personalNotes;
  bool _isLoading = false;
  DateTime dateTime = DateTime.now().add(Duration(days: 365 * 2));
  String post_id = Uuid().v4();

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
                      "Select Image",
                      style: TextStyle(fontSize: 25),
                    ).tr(),
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


  _handleSaveDoc(UserProvider provider) async {
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
          .setData({
        "productName": docName,
        "productId": this.post_id,
        "productImage": productImage,
        "productBill": productBill,
        "warrentyBill": warrentyTicket,
        "personalNotes": personalNotes,
        "timestamp": Timestamp.now(),
        "expiredate": dateTime,
      });
      int notificationsDays = dateTime.difference(DateTime.now()).inDays - 10 ;
      await provider.refetchUserdata();
      var scheduledNotificationDateTime =
      DateTime.now().add(Duration(days: notificationsDays));
      var androidPlatformChannelSpecifics =
      AndroidNotificationDetails('your other channel id',
          'your other channel name', 'your other channel description');
      var iOSPlatformChannelSpecifics =
      IOSNotificationDetails();
      NotificationDetails platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.schedule(
          0,
          '$docName',
          'Votre Garantie arrive bientôt à éxpiration 📆',
          scheduledNotificationDateTime,
          platformChannelSpecifics);
      Toast.show("Sucessfully uploaded!".tr(), context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    } catch (error) {
      Toast.show("Unexpected Error occured", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context);
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
            "Add Document",
            style: TextStyle(color: Colors.black),
          ).tr(),
          backgroundColor: Colors.white,

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
                SizedBox(height: 10),
                kWrapChild(
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        docName = value;
                      });
                    },
                    decoration:
                        InputDecoration(hintText: "Add the product name".tr()),
                  ),
                  "Product Name".tr(),
                ),
                kWrapChild(
                    AddImageWiget(
                        file: productImage,
                        onClose: () => hanldeClose("a"),
                        onTap: () => kSelectImage(context, provider, "a")),
                    "Product Image".tr()),
                kWrapChild(
                    AddImageWiget(
                        file: productBill,
                        onClose: () => hanldeClose("b"),
                        onTap: () => kSelectImage(context, provider, "b")),
                    "Product Bill".tr()),
                kWrapChild(
                    AddImageWiget(
                        file: warrentyTicket,
                        onClose: () => hanldeClose("c"),
                        onTap: () => kSelectImage(context, provider, "c")),
                    "Warrenty Ticket".tr()),
                kWrapChild(
                    AddImageWiget(
                        file: personalNotes,
                        onClose: () => hanldeClose("d"),
                        onTap: () => kSelectImage(context, provider, "d")),
                    "Personal Notes".tr()),
                kWrapChild(pickDate(), "Expire Date".tr()),
                GestureDetector(
                  onTap: this.docName == ""
                      ? null
                      : () => _handleSaveDoc(provider),
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
