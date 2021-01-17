import 'package:firebase_database/firebase_database.dart';

import '../main.dart';

class Constants{


  static   String Search ="";
  static   String firstSearch ="";
  static  String KEY2 ="";
  static Future<String> getKEY() async {
    final DataSnapshot database = await FirebaseDatabase(app:Getapp ).reference().child('Key').once();
    final DataSnapshot database2 = await FirebaseDatabase(app:Getapp ).reference().child('search').once();
    KEY2=database.value;
    firstSearch=database2.value;
    return KEY2;
  }
}