import 'package:flutter/material.dart';
import 'categoriePage.dart';
import 'TrendingPage.dart';
import 'profilePage.dart';
import 'ChannelPage.dart';
import 'CategoriesModel.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _controller = TextEditingController();
  FocusNode node = FocusNode(canRequestFocus: true);
  String search = "";
  int _currentindex = 0;

  final List<Widget> pages = [
    CategoriesPage(),
    TrendingPage(),
    TrendingPage(),
    ProfilePage()
  ];

  void changePage(int index) {
    setState(() {
      _currentindex = index;
    });
    if (index == 1) {
      Provider.of<CategoriesList>(context).getTrendingVideos(context);
      _isSearching = false;
    } else if (index == 0) {
      _isSearching = false;
      if (search != "" || search != null)
        Provider.of<CategoriesList>(context).getVideos(context, search);
      else
        Provider.of<CategoriesList>(context).getTrendingVideos(context);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    node.dispose();
    super.dispose();
  }

  var _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentindex == 3
          ? AppBar(
              backgroundColor: Colors.white,
              title: Text(
                "YouTube",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
              leading: GestureDetector(
                onTap: () {
                  setState(() {
                    _currentindex = 0;
                  });
                },
                child: Container(
                  color: Colors.black,
                  child: Image.network(
                    "https://upload.wikimedia.org/wikipedia/commons/a/ac/Logo_youtube_ios_%28cropped%29.jpg",
                    fit: BoxFit.none,
                    filterQuality: FilterQuality.low,
                    cacheHeight: 80,
                    cacheWidth: 80,
                  ),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text("Log Out ?"),
                        content: Text(
                            'Your Authentication Details will be deleted.',
                            style: TextStyle(color: Colors.black)),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                          ),
                          FlatButton(
                            child: Text(
                              'Okay',
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              FirebaseAuth.instance.signOut();
                              setState(() {});
                            },
                          )
                        ],
                      ),
                    );
                  },
                  child: Icon(Icons.exit_to_app),
                )
              ],
            )
          : AppBar(
              backgroundColor: Colors.white,
              title: Container(
                child: _isSearching == false
                    ? GestureDetector(
                        onTap: () async {
                          setState(() {
                            _isSearching = true;
                          });
                          await Future.delayed(Duration(milliseconds: 50));
                          FocusScope.of(context).requestFocus(node);
                        },
                        child: Text(
                          "YouTube",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      )
                    : WillPopScope(
                        onWillPop: () async {
                          _isSearching = false;
                          return true;
                        },
                        child: TextField(
                          controller: _controller,
                          focusNode: node,
                          onTap: () {
                            setState(() {
                              _isSearching = true;
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              search = value;
                            });
                          },
                          onSubmitted: (value) {
                            setState(() {
                              _isSearching = false;
                            });
                            if (value != "" && value != null)
                              Provider.of<CategoriesList>(context)
                                  .getVideos(context, search);
                          },
                          decoration: InputDecoration(
                              enabled: true,
                              hintText: "Search",
                              disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.white,
                                width: 3.5,
                              )),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.white,
                                width: 3.5,
                              )),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.white,
                                width: 3.5,
                              )),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.white,
                                width: 3.5,
                              )),
                              hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
              ),
              leading: _isSearching
                  ? null
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentindex = 0;
                        });
                      },
                      child: Container(
                        color: Colors.black,
                        child: Image.network(
                          "https://upload.wikimedia.org/wikipedia/commons/a/ac/Logo_youtube_ios_%28cropped%29.jpg",
                          fit: BoxFit.none,
                          filterQuality: FilterQuality.low,
                          cacheHeight: 80,
                          cacheWidth: 80,
                        ),
                      ),
                    ),
              actions: <Widget>[
                _isSearching == false
                    ? RaisedButton(
                        child: Icon(Icons.search),
                        onPressed: () async {
                          setState(() {
                            _isSearching = true;
                          });
                          await Future.delayed(Duration(milliseconds: 50));
                          FocusScope.of(context).requestFocus(node);
                        },
                      )
                    : FlatButton(
                        child: Icon(Icons.search),
                        onPressed: () async {
                          //print("ok");
                          FocusScope.of(context).unfocus();
                          setState(() {
                            _isSearching = false;
                          });

                          await Provider.of<CategoriesList>(context)
                              .getVideos(context, search);
                        },
                      )
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.green,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.black,
          currentIndex: _currentindex,
          onTap: changePage,
          items: [
            BottomNavigationBarItem(
                backgroundColor: Colors.red,
                title: Text(""),
                icon: Icon(Icons.home)),
            BottomNavigationBarItem(
                backgroundColor: Colors.red,
                title: Text(""),
                icon: Icon(Icons.trending_up)),
            BottomNavigationBarItem(
                backgroundColor: Colors.red,
                title: Text(""),
                icon: Icon(Icons.live_tv)),
            BottomNavigationBarItem(
                backgroundColor: Colors.red,
                title: Text(""),
                icon: Icon(Icons.account_circle)),
          ]),
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: pages[_currentindex]),
    );
  }
}
