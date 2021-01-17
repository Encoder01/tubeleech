import 'package:assets_audio_player/assets_audio_player.dart' as audio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tubeleech/Bloc/player_bloc.dart';
import 'package:tubeleech/utils/admob_services.dart';
import 'package:tubeleech/utils/downcontroller.dart';

class PlayerMusic extends StatefulWidget {
  static bool play=false;
  static String id;
  static bool isCon = true;
  static bool genel=false;
  @override
  _PlayerMusicState createState() => _PlayerMusicState();
}

class _PlayerMusicState extends State<PlayerMusic> with TickerProviderStateMixin {
  String sure1 = "";
  String sure2 = "";
  double maxprogress = 0;
  double curprogress = 0;
  int count =0;
  bool isPlaying = true;
  bool visible;
  bool loop=false;
  IconData ikon = Icons.repeat_outlined;
  AnimationController _controller;
  var scaleAnimation;

  @override
  void initState() {
    visible = false;
    _controller = new AnimationController(duration: new Duration(milliseconds: 650), vsync: this)
      ..addListener(() {
        setState(() {});
      });
    scaleAnimation = new Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(new CurvedAnimation(parent: _controller, curve: Curves.linearToEaseOut));
    listenEvents();
    super.initState();
  }
  listenEvents() {
    DownController.audioPlayer.current.listen((playingAudio){
      maxprogress = playingAudio.audio.duration.inSeconds.toDouble();
      curprogress=0;
      sure1=_printDuration(playingAudio.audio.duration);
    });

    DownController.audioPlayer.currentPosition.listen((Duration p) {
      sure2 = _printDuration(p);
      curprogress = p.inSeconds / maxprogress;
      setState(() {});
    });

    DownController.audioPlayer.playerState.listen((audio.PlayerState s) {
      if (s == audio.PlayerState.pause) {
        DownController.playedVideo.forEach((element) {
          if (element.id == PlayerMusic.id&&!PlayerMusic.play) {
            element.isPlay = false;
          }
        });
        isPlaying = false;
        BlocProvider.of<PlayerBloc>(context).add(FetchPlayerEvent(isplayed: true,));
        print("PAUSE EDİLDİ*****************");
      }
      else if (s == audio.PlayerState.stop) {
        print("DURDURULDU************");
        DownController.playedVideo.forEach((element) {
          if (element.id == PlayerMusic.id&&!PlayerMusic.play) {
            element.isPlay = false;
          }
        });
        isPlaying = false;
        BlocProvider.of<PlayerBloc>(context).add(FetchPlayerEvent(isplayed: false,));
      }
      else if (s == audio.PlayerState.play) {
        DownController.playedVideo.forEach((element) {
          if (element.id == PlayerMusic.id&&!PlayerMusic.play) {
            element.isPlay = true;
          }
        });
        isPlaying = true;
        BlocProvider.of<PlayerBloc>(context).add(FetchPlayerEvent(isplayed: true,));
      }
    });

    DownController.audioPlayer.loopMode.listen((loopMode){
      if(loopMode == audio.LoopMode.none)
        {
          ikon = Icons.arrow_right_alt_rounded;
        }

      else if(loopMode==audio.LoopMode.single)
       {
         ikon = Icons.repeat_one_rounded;
       }
      else if(loopMode==audio.LoopMode.playlist)
        {
          ikon = Icons.repeat;
        }
    });
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(1, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }


  @override
  Widget build(BuildContext context) {
    return
        BlocBuilder<PlayerBloc, PlayerState>(builder: (context, eventstate) {
          if(eventstate is PlayerLoadedState)
           {
             if(eventstate.isplayed)
               {
                 _controller.forward();
                 if(PlayerMusic.isCon)

                 PlayerMusic.genel=true;
               }
             else
               {
                 _controller.reverse();
                 if(PlayerMusic.isCon)

                 PlayerMusic.genel=false;
               }
          return Transform.scale(
              scale: scaleAnimation.value,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  height: 80,
                  padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                      boxShadow: [BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2),)]
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(sure2,style: GoogleFonts.lato(fontSize: 15)),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.0,
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Colors.red,
                                inactiveTrackColor: Colors.red.withOpacity(0.3),
                                trackShape: RectangularSliderTrackShape(),
                                trackHeight: 4.0,
                                thumbColor: Colors.red,
                                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.0),
                                overlayColor: Colors.red,
                                overlayShape: RoundSliderOverlayShape(overlayRadius: 8.0),
                              ),
                              child: Slider(
                                value: curprogress.isNaN?0:curprogress,
                                min: 0,
                                max: 1,
                                onChangeEnd: (value) {
                                  var val = value * maxprogress;
                                  DownController.onSeek(Duration(seconds: val.toInt()));
                                },
                                onChanged: (double value) {
                                  var val = value * maxprogress;
                                  curprogress = value;
                                  setState(() {

                                  });
                                  sure2 = _printDuration(Duration(seconds: val.toInt()));
                                },
                              ),
                            ),
                          ),
                          Text(sure1,style: GoogleFonts.lato(fontSize: 15)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          IconButton(
                            onPressed: ()   {
                              count++;
                              if(count>2)
                                count=0;
                              if(count>0 &&count<=2)
                                DownController.toggleLoopVideo(true);
                              else
                                DownController.toggleLoopVideo(false);
                             setState(() {
                             });
                            },
                            icon: Icon(
                             ikon,
                              color: Colors.red,size: 33
                            ),
                          ),
                          Visibility(
                            visible: PlayerMusic.play,
                            child: IconButton(
                              onPressed: ()   {
                                if(PlayerMusic.play)
                               {DownController.prevVideo();}
                              },
                              icon: Icon(
                                Icons.navigate_before_rounded,
                                color: Colors.black.withOpacity(0.8),size: 33,
                              ),

                            ),
                          ),
                          IconButton(
                            icon: Icon(isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline,size: 33,color: Colors.black.withOpacity(0.8),),
                            onPressed: () {
                              if (isPlaying) {
                                isPlaying = false;
                                DownController.playOrPauseVideo();
                              } else {
                                isPlaying = true;
                                DownController.playOrPauseVideo();
                              }
                            },
                          ),
                          Visibility(
                            visible: PlayerMusic.play,
                            child: IconButton(
                              icon: Icon(Icons.navigate_next_rounded,size: 33,color: Colors.black.withOpacity(0.8),),
                              onPressed: () {
                                if(PlayerMusic.play)
                                 { DownController.nextVideo();}
                              },
                            ),
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.stop_circle_outlined,size: 33,color: Colors.black.withOpacity(0.8)
                              ),
                              onPressed: () {
                                DownController.stopVideo();
                                BlocProvider.of<PlayerBloc>(context).add(FetchPlayerEvent(isplayed: false));

                              })
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );}else
             return Container();
    });
  }
}
