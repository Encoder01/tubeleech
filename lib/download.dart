

import 'package:audio_manager/audio_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DownItem extends StatefulWidget {

  @override
  _DownItemPageState createState() => _DownItemPageState();
}

class _DownItemPageState extends State<DownItem> {

  bool isPlaying = false;

  num curIndex = 0;

  final list = [
    {
      "title": "Assets",
      "desc": "assets playback",
      "url": "assets/xv.mp3",
      "coverUrl": "assets/ic_launcher.png"
    },
    {
      "title": "network",
      "desc": "network resouce playback",
      "url": "https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.m4a",
      "coverUrl": "https://homepages.cae.wisc.edu/~ece533/images/airplane.png"
    }
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin audio player'),
        ),
        body: Column(children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[


                IconButton(
                  onPressed: () async {
                    AudioManager.instance.updateNtf(true);
                  },
                  padding: const EdgeInsets.all(0.0),
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 48.0,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                    icon: Icon(
                      Icons.stop,
                      color: Colors.black,
                    ),
                    onPressed: () {AudioManager.instance.start("assets/ses/City/araba.m4a", "Mindfocus:Relax",desc:"notif",cover:"assets/logo.jpg");})
              ],
            ),
          ),
        ]),
      ),
    );
  }





}

class AudioMetadata {
  final String album;
  final String title;
  final String artwork;

  AudioMetadata({this.album, this.title, this.artwork});
}