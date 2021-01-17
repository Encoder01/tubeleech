import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tubeleech/Bloc/player_bloc.dart';
import 'package:tubeleech/Pages/downloaded_page.dart';
import 'package:tubeleech/Pages/list_page.dart';
import 'package:tubeleech/Pages/settings_page.dart';
import 'package:tubeleech/utils/connectivity.dart';
import 'package:tubeleech/utils/downcontroller.dart';
import 'player_music.dart';
import 'Search.dart';


class BottomPage extends StatefulWidget {
  @override
  _BottomPageState createState() => _BottomPageState();
}

class _BottomPageState extends State<BottomPage> {
  int _currentIndex = 0;
  Map _source = {ConnectivityResult.none: false};
  MyConnectivity _connectivity = MyConnectivity.instance;

  @override
  void initState() {
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
      if (_source.values.contains(false)) {
       PlayerMusic.isCon=false;
      } else {
        PlayerMusic.isCon=true;
      }
    });
    BlocProvider.of<PlayerBloc>(context).add(FetchPlayerEvent(isplayed: false));
    DownController.getPermiss();

    super.initState();
  }

  void onTabTapped(int index) {
    switch (index) {
      case 0:
        {
          ListPage.goToUp();
          _currentIndex = index;
        }
        break;
      case 1:
        {
        _currentIndex = index;
        }
        break;
    }
    setState(() {
      _currentIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          Offstage(
            offstage: _currentIndex != 0,
            child: SearchPage(),
          ),
          Offstage(
            offstage: _currentIndex != 1,
            child: DownloadedPage(),
          ),
          Offstage(
            offstage: _currentIndex != 2,
            child: SettingsPage(),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
                child: Align(
              alignment: Alignment.bottomCenter,
                  child: PlayerMusic(),
            )),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home_outlined),
            title: new Text("search".tr()),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.download_outlined),
            title: new Text("downloads".tr(), style: TextStyle(fontSize: 12)),
          ),

          BottomNavigationBarItem(
            icon: new Icon(Icons.settings),
            title: new Text("setngs".tr(), style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
