import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CategoryItem extends StatefulWidget {
  final data;
  final i;
  CategoryItem(this.data, this.i);
  @override
  _CategoryItemState createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  String _url;

  YoutubePlayerController _controller;
//https://www.youtube.com/watch?v=OLcisxAV4gc
  var _isExpanded = false;
  var _isPlay = false;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
          "https://www.youtube.com/watch?v=" +
              widget.data.items[widget.i].videoId
          //"https://www.youtube.com/watch?v=OLcisxAV4gc"),
          ),
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        loop: true,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200.0,
            child: _isPlay
                ? YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    aspectRatio: 40 / 20,
                  )
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPlay = true;
                      });
                    },
                    child: Card(
                      elevation: 10,
                      child: Image.network(widget.data.items[widget.i].imageUrl,
                          fit: BoxFit.cover),
                    ),
                  ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.all(8.0),
            dense: true,
            title: Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(widget.data.items[widget.i].title),
            ),
            subtitle: Text(""),
            trailing: Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: Icon(Icons.more_vert)),
          ),
        ],
      ),
    );
  }
}
