import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:easy_folder_picker/FolderPicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:tubeleech/Models/settings.dart';
import 'package:easy_localization/easy_localization.dart';
class SettingsPage extends StatefulWidget {
  static bool chosePlayer = false;
  static bool oneriler = true;
  static bool closeNtf = false;
  static bool usePlayer = true;
  static bool personelAds = true;
  static String Path = "/storage/emulated/0/";

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Box<Settings> contactsBox;
  Directory selectedDirectory;

  Future<void> _pickDirectory(BuildContext context) async {
    Directory directory = selectedDirectory;
    if (directory == null) {
      directory = Directory(FolderPicker.ROOTPATH);
    }

    Directory newDirectory = await FolderPicker.pick(
        allowFolderCreation: true,
        context: context,
        rootDirectory: directory,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))));
    setState(() {
      selectedDirectory = newDirectory;
      SettingsPage.Path=selectedDirectory.path;
      put();
      print(selectedDirectory);
    });
  }

  @override
  void initState() {
    contactsBox   = Hive.box<Settings>('settings');
    if(contactsBox.isEmpty)
     { setup(Settings(
          oneriler: SettingsPage.oneriler,
          chosePlayer: SettingsPage.chosePlayer,
          closeNtf: SettingsPage.closeNtf,
          path: SettingsPage.Path,
          personelAds: SettingsPage.personelAds,
          usePlayer: SettingsPage.usePlayer));}
    else{
      setup(contactsBox.get(0));
    }
    super.initState();
  }

  setup(Settings settings) async {

    SettingsPage.chosePlayer = settings.chosePlayer;
    SettingsPage.oneriler = settings.oneriler;
    SettingsPage.closeNtf = settings.closeNtf;
    SettingsPage.usePlayer = settings.usePlayer;
    SettingsPage.personelAds = settings.personelAds;
    SettingsPage.Path=settings.path;
  }
  put(){

    contactsBox.put(0,Settings(
        oneriler: SettingsPage.oneriler,
        chosePlayer: SettingsPage.chosePlayer,
        closeNtf: SettingsPage.closeNtf,
        path: SettingsPage.Path,
        personelAds: SettingsPage.personelAds,
        usePlayer: SettingsPage.usePlayer));

    print(contactsBox.values.first.toString());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "search".tr(),
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2),)]),
                child: CheckboxListTile(
                  title: Text("suggest".tr()),
                  subtitle: Text("suggest2".tr()),
                  onChanged: (bool value) {
                    SettingsPage.oneriler = value;
                   put();
                    setState(() {});
                  },
                  value: SettingsPage.oneriler,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "downloads".tr(),
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 75,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2),)]),
                child: Center(
                  child: CheckboxListTile(
                    title: Text("notif".tr()),
                    subtitle: Text("notif2".tr()),
                    onChanged: (bool value) {
                      SettingsPage.closeNtf = value;
                      put();
                      setState(() {});
                    },
                    value: SettingsPage.closeNtf,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2),)]),
                child: CheckboxListTile(
                  title: Text("embed".tr()),
                  subtitle: Text("embed2".tr()),
                  onChanged: (bool value) {
                    SettingsPage.usePlayer = value;
                    put();
                    setState(() {});
                  },
                  value: SettingsPage.usePlayer,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "player".tr(),
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 75,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2),)]),
                child: Center(
                  child: ListTile(
                    title: Text("player2".tr()),
                    subtitle: Text("player3".tr()),
                    trailing: DropdownButton(
                      value: SettingsPage.chosePlayer,
                      onChanged: (value) {
                        SettingsPage.chosePlayer = value;
                        setState(() {
                          put();
                        });
                      },
                      items: [
                        DropdownMenuItem(
                          value: true,
                          child: Text("mp3"),
                        ),
                        DropdownMenuItem(
                          value: false,
                          child: Text("mp4"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 75,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2),)]),
                child: Center(
                  child: ListTile(
                    onTap: ()=>_pickDirectory(context),
                    title: Text("file".tr()),
                    subtitle: Text(path.basename(SettingsPage.Path)),
                    trailing: IconButton(icon: Icon(Icons.drive_file_move),onPressed: ()=>_pickDirectory(context),),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "other".tr(),
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: FlatButton(
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                color: Colors.red,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (contexts) {
                      return CupertinoAlertDialog(
                        title: Text("langtitle").tr(),
                        content: Container(
                          height: 200,
                          width: 200,
                          child: Scaffold(
                              backgroundColor: Colors.transparent,
                              body: Column(
                                children: [
                                  ListTile(
                                    title: Text("eng").tr(),
                                    onTap: () {
                                      EasyLocalization.of(context).locale = Locale('en', 'US');
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                      title: Text("rus").tr(),
                                      onTap: () {
                                        EasyLocalization.of(context).locale = Locale('ru', 'RU');
                                        Navigator.pop(context);
                                      }),
                                  ListTile(
                                      title: Text("turk").tr(),
                                      onTap: () {
                                        EasyLocalization.of(context).locale = Locale('tr', 'TR');
                                        Navigator.pop(context);
                                      }),
                                ],
                              )),
                        ),
                      );
                    },
                  );
                },
                child: ListTile(
                  title: Text(
                    "lang",
                    style: TextStyle(color: Colors.white),
                  ).tr(),
                  trailing: Icon(Icons.language,
                      color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2),)]),
                child: CheckboxListTile(
                  title: Text("personelads".tr()),
                  subtitle: Text("personelads2".tr()),
                  onChanged: (bool value) {
                    SettingsPage.personelAds = value;
                    put();
                    setState(() {});
                  },
                  value: SettingsPage.personelAds,
                ),
              ),
            ),
            Container(height: 50,)
          ],
        ),
      ),
    );
  }
}
