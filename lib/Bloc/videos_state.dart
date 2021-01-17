part of 'videos_bloc.dart';

abstract class VideosState extends Equatable {
  const VideosState();
}

class VideosInitial extends VideosState {
  @override
  List<Object> get props => [];
}

class VideosLoadingState extends VideosState {
  @override
  List<Object> get props => [];
}

class VideosLoadedState extends VideosState {
  List<VideosInfo> videos;
  bool hasmore=false;
  VideosLoadedState({this.videos,this.hasmore});

  @override
  List<Object> get props => [videos];
}
class InstagramLoadedState extends VideosState {
  Instagram instagram;

  InstagramLoadedState({this.instagram});

  @override
  List<Object> get props => [instagram];
}

class VideosErrorState extends VideosState {
  @override
  List<Object> get props => [];
}