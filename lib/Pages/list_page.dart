 import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tubeleech/Bloc/videos_bloc.dart';
import 'package:tubeleech/Models/channel_info.dart';
import 'package:tubeleech/Models/playedvideo.dart';
import 'package:tubeleech/Pages/show_items.dart';
 import 'package:easy_localization/easy_localization.dart';
import 'package:tubeleech/utils/admob_services.dart';
import 'package:tubeleech/utils/constants.dart';
import 'package:tubeleech/utils/downcontroller.dart';

class ListPage extends StatefulWidget {
  static bool hasMore = true;
  static goToUp(){
    _ListPageState._scrollController.animateTo(0.0,
        curve: Curves.linearToEaseOut, duration: Duration (milliseconds: 800));
  }
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
 static ScrollController _scrollController = new ScrollController();
 final _nativeAdController = NativeAdmobController();
  @override
  void initState() {
    BlocProvider.of<VideosBloc>(context).add(FetchVideoEvent(searchQ: Constants.firstSearch));
    super.initState();
  }

  @override
  void dispose() {
    BlocProvider.of<VideosBloc>(context).close();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Container(

      child: BlocBuilder<VideosBloc, VideosState>(builder: (context, eventstate) {
        if (eventstate is VideosLoadedState) {
          List<VideosInfo> videosInfos = eventstate.videos;
          List<Item> videosInfo = [];
          videosInfos.forEach((element) {
            element.items.forEach((element) {
              videosInfo.add(element);
            });
          });
          DownController.playedVideo=[];
          videosInfo.forEach((element) {DownController.playedVideo.add(PlayedVideo(id:element.id.videoId ,isPlay:false,havePlay: false));});

          return NotificationListener<ScrollNotification>(
            onNotification: (scrollState) {
              if (scrollState is ScrollEndNotification &&
                  _scrollController.position.extentAfter == 0.0 &&
                  _scrollController.position.userScrollDirection == ScrollDirection.reverse) {
                if (ListPage.hasMore) {
                  BlocProvider.of<VideosBloc>(context).add(RefreshVideoEvent(
                      searchQ: Constants.Search, pageToken: videosInfos.last.nextPageToken));
                  Future.delayed(Duration(milliseconds: 600)).then((value) {
                    setState(() {});
                  });
                } else
                  return false;
              }
              return false;
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 1,
                mainAxisSpacing: 9,
                crossAxisSpacing: 5,
                physics: ScrollPhysics(),
                controller: _scrollController,
                padding: const EdgeInsets.all(5),
                childAspectRatio: 2,
                shrinkWrap: true,
                children: List.generate(videosInfo.length + 1, (index) {
                  if (videosInfo.length != index) {
                    if (index%5==0&& index>1 ) {
                      return NativeAdmob(
                          numberAds: 3,
                          error: shimmerLoad(),
                          loading: shimmerLoad(),
                          adUnitID: "ca-app-pub-2182756097973140/1984427099",
                          controller: _nativeAdController,
                          type: NativeAdmobType.full);
                    } else
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
                  child: Icon(Icons.network_check),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("isCon".tr(),
                    style: TextStyle(fontSize: 16)),
              )
            ],
          );
        }
      }),
    );
  }


}
 class shimmerLoad extends StatelessWidget {
   @override
   Widget build(BuildContext context) {
     return Shimmer.fromColors(
       baseColor: Colors.grey[350],
       highlightColor: Colors.grey[100],
       child: Padding(
         padding: const EdgeInsets.all(10.0),
         child: Row(
           crossAxisAlignment: CrossAxisAlignment.center,
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Material(
               elevation: 4,
               color: Colors.grey,
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
               clipBehavior: Clip.hardEdge,
               child: Container(
                 height: 130,
                 width: 130,
                 color: Colors.white,
               ),
             ),
             const Padding(
               padding: EdgeInsets.symmetric(horizontal: 8.0),
             ),
             Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: <Widget>[
                   Container(
                     width: double.infinity,
                     height: 8.0,
                     color: Colors.white,
                   ),
                   const Padding(
                     padding: EdgeInsets.symmetric(vertical: 2.0),
                   ),
                   Container(
                     width: double.infinity,
                     height: 8.0,
                     color: Colors.white,
                   ),
                   const Padding(
                     padding: EdgeInsets.symmetric(vertical: 2.0),
                   ),
                   Container(
                     width: double.infinity,
                     height: 8.0,
                     color: Colors.white,
                   ),
                   const Padding(
                     padding: EdgeInsets.symmetric(vertical: 2.0),
                   ),
                   Container(
                     width: 40.0,
                     height: 8.0,
                     color: Colors.white,
                   ),
                 ],
               ),
             )
           ],
         ),
       ),
     );
   }
 }
