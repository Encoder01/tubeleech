import 'package:flutter/material.dart';
import 'package:tubeleech/Models/channel_info.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'download.dart';


class VideoPlayerScreen extends StatefulWidget {
  //
  VideoPlayerScreen({this.videoItem});
  final Item videoItem;

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  //
  YoutubePlayerController _controller;
  bool _isPlayerReady;

  @override
  void initState() {
    super.initState();
    _isPlayerReady = false;
    _controller = YoutubePlayerController(

      initialVideoId: widget.videoItem.id.videoId,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
      ),
    )..addListener(_listener);
  }

  void _listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      //
    }
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.videoItem.snippet.title),
      ),
      body: Column(
        children: [
          Container(
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,

              onReady: () {
                print('Player is ready.');
                _isPlayerReady = true;
              },
            ),
          ),
          DownItem(),
        ],
      ),
    );
  }
}