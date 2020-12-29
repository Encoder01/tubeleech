part of 'videos_bloc.dart';

abstract class VideosEvent extends Equatable {
  const VideosEvent();
}
class FetchVideoEvent extends VideosEvent {
  String searchQ;
  FetchVideoEvent({@required this.searchQ,});
  @override
  List<Object> get props => throw UnimplementedError();
}
class RefreshVideoEvent extends VideosEvent {
  String searchQ;
  String pageToken;
  RefreshVideoEvent({@required this.searchQ,this.pageToken});
  @override
  List<Object> get props => throw UnimplementedError();
}