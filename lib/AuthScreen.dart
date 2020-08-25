import "package:flutter/material.dart";
import 'dart:io';
import 'package:flutter/services.dart';
import 'AuthForm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isLoading = false;
  var url = '';
  void _submitAuthForm(String email, String name, String password, File image,
      bool isLogin, BuildContext context) async {
    final _auth = FirebaseAuth.instance;
    AuthResult _authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        _authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        _authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(_authResult.user.uid + '.jpg');
        if (image != null) {
          await ref.putFile(image).onComplete;
          url = await ref.getDownloadURL();
        }

        await Firestore.instance
            .collection('users')
            .document(_authResult.user.uid)
            .setData({
          'email': email,
          'imageUrl': url,
          'name': name,
        });
      }
    } on PlatformException catch (e) {
      var message = 'An error occured! Please check your credentials.';
      if (e.message != null) {
        message = e.message;
        setState(() {
          _isLoading = false;
        });
      }
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
    } catch (err) {
      print(err.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              height: 150,
              width: 200,
              child: Image.network(
                "https://upload.wikimedia.org/wikipedia/commons/a/ac/Logo_youtube_ios_%28cropped%29.jpg",
                fit: BoxFit.fill,
                filterQuality: FilterQuality.low,
              ),
            ),
            AuthForm(_submitAuthForm, _isLoading),
          ],
        ),
      ),
    ));
  }
}
