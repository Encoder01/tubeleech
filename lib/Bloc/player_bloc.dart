import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tubeleech/Models/playedvideo.dart';

part 'player_event.dart';
part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  PlayerBloc() : super(PlayerInitial());

  @override
  Stream<PlayerState> mapEventToState(
    PlayerEvent event,
  ) async* {
    if (event is FetchPlayerEvent){
      try{
        yield PlayerLoadedState(isplayed:event.isplayed,id: event.id);
      }
      catch (_) {
        yield state;
      }
    }
  }
}
