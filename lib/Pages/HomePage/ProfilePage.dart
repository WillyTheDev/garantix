import 'package:flutter/material.dart';
import 'package:garantix_flutter/Constants.dart';
import 'package:garantix_flutter/Providers/AuthProvider.dart';
import 'package:garantix_flutter/Providers/UserProvider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  _profileItem(String label) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xFFECECEC),
      ),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            label,
            style: TextStyle(fontSize: 28),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<UserProvider>(context, listen: false);
    var auth = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Center(
          child: ListView(
            children: [
              SizedBox(height: 40),
              CircleAvatar(
                radius: 85,
                backgroundColor: Colors.black.withOpacity(0.3),
                child: CircleAvatar(
                  radius: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: Image.asset("images/about.png"),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  provider.user.username,
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Center(
                child: Text(
                  provider.user.email,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(height: 10),
              _profileItem("Verson 1.0.1"),
              _profileItem(
                  "Saved Products ${provider.user.savedDocs.documents.length}"),
              GestureDetector(
                onTap: () => auth.logoutUser(context),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: kPrimaryColor,
                  ),
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        "Logout",
                        style: TextStyle(fontSize: 28, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
