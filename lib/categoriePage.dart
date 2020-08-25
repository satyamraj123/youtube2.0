import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'CategoriesModel.dart';
import 'CategoryItem.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
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
                    if (data.isSearch == false)
                      Provider.of<CategoriesList>(context)
                          .getNewTrendingVideos(context);
                    else
                      Provider.of<CategoriesList>(context)
                          .getNewVideos(context);
                  }
                  return false;
                },
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 10, top: 10),
                    itemCount: data.items.length,
                    itemBuilder: (ctx, i) => CategoryItem(data, i)),
              ),
      ),
    );
  }
}
