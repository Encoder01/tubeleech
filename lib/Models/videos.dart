import 'package:hive/hive.dart';

part 'videos.g.dart';

@HiveType(typeId: 0)
class Videos{
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


  Videos({this.id,this.isim,this.tur,this.yol,this.active});

}