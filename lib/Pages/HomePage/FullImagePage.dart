import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:garantix_flutter/Widgets/HanldeImageFunctions.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:toast/toast.dart';

class FullImagePage extends StatefulWidget {
  final String url;
  final String id;
  final String label;

  FullImagePage({this.url, this.id, this.label});
  @override
  _FullImagePageState createState() => _FullImagePageState();
}

class _FullImagePageState extends State<FullImagePage> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return LoadingOverlay(
      isLoading: _isLoading,
      progressIndicator: SpinKitPouringHourglass(color: Colors.redAccent),
      color: Colors.black,
      opacity: 0.7,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        floatingActionButton: new FloatingActionButton(
            elevation: 0.0,
            child: new Icon(Icons.save_alt),
            backgroundColor: Colors.redAccent,
            onPressed: () async {
              setState(() {
                _isLoading = true;
              });
              await kSaveImage(widget.url, widget.id, widget.label);
              Toast.show("Image Saved!", context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
              setState(() {
                _isLoading = false;
              });
            }),
        body: Container(
          color: Colors.black,
          width: w,
          height: h,
          child: Center(
            child: CachedNetworkImage(
              placeholder: (context, url) {
                return Center(
                  child: SpinKitPouringHourglass(color: Colors.redAccent),
                );
              },
              imageUrl: widget.url,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
    );
  }
}
