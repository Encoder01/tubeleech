import 'dart:io' as io;
import 'package:ext_storage/ext_storage.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:open_file/open_file.dart';
import 'package:tubeleech/Models/videos.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../main.dart';

class DownController{

  static List<String> filelistname;
  static YoutubePlayerController _controller;
  static bool _isPlayerReady;
  static void openFile(Videos video,BuildContext context){
    OpenFile.open(video.yol).then((value) {
      if(value.type==ResultType.fileNotFound){
        showDialog(
          context: context,
          builder: (contexts) => CupertinoAlertDialog(
            content: Text("müzik bulunamadı listeden kaldırmak istiyor musunuz?",style: TextStyle(fontSize: 18),),
            actions: [
              CupertinoButton(
                  child: Text(
                    "Hayır",
                  ),
                  onPressed: () => Navigator.pop(context)),
              CupertinoButton(
                  child: Text(
                    "Evet",
                    style: TextStyle(fontSize: 16,color: Colors.red),
                  ),
                  onPressed: (){
                    int i =0;
                    Hive.box<Videos>("videos").values.forEach((element) {
                      if(element.id==video.id)
                      {
                        Hive.box<Videos>("videos").deleteAt(i);
                        Navigator.of(context).pop();
                      }
                      i++;
                    });
                  }),
            ],
          ),
        );
      }
    });
  }
  static void deleteFile(Videos video,BuildContext context){
    showDialog(
      context: context,
      builder: (contexts) => CupertinoAlertDialog(
        content: Text("Bu dosya silinecek!, Emin misiniz?",style: TextStyle(fontSize: 18,letterSpacing: 1)),
        actions: [
          CupertinoButton(
              child: Text(
                "Hayır",
              ),
              onPressed: () => Navigator.pop(context)),
          CupertinoButton(
              child: Text(
                "Evet",
                style: TextStyle(fontSize: 16,color: Colors.red),
              ),
              onPressed: () async{
                int i =0;
                Hive.box<Videos>("videos").values.forEach((element)async {
                  if(element.id==video.id+"mp3")
                  {
                    io.File file = io.File(video.yol);
                    await file.delete();
                    Hive.box<Videos>("videos").deleteAt(i);
                    Navigator.of(context).pop();
                  }
                  if(element.id==video.id+"mp4")
                  {
                    io.File file = io.File(video.yol);
                    await file.delete();
                    Hive.box<Videos>("videos").deleteAt(i);
                    Navigator.of(context).pop();
                  }
                  i++;
                });

              }),
        ],
      ),
    );
  }
  static listofFiles() async {
    String directory;
    filelistname=[];
    List<io.FileSystemEntity> file = new List();
    directory = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_MUSIC);
    file = io.Directory(directory).listSync();
    file.forEach((element) {
      if(element.path.split(".").contains("mp3")){
        print(path.basenameWithoutExtension(element.path));
        filelistname.add(element.path);
      }
    });
  }
  static Future<void> showProgressNotification(int progrs, int id, String name, String path,bool downloading) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'progress channel', 'progress channel', 'tubeleech notif channel',
        channelShowBadge: false,
        importance: Importance.high,
        priority: Priority.high,
        onlyAlertOnce: true,
        showProgress: true,
        maxProgress: 100,
        progress: progrs);
    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        id, name, downloading ? "indiriliyor" : "İndirildi", platformChannelSpecifics,
        payload: path);
  }
  static settingModalBottomSheet(context,id){
    _isPlayerReady = false;
    _controller = YoutubePlayerController(

      initialVideoId: id,
      flags: YoutubePlayerFlags(

        mute: false,
        autoPlay: true,
      ),
    )..addListener(_listener);
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: new Wrap(
              children: <Widget>[
                YoutubePlayer(
                  progressIndicatorColor: Colors.red,
                  controller: _controller,
                  showVideoProgressIndicator: true,

                  onReady: () {
                    print('Player is ready.');
                    _isPlayerReady = true;
                  },
                )
              ],
            ),
          );
        }
    );
  }
  static _listener() {
    if (_isPlayerReady  && !_controller.value.isFullScreen) {
      //
    }
  }
}