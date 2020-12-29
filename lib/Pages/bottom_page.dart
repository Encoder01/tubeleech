import 'package:flutter/material.dart';
import 'package:tubeleech/Pages/download_page.dart';

import 'Search.dart';

class BottomPage extends StatefulWidget {
  @override
  _BottomPageState createState() => _BottomPageState();
}

class _BottomPageState extends State<BottomPage> {
  int _currentIndex = 0;
  void onTabTapped(int index){
    switch(index){
      case 0:{
        _currentIndex=index;
      }break;
      case 1:{
        _currentIndex=index;
      }break;
    }
    setState(() { _currentIndex = index;});
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
            child: DownloadPage(),
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
            icon: new Icon(Icons.home),
            title: new Text("Ara"),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.favorite),
            title: new Text("İndirilenler", style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
