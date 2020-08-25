import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'CategoriesModel.dart';
import 'splashscreen.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => CategoriesList(), child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: CategoriesList()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            fontFamily: "CM",
            backgroundColor: Color.fromRGBO(89, 89, 89, 0),
            primaryColor: Colors.red,
            accentColor: Colors.greenAccent,
            bottomAppBarColor: Colors.green,
            bottomAppBarTheme: BottomAppBarTheme(color: Colors.green)),
        home: SplashScreen(),
      ),
    );
  }
}
