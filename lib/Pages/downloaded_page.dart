import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart' as audio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tubeleech/Bloc/player_bloc.dart';
import 'package:tubeleech/Models/musics.dart';
import 'package:tubeleech/Models/videos.dart';
import 'package:tubeleech/Pages/player_music.dart';
import 'package:tubeleech/Pages/settings_page.dart';


import 'package:tubeleech/utils/downcontroller.dart';
import 'package:easy_localization/easy_localization.dart';
class DownloadedPage extends StatefulWidget {

  @override
  _DownloadedPageState createState() => _DownloadedPageState();
}

class _DownloadedPageState extends State<DownloadedPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;
  @override
  void initState() {
    DownController.listofFiles();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext maincontext) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: new PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: new Container(
              color: Colors.red,
              child: new SafeArea(
                child: Column(
                  children: <Widget>[
                    new Expanded(child: new Container()),
                    new TabBar(
                      controller: _tabController,
                      indicatorWeight: 3,
                      indicatorColor: Colors.black,
                      tabs: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new Text("musics".tr(), style: GoogleFonts.lato(fontSize: 18)),
                        ),
                        new Text("videos".tr(), style: GoogleFonts.lato(fontSize: 18))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              ValueListenableBuilder(
                  valueListenable: Hive.box<Musics>("musics").listenable(),
                  builder: (maincontext, Box<Musics> box, _) {
                    DownController.audios=[];

                    return !box.values.isEmpty?
                    Container(
                      height: double.infinity,
                      child: ListView.builder(
                        itemCount: box.values.length+1,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                         if(box.values.length==index){
                           return Container(height: 50,);
                         }else{
                           Musics currentMusic = box.getAt(index);
                           DownController.audios.add(audio.Audio.file(currentMusic.yol, metas: audio.Metas(
                             id: currentMusic.id,
                             title: currentMusic.isim,
                             artist: "TubeLeech:Downloader",
                             image: audio.MetasImage.file(currentMusic.thumbnail),
                           ),));
                           return Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Container(
                               height: 85,
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
                               child: Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: ListTile(
                                   onTap: () {
                                     DownController.listofFiles();
                                     if (SettingsPage.usePlayer) {
                                       PlayerMusic.play=true;
                                       DownController.playFileVideo(
                                           index, DownController.audios);
                                     } else {
                                       DownController.openFile(context, music: currentMusic, tur: "mp3");
                                     }
                                   },
                                   leading: Material(
                                     elevation: 4,
                                     color: Colors.grey,
                                     shape: RoundedRectangleBorder(
                                         borderRadius: BorderRadius.circular(16)),
                                     clipBehavior: Clip.hardEdge,
                                     child: Image.file(
                                       File(currentMusic.thumbnail),
                                       width: 70,
                                       height: 70,
                                       fit: BoxFit.fill,
                                     ),
                                   ),
                                   title: Text(currentMusic.isim),
                                   trailing: IconButton(
                                     icon: Icon(Icons.delete),
                                     onPressed: () {
                                       print(currentMusic.id);
                                       DownController.deleteFile(maincontext,music: currentMusic,tur: "mp3");
                                     },
                                   ),
                                 ),
                               ),
                             ),
                           );
                         }
                        },
                      ),
                    ):
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.video_collection_outlined,size: 50,),
                          Center(
                            child:Text("list".tr(),style: GoogleFonts.nunito(color: Colors.black87,fontSize: 18),),
                          ),
                        ],
                      ),
                    );
                  }),
              ValueListenableBuilder(
                  valueListenable: Hive.box<Videos>("videos").listenable(),
                  builder: (maincontext, Box<Videos> box, _) {
                    return !box.values.isEmpty?
                    Container(
                      child: ListView.builder(
                        itemCount: box.values.length,
                        itemBuilder: (BuildContext context, int index) {
                          Videos currentVideo = box.getAt(index);
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 85,
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
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  onTap: () {
                                    DownController.listofFiles();
                                    BlocProvider.of<PlayerBloc>(context)
                                        .add(FetchPlayerEvent(isplayed: false));
                                    DownController.stopVideo();
                                    DownController.openFile(context,video: currentVideo,tur: "mp4");
                                  },
                                  leading: Material(
                                    elevation: 4,
                                    color: Colors.grey,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16)),
                                    clipBehavior: Clip.hardEdge,
                                    child: Image.file(
                                      File(currentVideo.thumbnail),
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  title: Text(currentVideo.isim),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      print(currentVideo.id);
                                      DownController.deleteFile( maincontext,video: currentVideo,tur: "mp4");
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ):
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.video_collection_outlined,size: 50,),
                          Center(
                            child:Text("list".tr(),style: GoogleFonts.nunito(color: Colors.black87,fontSize: 18),),
                          ),
                        ],
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
