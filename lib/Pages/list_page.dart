import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:tubeleech/Bloc/videos_bloc.dart';
import 'package:tubeleech/Models/channel_info.dart';
import 'package:tubeleech/Models/videos.dart';
import 'package:tubeleech/download.dart';
import 'package:tubeleech/utils/downcontroller.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class ListPage extends StatefulWidget {
  static bool hasMore = true;

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    BlocProvider.of<VideosBloc>(context).add(FetchVideoEvent(searchQ: "honor him"));
    super.initState();
  }

  @override
  void dispose() {
    BlocProvider.of<VideosBloc>(context).close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideosBloc, VideosState>(builder: (context, eventstate) {
      if (eventstate is VideosLoadedState) {
        List<VideosInfo> videosInfos = eventstate.videos;
        List<Item> videosInfo = [];
        videosInfos.forEach((element) {
          element.items.forEach((element) {
            videosInfo.add(element);
          });
        });
        return NotificationListener<ScrollNotification>(
          onNotification: (scrollState) {
            if (scrollState is ScrollEndNotification &&
                _scrollController.position.extentAfter == 0.0 &&
                _scrollController.position.userScrollDirection == ScrollDirection.reverse) {
              if (ListPage.hasMore) {
                BlocProvider.of<VideosBloc>(context).add(RefreshVideoEvent(
                    searchQ: 'honor him', pageToken: videosInfos.last.nextPageToken));
                Future.delayed(Duration(milliseconds: 600)).then((value) {
                  setState(() {});
                });
              } else
                return false;
            }
            return false;
          },
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 1,
                mainAxisSpacing: 9,
                crossAxisSpacing: 5,
                physics: ScrollPhysics(),
                controller: _scrollController,
                padding: const EdgeInsets.all(5),
                childAspectRatio: 3,
                shrinkWrap: true,
                children: List.generate(videosInfo.length + 1, (index) {
                  if (videosInfo.length != index) {
                    return ShowItems(video: videosInfo[index]);
                  } else {
                    if (ListPage.hasMore) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return null;
                  }
                }),
              ),
            ),
          ),
        );
      } else if (eventstate is VideosLoadingState) {
        return Center(child: CircularProgressIndicator());
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Lütfen İnternet Bağlantınızı Kontrol Ediniz ",
                    style: TextStyle(fontSize: 16)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Lütfen İnternet Bağlantınızı Kontrol Ediniz ",
                  style: TextStyle(fontSize: 16)),
            )
          ],
        );
      }
    });
  }

  convertDuration() {
    String durationString = "P2Y5M3W4DT5H4M2S";
    String regxPattern = "^P(\\d+Y)?(\\d+M)?(\\d+W)?(\\d+D)?(T(\\d+H)?(\\d+M)?(\\d+S)?)?\$";

    print(regxPattern);

    RegExp re = new RegExp(regxPattern);

    if (re.hasMatch(durationString)) {
      for (var m in re.allMatches(durationString)) {
        print("${m.group(6)[0]}:${m.group(7)[0]}:${m.group(8)[0]}");
      }
    }
  }
}

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
  YoutubeExplode yt;
  String progressmp3;
  String progressmp4;
  CancelToken token;
  bool isDownloaded;
  bool active;
  String fullpath;
  List<AudioOnlyStreamInfo> streamInfoAudio;
  List<MuxedStreamInfo> streamInfoVideo;
  List<VideoOnlyStreamInfo> streamInfoVideo2;
  @override
  void initState() {
    downloadingmp3 = false;
    downloadingmp4 = false;
    filename = "";
    yt = YoutubeExplode();
    progressmp3 = '0';
    progressmp4 = '0';
    token = CancelToken();
    isDownloaded = false;
    active = false;
    fullpath = "";
    streamInfoAudio=[];
    streamInfoVideo=[];
    streamInfoVideo2=[];
    filename = widget.video.snippet.title.length > 55
        ? HtmlUnescape().convert(widget.video.snippet.title.substring(0, 55))
        : HtmlUnescape().convert(widget.video.snippet.title);
    getURl(widget.video);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DownItem()));
      },
      child: GridTile(
        child: Row(
          children: [
            Material(
              color: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                width: 100,
                height: double.infinity,
                fit: BoxFit.fitWidth,
                imageUrl: widget.video.snippet.thumbnails.medium.url,
                placeholder: (context, url) => Center(child: new CircularProgressIndicator()),
                errorWidget: (context, url, error) => new Icon(Icons.error),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.white)]),
                child: Column(
                  children: [
                    ListTile(
                        title: Text(
                      filename,
                      style: TextStyle(fontSize: 13),
                    )),
                    ValueListenableBuilder(
                        valueListenable: Hive.box<Videos>("videos").listenable(),
                        builder: (context, Box<Videos> box, _) {
                          box.watch();
                          Videos mp3 = box.values.firstWhere(
                                  (element) => element.id == widget.video.id.videoId+"mp3",
                              orElse: () => Videos(active: false));
                          Videos video = box.values.firstWhere(
                                  (element) => element.id == widget.video.id.videoId+"mp4",
                              orElse: () => Videos(active: false));
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            downloadingmp3
                                  ? CircularPercentIndicator(
                                      radius: 40.0,
                                      lineWidth: 4.0,
                                      percent: int.parse(progressmp3) / 100,
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
                                      progressColor: Colors.green,
                                    )
                                  : mp3.active&&mp3.tur=="mp3"?
                            IconButton(icon: Icon(Icons.play_circle_fill,color: Colors.red,),
                              onPressed: (){
                              DownController.openFile(mp3, context);
                            },):
                            PopupMenuButton(
                                onSelected: (value) {
                                 download(streamInfoAudio[value].url.toString(), "mp3");
                                },
                                  icon: Icon(Icons.download_rounded),
                                itemBuilder: (context) => List.generate(streamInfoAudio.length, (index) => PopupMenuItem(
                                    value: index,
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                                          child: Icon(Icons.share),
                                        ),
                                        Text("Bitrate:"+streamInfoAudio[index].bitrate.megaBitsPerSecond.toStringAsFixed(2)),
                                        Text(" Boyut:"+streamInfoAudio[index].size.totalMegaBytes.toStringAsFixed(2)+"mb"),
                                      ],
                                    )))),
                            downloadingmp4
                                ? CircularPercentIndicator(
                              radius: 40.0,
                              lineWidth: 4.0,
                              percent: int.parse(progressmp4) / 100,
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
                              progressColor: Colors.green,
                            )
                                :video.active&&video.tur=="mp4"?
                            IconButton(icon: Icon(Icons.play_circle_fill,color: Colors.red),
                              onPressed: (){
                                DownController.openFile(video, context);
                            },):
                            PopupMenuButton(
                                onSelected: (value) {
                                  download(streamInfoVideo[value].url.toString(), "mp4");
                                },
                                icon: Icon(Icons.video_collection),
                                itemBuilder: (context) =>List.generate(streamInfoVideo.length, (index) => PopupMenuItem(
                                    value: index,
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(2, 2, 8, 2),
                                          child: Icon(Icons.share),
                                        ),
                                        Text(streamInfoVideo[index].videoQualityLabel.toString()),
                                        Text(" Boyut:"+streamInfoVideo[index].size.totalMegaBytes.toStringAsFixed(2)+"Mb"),
                                      ],
                                    )))),
                            IconButton(icon: Icon(Icons.play_arrow),onPressed: ()=>DownController.settingModalBottomSheet(context,widget.video.id.videoId),),
                          ],
                        );
                      }
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        footer: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Container(
                width: 105,
                padding: EdgeInsets.all(5),
                child: Text(
                  "Süre",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<VideoStreamInfo>> getURl(Item task,)async{
    var manifest = await yt.videos.streamsClient.getManifest(task.id.videoId);
    streamInfoVideo.addAll(manifest.muxed.sortByVideoQuality());
    manifest.audioOnly.forEach((element) {streamInfoAudio.add(element); });

  }

  download(String url,String tur) async {
    Dio dio = Dio();
    dio.interceptors.add(LogInterceptor());
    var path ="";
    if(tur=="mp3")
      path = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_MUSIC);
    else
      path = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_MOVIES);
    dio.download(
      url,
      "$path/$filename.$tur",
      cancelToken: token,
      //options: Options(headers:HttpHeaders.rangeHeader ),
      onReceiveProgress: (rcv, total) {
        print('received: ${rcv.toStringAsFixed(0)} out of total: ${total.toStringAsFixed(0)}');

        setState(() {
          //tur=="mp3"?progressmp3:progressmp4 = ((rcv / total) * 100).toStringAsFixed(0);

          DownController.showProgressNotification(
              int.parse(tur=="mp3"?progressmp3:progressmp4), tur=="mp3"?0:1, filename,
              "$path/$filename.$tur", tur=="mp3"?downloadingmp3:downloadingmp4);
        });

        if (tur=="mp3") {
          if(double.parse(progressmp3)<100){
            setState(() {
              progressmp3 = ((rcv / total) * 100).toStringAsFixed(0);
              downloadingmp3 = true;
            });
          }
        } else{
          if(double.parse(progressmp4)<100){
            setState(() {
              progressmp4 = ((rcv / total) * 100).toStringAsFixed(0);
              downloadingmp4 = true;
            });
          }
        }
      },
      deleteOnError: true,
    ).then((_) {
      setState(() {
        if (tur=="mp3") {
          if(progressmp3 == '100'){
            setState(() {
              downloadingmp3=false;
              addVideo(Videos(
                  id: widget.video.id.videoId+tur,
                  isim: filename,
                  yol: "$path/$filename.$tur",
                  tur: tur,
                  active: true));
            });
          }
        } else{
          if(progressmp4 == '100'){
            setState(() {
              downloadingmp4=false;
              addVideo(Videos(
                  id: widget.video.id.videoId+tur,
                  isim: filename,
                  yol: "$path/$filename.$tur",
                  tur: tur,
                  active: true));
            });
          }
        }
      });
    });
  }

  void addVideo(Videos video) {
    Box<Videos> contactsBox = Hive.box<Videos>("videos");
    contactsBox.add(video);
    DownController.filelistname.add(video.yol);
  }
}
