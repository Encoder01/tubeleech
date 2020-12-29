import 'package:flutter/material.dart';
import 'package:tubeleech/Models/channel_info.dart';
import 'package:tubeleech/Repo/locator.dart';
import 'package:tubeleech/utils/services.dart';

class VideoRepository{
  Services videoApiClient = getIt<Services>();

  Future<List<VideosInfo>> getVideo(
      {@required bool isMore,
        String searchQ,
      }) async {
    return await videoApiClient.getVideosList(searchQ);
  }
  Future<List<VideosInfo>> getmoreVideo(
      {@required
        String searchQ,String pageToken
      }) async {
    return await videoApiClient.getMoreVideosList(searchQ: searchQ,pageToken: pageToken);
  }
}