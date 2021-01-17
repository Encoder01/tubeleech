part of 'player_bloc.dart';

@immutable
abstract class PlayerState {}

class PlayerInitial extends PlayerState {}
class PlayerLoadedState extends PlayerState {
  bool isplayed=false;
  String id="";
  PlayerLoadedState({this.isplayed,this.id});
}
