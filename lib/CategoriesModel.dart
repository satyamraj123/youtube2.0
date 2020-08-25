import 'dart:convert';
import 'dart:io';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'showDialog.dart';

class Categories {
  final String title;
  final String videoId;
  final String description;
  final String imageUrl;

  Categories({this.title, this.videoId, this.description, this.imageUrl});
}

class CategoriesList with ChangeNotifier {
  var isLoading = false;
  var isLoadingNext = false;
  var nextPageToken = "";
  var isSearch = false;
  var previousSearch = "";
  List<Categories> _items = [];
  List<Categories> get items {
    return [..._items];
  }

  Future<void> getVideos(BuildContext context, String search) async {
    isLoading = true;
    isSearch = true;
    _items = [];
    print("enterred");
    var data;
    var response;
    previousSearch = search;
    try {
      final url =
          "https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&key=AIzaSyBxu_y7IgKTzyR5FSD9rKHxNEoFoYtOAbk&q=$search";
      response = await http.get(url);
      print(url);
      data = json.decode(response.body);
      if (data.containsKey('error')) {
        print(data['error']['message'].toString());
        showAlertDialog(
            context, "An Error Occured !", data['error']['message'].toString());
      }
    } on PlatformException catch (e) {
      if (e.message != null)
        showAlertDialog(context, "An Error Occured !", e.message);
    } on SocketException {
      showAlertDialog(context, "An Error Occured !", "No Internet Connection");
    }

    if (data['items'] == null) {
      isLoading = true;
      return;
    }
    _items = [];
    nextPageToken = data["nextPageToken"];

    data["items"].forEach((element) {
      _items.add(Categories(
          videoId: element["id"]["videoId"],
          title: element["snippet"]["title"].toString().trim(),
          description: element["snippet"]["description"].toString().trim(),
          imageUrl: element["snippet"]["thumbnails"]["default"]["url"]));
    });

    notifyListeners();
    isLoading = false;
  }

  Future<void> getNewVideos(
    BuildContext context,
  ) async {
    isLoadingNext = true;
    isSearch = true;
    print("enterred");
    var data;
    try {
      final url =
          "https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&key=AIzaSyBxu_y7IgKTzyR5FSD9rKHxNEoFoYtOAbk&q=$previousSearch&pageToken=$nextPageToken";
      final response = await http.get(url);
      print(url);
      data = json.decode(response.body);
      if (data.containsKey('error')) {
        print(data['error']['message'].toString());
        showAlertDialog(
            context, "An Error Occured !", data['error']['message'].toString());
      }
    } on PlatformException catch (e) {
      if (e.message != null)
        showAlertDialog(context, "An Error Occured !", e.message);
    } on SocketException {
      showAlertDialog(context, "An Error Occured !", 'No Internet Connection');
    }

    if (data['items'] == null) {
      isLoadingNext = true;
      return;
    }
    nextPageToken = data["nextPageToken"];
    data["items"].forEach((element) {
      _items.add(Categories(
          videoId: element["id"]["videoId"],
          title: element["snippet"]["title"].toString().trim(),
          description: element["snippet"]["description"].toString().trim(),
          imageUrl: element["snippet"]["thumbnails"]["default"]["url"]));
    });

    notifyListeners();
    isLoadingNext = false;
  }

  Future<void> getTrendingVideos(
    BuildContext context,
  ) async {
    isLoading = true;
    isSearch = false;
    print("enterred");
    var data;
    try {
      final url =
          "https://www.googleapis.com/youtube/v3/videos?part=snippet&type=video&key=AIzaSyBxu_y7IgKTzyR5FSD9rKHxNEoFoYtOAbk&chart=mostPopular&regionCode=US";
      final response = await http.get(url);
      print(url);
      data = json.decode(response.body);
      print(response.body.toString());
      if (data.containsKey('error')) {
        print(data['error']['message'].toString());
        showAlertDialog(
            context, "An Error Occured !", data['error']['message'].toString());
      }
    } on PlatformException catch (e) {
      if (e.message != null)
        showAlertDialog(context, "An Error Occured !", e.message);
    } on SocketException {
      showAlertDialog(context, "An Error Occured !", "No Internet Connection");
    }

    if (data['items'] == null) {
      isLoading = true;
      return;
    }
    _items = [];
    nextPageToken = data["nextPageToken"];
    data["items"].forEach((element) {
      _items.add(Categories(
          videoId: element["id"],
          title: element["snippet"]["title"].toString().trim(),
          description: element["snippet"]["description"].toString().trim(),
          imageUrl: element["snippet"]["thumbnails"]["default"]["url"]));
    });
    _items.shuffle();

    notifyListeners();
    isLoading = false;
  }

  Future<void> getNewTrendingVideos(
    BuildContext context,
  ) async {
    isLoadingNext = true;
    isSearch = false;
    print("enterred");
    var data;
    try {
      final url =
          "https://www.googleapis.com/youtube/v3/videos?part=snippet&type=video&key=AIzaSyBxu_y7IgKTzyR5FSD9rKHxNEoFoYtOAbk&chart=mostPopular&regionCode=US&pageToken=$nextPageToken";
      final response = await http.get(url);
      print(url);
      data = json.decode(response.body);
      if (data.containsKey('error')) {
        print(data['error']['message'].toString());
        showAlertDialog(
            context, "An Error Occured !", data['error']['message'].toString());
      }
    } on PlatformException catch (e) {
      if (e.message != null)
        showAlertDialog(context, "An Error Occured !", e.message);
    } on SocketException {
      showAlertDialog(context, "An Error Occured !", 'No Internet Connection');
    }
    if (data['items'] == null) {
      isLoading = true;
      return;
    }
    nextPageToken = data["nextPageToken"];
    data["items"].forEach((element) {
      _items.add(Categories(
          videoId: element["id"],
          title: element["snippet"]["title"].toString().trim(),
          description: element["snippet"]["description"].toString().trim(),
          imageUrl: element["snippet"]["thumbnails"]["default"]["url"]));
    });

    notifyListeners();
    isLoadingNext = false;
  }
}
