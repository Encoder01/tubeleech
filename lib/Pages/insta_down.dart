import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:tubeleech/Bloc/videos_bloc.dart';
import 'package:tubeleech/Models/instagram.dart';
import 'package:tubeleech/Models/instagram_photo.dart';
import 'package:tubeleech/Models/instagram_photo_private.dart';
import 'package:tubeleech/Models/instagram_reel_private.dart';
import 'package:tubeleech/Models/instagram_video.dart';
import 'package:tubeleech/Models/instagram_video_private.dart';
import 'package:tubeleech/Models/videos.dart';
import 'package:tubeleech/Pages/settings_page.dart';
import 'package:tubeleech/utils/downcontroller.dart';
import 'package:tubeleech/utils/services.dart';

import '../main.dart';

class InstaDown extends StatefulWidget {
  @override
  _InstaDownState createState() => _InstaDownState();
}

class _InstaDownState extends State<InstaDown> {
  bool downloadingmp4;
  String thumbname;
  CancelToken token;
  bool private;
  ValueNotifier<int> progresmp4 = ValueNotifier(0);
  final myController = TextEditingController();

  @override
  void initState() {
    downloadingmp4 = false;
    private = false;
    thumbname = "";
    super.initState();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Instagram Downloader"),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Link Gir",
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 70,
                  child: Center(
                    child: TextField(
                      controller: myController,
                      onSubmitted: (value) {
                        myController.text = value;
                        BlocProvider.of<VideosBloc>(context)
                            .add(FetchInstagramEvent(url: myController.text));
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red, //this has no effect
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintText: "https://www.instagram.com/p/CJq-IUuhem4",
                      ),
                    ),
                  ),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: progresmp4,
                builder: (BuildContext context, value, Widget child) {
                  return CircularPercentIndicator(
                    radius: 40.0,
                    lineWidth: 4.0,
                    percent: value / 100,
                    center: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        token.cancel("cancelled");
                        if (token.isCancelled) {
                          token = new CancelToken();
                          downloadingmp4 = false;
                          setState(() {});
                        }
                      },
                    ),
                    progressColor: Colors.red,
                  );
                },
              ),
              Container(
                width: 160,
                child: RaisedButton.icon(
                  icon: Icon(Icons.download_rounded),
                  color: Colors.green,
                  onPressed: () async {
                   if(!private){ Instagram insta = await Services().getInstaReel(myController.text);
                    download(
                        insta.graphql.shortcodeMedia.id,
                        insta.graphql.shortcodeMedia.videoUrl,
                        insta.graphql.shortcodeMedia.thumbnailSrc,
                        insta.graphql.shortcodeMedia.isVideo);
                   }else{
                     InstagramReelPrivate insta = await Services().getInstaReelPrivate(myController.text);
                     download(
                         insta.graphql.shortcodeMedia.id,
                         insta.graphql.shortcodeMedia.videoUrl,
                         insta.graphql.shortcodeMedia.thumbnailSrc,
                         insta.graphql.shortcodeMedia.isVideo);
                   }
                  },
                  label: Text("Reel Video"),
                ),
              ),
              Container(
                width: 160,
                child: RaisedButton.icon(
                  icon: Icon(Icons.download_rounded),
                  color: Colors.green,
                  onPressed: () async {
                    if(!private){InstagramPhoto insta = await Services().getInstaPhoto(myController.text);
                    download(
                        insta.graphql.shortcodeMedia.id,
                        insta.graphql.shortcodeMedia.displayUrl,
                        insta.graphql.shortcodeMedia.displayResources.first.src,
                        insta.graphql.shortcodeMedia.isVideo);
                    }else{
                      InstagramPhotoPrivate insta = await Services().getInstaPhotoPrivate(myController.text);
                      download(
                          insta.graphql.shortcodeMedia.id,
                          insta.graphql.shortcodeMedia.displayUrl,
                          insta.graphql.shortcodeMedia.displayResources.first.src,
                          insta.graphql.shortcodeMedia.isVideo);
                    }
                  },
                  label: Text("Insta Photo"),
                ),
              ),
              Container(
                width: 160,
                child: RaisedButton.icon(
                  icon: Icon(Icons.download_rounded),
                  color: Colors.green,
                  onPressed: () async {
                  if(!private){  InstagramVideo insta = await Services().getInstaVideo(myController.text);
                    download(
                        insta.graphql.shortcodeMedia.id,
                        insta.graphql.shortcodeMedia.videoUrl,
                        insta.graphql.shortcodeMedia.thumbnailSrc,
                        insta.graphql.shortcodeMedia.isVideo);
                  }else{
                    InstagramVideoPrivate insta = await Services().getInstaVideoPrivate(myController.text);
                    download(
                        insta.graphql.shortcodeMedia.id,
                        insta.graphql.shortcodeMedia.videoUrl,
                        insta.graphql.shortcodeMedia.thumbnailSrc,
                        insta.graphql.shortcodeMedia.isVideo);
                  }
                  },
                  label: Text("Insta Video"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  download(String id, String url, String thumb, bool tur) async {
    await downloadThumb(thumb, id);
    Dio dio = Dio();
    dio.interceptors.add(LogInterceptor());
    var path = SettingsPage.Path;
    downloadingmp4 = true;
    setState(() {});
    dio.download(
      url,
      "$path/$id.${tur ? 'mp4' : 'jpg'}",
      cancelToken: token,
      //options: Options(headers:HttpHeaders.rangeHeader ),
      onReceiveProgress: (rcv, total) {
        if (progresmp4.value < 100) {
          downloadingmp4 = true;
          progresmp4.value = ((rcv / total) * 100).toInt();
        }
      },
      deleteOnError: true,
    ).then((_) {
      if (progresmp4.value == 100) {
        downloadingmp4 = false;
        addVideo(Videos(
            id: id + ".${tur ? 'mp4' : 'jpg'}",
            isim: id,
            yol: "$path/$id.${tur ? 'mp4' : 'jpg'}",
            tur: "${tur ? 'mp4' : 'jpg'}",
            active: true,
            thumbnail: thumbname));
        DownController.showProgressNotification(
            progresmp4.value, 0, id, "$path/$id.${tur ? 'mp4' : 'jpg'}", downloadingmp4);
        if (SettingsPage.closeNtf) flutterLocalNotificationsPlugin.cancelAll();
        progresmp4.value = 0;
      }
    });
  }

  downloadThumb(String url, String id) async {
    Dio dio = Dio();
    dio.interceptors.add(LogInterceptor());
    Directory dir = await getApplicationDocumentsDirectory();
    thumbname = "${dir.path}/$id.jpg";
    await dio.download(
      url,
      thumbname,
      cancelToken: token,
      deleteOnError: true,
    );
  }

  addVideo(Videos video) {
    Box<Videos> contactsBox = Hive.box<Videos>("videos");
    contactsBox.add(video);
    DownController.filelistname.add(video.yol);
    //if(contactsBox.values.length%3==0&&contactsBox.values.length>1)
    //    AdmobService.showInterstitial();
  }
}
