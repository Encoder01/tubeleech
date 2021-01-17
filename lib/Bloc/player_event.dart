part of 'player_bloc.dart';

@immutable
abstract class PlayerEvent {}
class FetchPlayerEvent extends PlayerEvent {
  bool isplayed;
  String id="";
  FetchPlayerEvent({@required this.isplayed,this.id});

}