import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:garantix_flutter/Providers/UserProvider.dart';
import 'package:garantix_flutter/Widgets/HanldeImageFunctions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class AddImageWiget extends StatelessWidget {
  final File file;
  final Function onTap;
  final Function onClose;

  AddImageWiget({this.file, this.onTap, this.onClose});

  _noImageField(context, provider) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        strokeCap: StrokeCap.round,
        color: Colors.black54,
        strokeWidth: 2,
        dashPattern: [8, 4],
        child: Container(
          height: 100,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_a_photo,
                color: Colors.black45,
              ),
              SizedBox(width: 20),
              Text(
                "Add Image".tr(),
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showImage() {
    return Stack(
      overflow: Overflow.visible,
      children: [
        Container(
          height: 100,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(
              file,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        Positioned(
          right: -4,
          top: -10,
          child: GestureDetector(
            onTap: onClose,
            child: CircleAvatar(
              backgroundColor: Colors.redAccent,
              radius: 15,
              child: Center(
                child: Icon(Icons.close, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserProvider>(context);
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: file == null ? _noImageField(context, provider) : _showImage(),
      ),
    );
  }
}
