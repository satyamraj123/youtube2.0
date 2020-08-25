import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'CategoriesModel.dart';
import 'CategoryItem.dart';

class TrendingPage extends StatefulWidget {
  @override
  _TrendingPageState createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  var _isInit = true;
  @override
  Future<void> didChangeDependencies() async {
    if (_isInit) {
      await Provider.of<CategoriesList>(context).getTrendingVideos(context);
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Consumer<CategoriesList>(
        builder: (ctx, data, _) => data.isLoading
            ? Center(child: CircularProgressIndicator())
            : NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollDetails) {
                  if (!data.isLoadingNext &&
                      scrollDetails.metrics.pixels >=
                          scrollDetails.metrics.maxScrollExtent / 2) {
                    Provider.of<CategoriesList>(context)
                        .getNewTrendingVideos(context);
                  }
                  return false;
                },
                child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 10, top: 10),
                    itemCount: data.items.length,
                    itemBuilder: (ctx, i) => CategoryItem(data, i)),
              ),
      ),
    );
  }
}
