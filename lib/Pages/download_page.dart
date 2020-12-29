import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tubeleech/Models/videos.dart';
import 'package:tubeleech/utils/downcontroller.dart';
class DownloadPage extends StatefulWidget {

  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {

  @override
  void initState() {
    DownController.listofFiles();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: ValueListenableBuilder(
            valueListenable: Hive.box<Videos>("videos").listenable(),
            builder: (context, Box<Videos> box, _) {
            return ListView.builder(
              itemCount: box.values.length,
              itemBuilder: (BuildContext context, int index) {
                Videos currentVideo = box.getAt(index);
                if (box.values.isEmpty)
                  return Center(
                    child: Text("No contacts"),
                  );
                return ListTile(
                  onTap: () {
                    DownController.listofFiles();
                    DownController.openFile(currentVideo, context);
                  },
                  leading: Icon(Icons.music_note_sharp),
                  title: Text(currentVideo.isim),
                  subtitle: Text(currentVideo.tur),
                  trailing: IconButton(icon: Icon(Icons.delete),
                    onPressed: ()async{
                      DownController.deleteFile(currentVideo,context);
                  },),
                );
              },
            );
          }
        ),
      ),
    );
  }
}
