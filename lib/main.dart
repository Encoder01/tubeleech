
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:open_file/open_file.dart';
import 'package:tubeleech/Bloc/player_bloc.dart';
import 'package:tubeleech/Bloc/videos_bloc.dart';
import 'package:tubeleech/Models/settings.dart';
import 'package:tubeleech/Models/videos.dart';
import 'package:tubeleech/Pages/bottom_page.dart';
import 'Models/musics.dart';
import 'Repo/locator.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
 FirebaseApp Getapp;
void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  var initializationSettingsAndroid = AndroidInitializationSettings("ic_launcher");
  var initializationSettingsIos = IOSInitializationSettings(
    requestAlertPermission: true,
    requestSoundPermission: true,
    requestBadgePermission: true,
    onDidReceiveLocalNotification: (id, title, body, payload) async {},);
  var initilizationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIos);
  await flutterLocalNotificationsPlugin.initialize(initilizationSettings,
      onSelectNotification: (String payload) async {
        if (payload != null) {
          debugPrint('notification payload: ' + payload);
          OpenFile.open(payload);
        }
      });
  Getapp=await Firebase.initializeApp(
    name: 'db2',
    options:  FirebaseOptions(
      appId: '1:217290449880:android:8965c64d6d72b0143008ad',
      apiKey: 'AIzaSyDlwCtv-epijU2QzlnY4flS64IT3q41qao',
      messagingSenderId: '297855924061',
      projectId: 'tubeleech-4fde1',
      databaseURL: 'https://tubeleech-4fde1-default-rtdb.europe-west1.firebasedatabase.app/',
    ),
  );
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(VideosAdapter());
  Hive.registerAdapter(MusicsAdapter());
  Hive.registerAdapter(SettingsAdapter());
  await Hive.openBox<Videos>("videos");
  await Hive.openBox<Musics>("musics");
  await Hive.openBox<Settings>("settings");
  //FirebaseAdMob.instance.initialize(appId: AdmobService().getAdMobId());
  runApp(EasyLocalization(
      child: MyApp(),
    startLocale: Locale('en', 'US'),
    supportedLocales: [Locale('en', 'US'), Locale('tr', 'TR'), Locale('ru', 'RU')],
    path: 'assets/translations',
    fallbackLocale: Locale('en', 'US'),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      home: MyHomePage(),
    );
  }

}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => VideosBloc()),
      BlocProvider(create: (context) => PlayerBloc())
    ], child: BottomPage());

  }
}
