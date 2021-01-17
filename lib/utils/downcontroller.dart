import 'dart:io' as io;
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tubeleech/Models/musics.dart';
import 'package:tubeleech/Models/videos.dart';
import 'package:tubeleech/Models/playedvideo.dart';
import 'package:tubeleech/Pages/settings_page.dart';
import 'package:easy_localization/easy_localization.dart';
import '../main.dart';

class DownController {
  static List<String> filelistname;
  static List<PlayedVideo> playedVideo = [];
  static List<Audio> audios = [];
  static AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  final assetsAudioPlayer = AssetsAudioPlayer();

  static void openFile(BuildContext context, {Videos video, Musics music, String tur}) {
    OpenFile.open(tur == "mp3" ? music.yol : video.yol).then((value) {
      if (value.type == ResultType.fileNotFound) {
        _showDialogs(context, video: video, music: music, tur: tur);
      }
    });
  }

  static void getPermiss() async {
    var status = await Permission.storage.request();
    if (status == PermissionStatus.granted)
      return null;
    else {
      status = await Permission.storage.request();
    }
  }

  static bool getIsplay(String id) {
    bool isplay = false;
    DownController.playedVideo.forEach((element) {
      if (element.id == id) {
        isplay = element.isPlay;
      }
    });

    return isplay;
  }

  static bool setIsplay(String id, bool isplay) {
    DownController.playedVideo.forEach((element) {
      if (element.id == id) {
        element.isPlay = isplay;
      }
    });

    return isplay;
  }

  static bool getHaveplay(String id) {
    bool isplay = false;
    DownController.playedVideo.forEach((element) {
      if (element.id == id) {
        isplay = element.havePlay;
      }
    });

    return isplay;
  }

  static bool setHaveplay(String id, bool isplay) {
    DownController.playedVideo.forEach((element) {
      if (element.id == id) {
        element.havePlay = isplay;
      }
    });

    return isplay;
  }

  static _showDialogs(BuildContext context, {Videos video, Musics music, String tur}) {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: Text(
          "remove".tr(),
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          CupertinoButton(
              child: Text(
                "no".tr(),
              ),
              onPressed: () => Navigator.pop(context)),
          CupertinoButton(
              child: Text(
                "yes".tr(),
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
              onPressed: () {
                int i = 0;
                if (tur == "mp3") {
                  Hive.box<Musics>("musics").values.forEach((element) {
                    if (element.id == video.id) {
                      Hive.box<Musics>("musics").deleteAt(i);
                      Navigator.of(context).pop();
                    }
                    i++;
                  });
                } else {
                  Hive.box<Videos>("videos").values.forEach((element) {
                    if (element.id == video.id) {
                      Hive.box<Videos>("videos").deleteAt(i);
                      Navigator.of(context).pop();
                    }
                    i++;
                  });
                }
              }),
        ],
      ),
    );
  }

  static void deleteFile( BuildContext context,{Videos video, Musics music, String tur}) {
    String evet = "delete".tr();
    int z = 0;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setState) {
          return CupertinoAlertDialog(
            content: Text(evet, style: TextStyle(fontSize: 18, letterSpacing: 1)),
            actions: [
              CupertinoButton(
                  child: Text(
                    "no".tr(),
                  ),
                  onPressed: () => Navigator.pop(context)),
              CupertinoButton(
                  child: Text(
                    "yes".tr(),
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                  onPressed: () async {
                    z++;
                    if(tur=="mp4"){
                      for (int i = 0; i < Hive.box<Videos>("videos").values.length; i++) {
                      if (Hive.box<Videos>("videos").getAt(i).id == video.id) {
                        io.File file = io.File(video.yol);
                        bool value = await file.exists();
                        if (value) {
                          Hive.box<Videos>("videos").deleteAt(i);
                          file.delete();
                          Navigator.of(context).pop();
                        } else {
                          evet = "remove".tr();
                          setState(() {});
                        }
                        if (z > 1) {
                          Hive.box<Videos>("videos").deleteAt(i);
                          Navigator.of(context).pop();
                        }
                      }
                    }}else{
                      for (int i = 0; i < Hive.box<Musics>("musics").values.length; i++) {
                        if (Hive.box<Musics>("musics").getAt(i).id == music.id) {
                          io.File file = io.File(music.yol);
                          bool value = await file.exists();
                          if (value) {
                            Hive.box<Musics>("musics").deleteAt(i);
                            file.delete();
                            Navigator.of(context).pop();
                          } else {
                            evet = "remove".tr();
                            setState(() {});
                          }
                          if (z > 1) {
                            Hive.box<Musics>("musics").deleteAt(i);
                            Navigator.of(context).pop();
                          }
                        }
                      }
                    }
                  }),
            ],
          );
        },
      ),
    );
  }

  static listofFiles() async {
    filelistname = [];
    List<io.FileSystemEntity> file = new List();
    file = io.Directory(SettingsPage.Path).listSync();
    file.forEach((element) {
      if (element.path.split(".").contains("mp3")) {
        print(path.basenameWithoutExtension(element.path));
        filelistname.add(element.path);
      }
    });
  }

  static Future<void> showProgressNotification(
      int progrs, int id, String name, String path, bool downloading) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'progress channel', 'progress channel', 'tubeleech notif channel',
        channelShowBadge: false,
        importance: Importance.defaultImportance,
        autoCancel: SettingsPage.closeNtf,
        priority: Priority.defaultPriority,
        onlyAlertOnce: true,
        showProgress: downloading,
        maxProgress: 100,
        progress: progrs);
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        id, name, downloading ? "indiriliyor" : "İndirildi", platformChannelSpecifics,
        payload: path);
  }

  static playFileVideo(int index, List<Audio> urls) async {
    await audioPlayer.open(
      Playlist(startIndex: index, audios: urls.toSet().toList()),
      showNotification: true,
      loopMode: LoopMode.none,
    );
    print(urls.length);
    print(urls.toSet().toList().length);
  }

  static playUrlVideo(
    String url,
    String id,
    String title,
    String artist,
    String image,
  ) async {
    await audioPlayer.open(
      Audio.network(url),
      showNotification: true,
    );
    await audioPlayer.updateCurrentAudioNotification(
        metas: Metas(
            id: id,
            title: title,
            artist: artist,
            image: MetasImage.network(image),
            onImageLoadFail: MetasImage.asset("assets/play-button.svg")));
  }

  static toggleLoopVideo(bool loop) async {
    if (loop)
      await audioPlayer.toggleLoop();
    else
      await audioPlayer.setLoopMode(LoopMode.playlist);
  }

  static nextVideo() async {
    await audioPlayer.next();
  }

  static prevVideo() async {
    await audioPlayer.previous();
  }

  static playOrPauseVideo() async {
    await audioPlayer.playOrPause();
  }

  static stopVideo() async {
    await audioPlayer.stop();
  }

  static onSeek(Duration d) async {
    await audioPlayer.seek(d);
  }
}
