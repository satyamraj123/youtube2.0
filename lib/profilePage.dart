import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var _isInit = true;
  SharedPreferences prefs;
  var userAuth;
  var uid;
  var _isLoading = false;

  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Future<void> didChangeDependencies() async {
    setState(() {
      _isLoading = true;
    });

    if (_isInit) {
      FirebaseUser user = await auth.currentUser();
      uid = user.uid;
    }
    setState(() {
      _isLoading = false;
    });

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('users').document(uid).snapshots(),
      builder: (ctx, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.data == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 180,
                      child: Center(
                          child: CircleAvatar(
                        backgroundColor: Colors.black,
                        backgroundImage: NetworkImage(_isLoading ||
                                snapshot.data['imageUrl'] == ""
                            ? 'https://discountdoorhardware.ca/wp-content/uploads/2018/06/profile-placeholder-3.jpg'
                            : snapshot.data['imageUrl']),
                        radius: 70,
                      )),
                    ),
                    Text(_isLoading ? '' : snapshot.data['name']),
                    SizedBox(
                      height: 200,
                    ),
                    /*  Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border(
                        bottom: BorderSide(width: 2),
                        left: BorderSide(width: 2),
                        right: BorderSide(width: 2),
                        top: BorderSide(width: 2),
                      )),
                      padding: EdgeInsets.all(20),
                      alignment: Alignment.center,
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(_isLoading ? '' : snapshot.data['email']),
                          Text(_isLoading ? '' : snapshot.data['work']),
                          Text(_isLoading ? '' : snapshot.data['phone']),
                          Text(_isLoading ? '' : snapshot.data['bio']),
                        ],
                      ),
                    ), */
                    //GENRES
                    /*  Container(
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            "Genre",
                            style: TextStyle(fontSize: 30),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                height: 40,
                                width: 120,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.cyan),
                                child: Center(
                                    child: Text(
                                  "Food",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                              Container(
                                height: 40,
                                width: 120,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.cyan),
                                child: Center(
                                    child: Text(
                                  "Meme",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                height: 40,
                                width: 120,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.cyan),
                                child: Center(
                                    child: Text(
                                  "Fitness",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                              Container(
                                height: 40,
                                width: 120,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.cyan),
                                child: Center(
                                    child: Text(
                                  "Beauty",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ), */
                  ],
                ),
    );
  }
}
