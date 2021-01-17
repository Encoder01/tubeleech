import 'dart:async';
import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart' as audio;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tubeleech/Models/channel_info.dart';
import 'package:tubeleech/Models/musics.dart';
import 'package:tubeleech/Pages/player_music.dart';
import 'package:tubeleech/Pages/settings_page.dart';
import 'package:tubeleech/Pages/video_player_screen.dart';
import 'package:tubeleech/utils/admob_services.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:tubeleech/Bloc/player_bloc.dart';
import 'package:tubeleech/Models/videos.dart';
import 'package:tubeleech/utils/downcontroller.dart';
import 'package:easy_localization/easy_localization.dart';
import '../main.dart';

class ShowItems extends StatefulWidget {
  Item video;

  ShowItems({this.video});

  @override
  _ShowItemsState createState() => _ShowItemsState();
}

class _ShowItemsState extends State<ShowItems> {
  bool downloadingmp3;
  bool downloadingmp4;
  String filename;
  String thumbname;
  String whichPlay;
  YoutubeExplode yt;

  CancelToken token;
  bool isDownloaded;
  bool active;
  String fullpath;
  List<AudioOnlyStreamInfo> streamInfoAudio;
  List<MuxedStreamInfo> streamInfoVideo;
  ValueNotifier<int> progresmp3 = ValueNotifier(0);
  ValueNotifier<int> progresmp4 = ValueNotifier(0);

  @override
  void initState() {
    downloadingmp3 = false;
    downloadingmp4 = false;
    filename = "";
    thumbname = "";
    yt = YoutubeExplode();
    whichPlay = 'mp3';
    token = CancelToken();
    isDownloaded = false;
    active = false;
    fullpath = "";
    streamInfoAudio = [];
    streamInfoVideo = [];
    filename = widget.video.snippet.title.length > 55
        ? HtmlUnescape().convert(widget.video.snippet.title.substring(0, 55))
        : HtmlUnescape().convert(widget.video.snippet.title);
    getURl(widget.video);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: GridTile(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                )
              ]),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0, bottom: 8.0),
                child: Material(
                  elevation: 4,
                  color: Colors.grey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  clipBehavior: Clip.hardEdge,
                  child: Image.network(
                    widget.video.snippet.thumbnails.high.url,
                    width: 130,
                    height: 130,
                    fit: BoxFit.fitHeight,
                    loadingBuilder:
                        (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: 130,
                        height: 130,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                          title: Text(
                            filename,
                            style: GoogleFonts.lato(fontSize: 15),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ValueListenableBuilder(
                              valueListenable: Hive.box<Musics>("musics").listenable(),
                              builder: (context, Box<Musics> box, _) {
                                box.watch();
                                Musics mp3 = box.values.firstWhere(
                                        (element) => element.id == widget.video.id.videoId + ".mp3",
                                    orElse: () => Musics(active: false));
                                return downloadingmp3 ?
                                ValueListenableBuilder(
                                  valueListenable: progresmp3,
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
                                            downloadingmp3 = false;
                                            setState(() {});
                                          }
                                        },
                                      ),
                                      progressColor: Colors.red,
                                    );
                                  },
                                ) : mp3.active?
                                IconButton(
                                  icon: SvgPicture.asset(
                                    "assets/music_download_button.svg",
                                    semanticsLabel: 'Listen',
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    if (SettingsPage.usePlayer) {
                                      DownController.playFileVideo(
                                          0, [audio.Audio.file(mp3.yol, metas: audio.Metas(
                                        id: mp3.id,
                                        title: mp3.isim,
                                        artist: "TubeLeech:Downloader",
                                        image: audio.MetasImage.file(mp3.thumbnail),
                                      ),)
                                      ]);
                                    } else {
                                      DownController.openFile(context, music: mp3, tur: "mp3");
                                    }
                                  }
                                    ) :
                                PopupMenuButton(
                                    onSelected: (value) {
                                      download(
                                          streamInfoAudio[value].url.toString(), "mp3");
                                    },
                                    icon: SvgPicture.asset(
                                      "assets/music_download_button.svg",
                                      semanticsLabel: 'Listen',
                                    ),
                                    itemBuilder: (context) {
                                      return List.generate(
                                          streamInfoAudio.length,
                                              (index) => PopupMenuItem(
                                              value: index,
                                              child: Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.fromLTRB(
                                                        2, 2, 8, 2),
                                                    child: Icon(Icons.download_outlined),
                                                  ),
                                                  Text("Bitrate: "+streamInfoAudio[index].bitrate.megaBitsPerSecond.toStringAsFixed(2)),
                                                  Text(" " +
                                                      "size".tr() +
                                                      ":" +
                                                      streamInfoAudio[index]
                                                          .size
                                                          .totalMegaBytes
                                                          .toStringAsFixed(2) +
                                                      "Mb"),
                                                ],
                                              )));
                                    });
                              }),
                          ValueListenableBuilder(
                              valueListenable: Hive.box<Videos>("videos").listenable(),
                              builder: (context, Box<Videos> box, _) {
                                box.watch();
                                Videos videos = box.values.firstWhere(
                                        (element) => element.id == widget.video.id.videoId + ".mp4",
                                    orElse: () => Videos(active: false));
                                return downloadingmp4 ? ValueListenableBuilder(
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
                                ) : videos.active?IconButton(
                                  icon: SvgPicture.asset(
                                    "assets/video_download_button.svg",
                                    semanticsLabel: 'Listen',
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    // ignore: unrelated_type_equality_checks
                                    if (DownController.audioPlayer.playerState ==
                                        audio.PlayerState.play)
                                      DownController.stopVideo();

                                    DownController.openFile(context,video: videos);
                                  },
                                ) : PopupMenuButton(
                                    onSelected: (value) {
                                      download(
                                          streamInfoVideo[value].url.toString(), "mp4");
                                    },
                                    icon: SvgPicture.asset(
                                      "assets/video_download_button.svg",
                                      semanticsLabel: 'Listen',
                                    ),
                                    itemBuilder: (context) {
                                      return List.generate(
                                          streamInfoVideo.length,
                                              (index) => PopupMenuItem(
                                              value: index,
                                              child: Row(
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets.fromLTRB(
                                                        2, 2, 8, 2),
                                                    child: Icon(Icons.download_outlined),
                                                  ),
                                                  Text(streamInfoVideo[index]
                                                      .videoQualityLabel
                                                      .toString()),
                                                  Text(" " +
                                                      "size".tr() +
                                                      ":" +
                                                      streamInfoVideo[index]
                                                          .size
                                                          .totalMegaBytes
                                                          .toStringAsFixed(2) +
                                                      "Mb"),
                                                ],
                                              )));
                                    });
                              }),
                          BlocBuilder<PlayerBloc, PlayerState>(
                              builder: (context, eventstate) {
                                if (eventstate is PlayerLoadedState) {
                                  return IconButton(
                                    icon: DownController.getIsplay(widget.video.id.videoId)
                                        ? SvgPicture.asset(
                                      "assets/pause-button.svg",
                                      semanticsLabel: 'Listen',
                                        color: Colors.red
                                    )
                                        : SvgPicture.asset(
                                      "assets/play-button.svg",
                                      semanticsLabel: 'Listen',
                                    ),
                                    onPressed: () {
                                      if (SettingsPage.chosePlayer) {
                                        PlayerMusic.id = widget.video.id.videoId;
                                        PlayerMusic.play = false;
                                        DownController.playedVideo.forEach((element) {
                                          if (element.id != widget.video.id.videoId) {
                                            element.isPlay = false;
                                            element.havePlay = false;
                                          }
                                        });
                                        if (DownController.getHaveplay(widget.video.id.videoId)) {
                                          if (DownController.getIsplay(widget.video.id.videoId)) {
                                            DownController.setIsplay(
                                                widget.video.id.videoId, false);
                                            DownController.playOrPauseVideo();
                                            print("pause");
                                          } else {
                                            DownController.setIsplay(
                                                widget.video.id.videoId, true);
                                            DownController.playOrPauseVideo();
                                          }
                                        } else {
                                          DownController.playUrlVideo(
                                              streamInfoAudio.withHighestBitrate().url.toString(),
                                              widget.video.id.videoId,
                                              widget.video.snippet.title,
                                              widget.video.snippet.channelTitle,
                                              widget.video.snippet.thumbnails.medium.url);
                                          DownController.setIsplay(widget.video.id.videoId, true);
                                          DownController.setHaveplay(
                                              widget.video.id.videoId, true);
                                          BlocProvider.of<PlayerBloc>(context).add(
                                              FetchPlayerEvent(
                                                  isplayed: true, id: widget.video.id.videoId));
                                        }
                                      } else {

                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => VideoPlayerScreen(
                                              videoItem: widget.video.id.videoId,
                                            )));
                                      }
                                    },
                                  );
                                }
                                else
                                  return Container();
                              }),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<List<VideoStreamInfo>> getURl(
      Item task,
      ) async {
    var manifest = await yt.videos.streamsClient.getManifest(task.id.videoId);
    streamInfoVideo.addAll(manifest.muxed.sortByVideoQuality());
    streamInfoAudio.addAll(manifest.audioOnly.sortByBitrate());
    setState(() {});
  }

  download(String url, String tur) async {
    await downloadThumb(widget.video.snippet.thumbnails.medium.url);
    Dio dio = Dio();
    dio.interceptors.add(LogInterceptor());
    var path = SettingsPage.Path;
    if (tur == "mp3") {
      downloadingmp3 = true;
      setState(() {});
    } else {
      downloadingmp4 = true;
      setState(() {});
    }
    dio.download(
      url,
      "$path/$filename.$tur",
      cancelToken: token,
      //options: Options(headers:HttpHeaders.rangeHeader ),
      onReceiveProgress: (rcv, total) {
        if (tur == "mp3") {
          if (progresmp3.value < 100) {
            downloadingmp3 = true;
            progresmp3.value = ((rcv / total) * 100).toInt();
          }
        } else {
          if (progresmp4.value < 100) {
            downloadingmp4 = true;
            progresmp4.value = ((rcv / total) * 100).toInt();
          }
        }
      },
      deleteOnError: true,
    ).then((_) {
      if (tur == "mp3") {
        if (progresmp3.value == 100) {
          downloadingmp3 = false;
          addMusic(Musics(
              id: widget.video.id.videoId + ".${tur}",
              isim: filename,
              yol: "$path/$filename.$tur",
              tur: tur,
              active: true,
              thumbnail: thumbname));
          DownController.audios.add(audio.Audio.file("$path/$filename.$tur", metas: audio.Metas(
            id: widget.video.id.videoId + ".${tur}",
            title: filename,
            artist: "TubeLeech:Downloader",
            image: audio.MetasImage.file(thumbname),
          ),));
          DownController.showProgressNotification(
              progresmp3.value, 0, filename, "$path/$filename.$tur", downloadingmp3);

          if (SettingsPage.closeNtf) flutterLocalNotificationsPlugin.cancelAll();
        }
      } else {
        if (progresmp4.value == 100) {
          downloadingmp4 = false;
          addVideo(Videos(
              id: widget.video.id.videoId + ".${tur}",
              isim: filename,
              yol: "$path/$filename.$tur",
              tur: tur,
              active: true,
              thumbnail: thumbname));
          DownController.showProgressNotification(
              progresmp4.value, 0, filename, "$path/$filename.$tur", downloadingmp4);
          if (SettingsPage.closeNtf) flutterLocalNotificationsPlugin.cancelAll();
        }
      }
    });
  }

  downloadThumb(String url) async {
    Dio dio = Dio();
    dio.interceptors.add(LogInterceptor());
    Directory dir = await  getApplicationDocumentsDirectory();
    thumbname = "${dir.path}/${widget.video.id.videoId}.jpg";
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
   //   AdmobService.showInterstitial();
  }
  addMusic(Musics video) {
    Box<Musics> contactsBox = Hive.box<Musics>("musics");
    contactsBox.add(video);
    DownController.filelistname.add(video.yol);
   // if(contactsBox.values.length%3==0&&contactsBox.values.length>1)
      //AdmobService.showInterstitial();
  }
}

