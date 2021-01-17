import 'package:hive/hive.dart';

part 'musics.g.dart';

@HiveType(typeId: 2)
class Musics{
  @HiveField(0)
  String id;
  @HiveField(1)
  String isim;
  @HiveField(2)
  String tur;
  @HiveField(3)
  String yol;
  @HiveField(4)
  bool active;
  @HiveField(5)
  String thumbnail;



  Musics({this.id,this.isim,this.tur,this.yol,this.active,this.thumbnail });

}