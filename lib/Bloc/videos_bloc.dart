import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tubeleech/Models/channel_info.dart';
import 'package:tubeleech/Models/instagram.dart';
import 'package:tubeleech/Repo/locator.dart';
import 'package:tubeleech/Repo/video_repo.dart';
import 'package:tubeleech/utils/constants.dart';


part 'videos_event.dart';
part 'videos_state.dart';

class VideosBloc extends Bloc<VideosEvent, VideosState> {
  VideosBloc() : super(VideosInitial());
  final VideoRepository videoRepository = getIt<VideoRepository>();
  @override
  VideosState get initialState => VideosInitial();

  @override
  Stream<VideosState> mapEventToState(
    VideosEvent event,
  ) async* {
    if (event is FetchVideoEvent){
      try{
        yield VideosLoadingState();
        await  Constants.getKEY();
        final List<VideosInfo> getirilenVideo =
        await videoRepository.getVideo(searchQ: event.searchQ,isMore: false);
        yield VideosLoadedState(videos: getirilenVideo,hasmore: false);
      }
    catch (_) {
    yield VideosErrorState();
    }
    }
    else if(event is RefreshVideoEvent){
      try{
        final List<VideosInfo> getirilenVideo =
        await videoRepository.getmoreVideo(searchQ: event.searchQ,pageToken: event.pageToken);
        yield VideosLoadedState(videos: getirilenVideo,hasmore: true);
      }
      catch (_) {
        yield state;
      }
    }
    else if(event is FetchInstagramEvent){
      try{
        final Instagram getirilenVideo =
        await videoRepository.getInstagramPost(url: event.url,);
        yield InstagramLoadedState(instagram: getirilenVideo,);
      }
      catch (_) {
        yield state;
      }
    }
  }
}
