import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:garantix_flutter/Constants.dart';
import 'package:garantix_flutter/Pages/HomePage/HomePage.dart';
import 'package:garantix_flutter/Providers/UserProvider.dart';
import 'package:provider/provider.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: FutureBuilder(
        future: userProvider.loadUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: SpinKitPouringHourglass(color: Colors.white));
          else {
            return HomePage();
          }
        },
      ),
    );
  }
}
