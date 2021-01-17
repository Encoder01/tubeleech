import 'dart:convert';
import 'dart:io';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:tubeleech/Models/channel_info.dart';
import 'package:tubeleech/Models/instagram.dart';
import 'package:tubeleech/Models/instagram_photo.dart';
import 'package:tubeleech/Models/instagram_photo_private.dart';
import 'package:tubeleech/Models/instagram_reel_private.dart';
import 'package:tubeleech/Models/instagram_video.dart';
import 'package:tubeleech/Models/instagram_video_private.dart';

import 'constants.dart';

class Services {
 /* curl \
  'https://youtube.googleapis.com/youtube/v3/search?part=snippet&maxResults=10&q=admob&type=video&type=music&key=[YOUR_API_KEY]' \
  --header 'Authorization: Bearer [YOUR_ACCESS_TOKEN]' \
  --header 'Accept: application/json' \
  --compressed
*/
  static const _baseUrl = 'www.googleapis.com';
  List<VideosInfo> videos = [];
  Instagram instagramReel;
  InstagramPhoto instagramPhoto;
  InstagramVideo instagramVideo;
  InstagramReelPrivate instagramReelPrivate;
  InstagramPhotoPrivate instagramPhotoPrivate;
  InstagramVideoPrivate instagramVideoPrivate;
   Future<List<VideosInfo>> getVideosList(String q) async {
     videos=[];
    Map<String, String> parameters = {
      'part': 'snippet',
      'maxResults': "6",
      'q': q,//parametre alacak
      'type': 'video',
      'key': Constants.KEY2,
    };
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/search',
      parameters,
    );
    Response response = await http.get(uri, headers: headers);
     Utf8Decoder().convert(response.bodyBytes);
    VideosInfo videoInfo = videosInfoFromJson(response.body);
    videos.add(videoInfo);
    return videos;
  }
   Future<InstagramPhoto> getInstaPhoto(String url) async {

     instagramPhoto=  InstagramPhoto();
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
    };
    Response response = await http.get("$url?__a=1", headers: headers);
     instagramPhoto = instagramPhotoFromJson(response.body);
     print(Utf8Decoder().convert(response.bodyBytes));
    return instagramPhoto;
  }
   Future<Instagram> getInstaReel(String url) async {

     instagramReel=  Instagram();
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
    };
    Response response = await http.get("$url?__a=1", headers: headers);
     instagramReel = instagramFromJson(response.body);
     print(Utf8Decoder().convert(response.bodyBytes));
    return instagramReel;
  }
   Future<InstagramVideo> getInstaVideo(String url) async {

     instagramVideo=  InstagramVideo();
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
    };
    Response response = await http.get("$url?__a=1", headers: headers);
     instagramVideo = instagramVideoFromJson(response.body);
     print(Utf8Decoder().convert(response.bodyBytes));
    return instagramVideo;
  }

  Future<InstagramPhotoPrivate> getInstaPhotoPrivate(String url) async {

    instagramPhotoPrivate=  InstagramPhotoPrivate();
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
    };
    Response response = await http.get("$url?__a=1", headers: headers);
    instagramPhotoPrivate = instagramPhotoPrivateFromJson(response.body);
    print(Utf8Decoder().convert(response.bodyBytes));
    return instagramPhotoPrivate;
  }
  Future<InstagramReelPrivate> getInstaReelPrivate(String url) async {

    instagramReelPrivate=  InstagramReelPrivate();
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
    };
    Response response = await http.get("$url?__a=1", headers: headers);
    instagramReelPrivate = instagramReelPrivateFromJson(response.body);
    print(Utf8Decoder().convert(response.bodyBytes));
    return instagramReelPrivate;
  }
  Future<InstagramVideoPrivate> getInstaVideoPrivate(String url) async {

    instagramVideoPrivate=  InstagramVideoPrivate();
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
    };
    Response response = await http.get("$url?__a=1", headers: headers);
    instagramVideoPrivate = instagramVideoPrivateFromJson(response.body);
    print(Utf8Decoder().convert(response.bodyBytes));
    return instagramVideoPrivate;
  }

   Future<List<VideosInfo>> getMoreVideosList(
      {String pageToken,String searchQ}) async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'maxResults': "2",
      'q': searchQ,//parametre alacak
      'type': 'video',
      'pageToken': pageToken,
      'key': Constants.KEY2,
    };
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };
    Uri uri = Uri.https(
      _baseUrl,
      '/youtube/v3/search',
      parameters,
    );
    Response response = await http.get(uri, headers: headers);
    utf8.decode(response.bodyBytes);
    print(Utf8Decoder().convert(response.bodyBytes));
    var unescape = HtmlUnescape();
    print(unescape.convert(Utf8Decoder().convert(response.bodyBytes)));
    VideosInfo videosList = videosInfoFromJson(response.body);
    videos.add(videosList);
    return videos;
  }
}
