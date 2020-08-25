import 'package:firebase_auth/firebase_auth.dart';
import 'AuthScreen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'HomePage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
/*   var _isnit = true;
  var isLoading = false;
  var _isLogin = false;
  var prefs;
  @override
  void initState() {
    Timer _timer;

    _timer = Timer(const Duration(seconds: 5), () {});
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    if (_isnit) {
      setState(() {
        isLoading = true;
      });
      prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('userAuth')) {
        _isLogin = true;
      } else {
        _isLogin = false;
      }
    }
    setState(() {
      isLoading = false;
    });
    if (_isLogin) {
      Future.delayed(Duration(seconds: 2), () {
        !isLoading
            ? Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => HomePage()))
            : null;
      });
    } else {
      Future.delayed(Duration(seconds: 2), () {
        !isLoading
            ? Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => LoginPage()))
            : null;
      });
    }
    _isnit = false;
    super.didChangeDependencies();
  } */
  void _goto() {
    Widget _screen = StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (ctx, userSnapshot) {
          if (userSnapshot.hasData) {
            return HomePage();
          } else {
            return AuthScreen();
          }
        });
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (ctx) => _screen));
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), _goto);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 300,
          ),
          Container(
            height: 200,
            width: 200,
            child: Image.network(
              "https://upload.wikimedia.org/wikipedia/commons/a/ac/Logo_youtube_ios_%28cropped%29.jpg",
              fit: BoxFit.fill,
              filterQuality: FilterQuality.low,
            ),
          ),
          SizedBox(height: 20),
          CircularProgressIndicator(),
        ],
      ),
    ));
  }
}
