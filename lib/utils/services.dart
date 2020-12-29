import 'dart:convert';
import 'dart:io';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:tubeleech/Models/channel_info.dart';

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
   Future<List<VideosInfo>> getVideosList(String q) async {
     videos=[];
    Map<String, String> parameters = {
      'part': 'snippet',
      'maxResults': "7",
      'q': q,//parametre alacak
      'type': 'video',
      'key': Constants.KEY,
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
    print(Utf8Decoder().convert(response.bodyBytes));
    return videos;
  }
   Future<List<VideosInfo>> getMoreVideosList(
      {String pageToken,String searchQ}) async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'maxResults': "1",
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
