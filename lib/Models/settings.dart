
import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 1)
class Settings{
  @HiveField(0)
  bool oneriler;
  @HiveField(1)
  bool closeNtf;
  @HiveField(2)
  bool usePlayer;
  @HiveField(3)
  bool chosePlayer;
  @HiveField(4)
  String path;
  @HiveField(5)
  bool personelAds;

  Settings({this.oneriler,this.chosePlayer,this.closeNtf,this.usePlayer,this.path,this.personelAds});

}