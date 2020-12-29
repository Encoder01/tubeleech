import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:open_file/open_file.dart';
import 'package:tubeleech/Bloc/videos_bloc.dart';
import 'package:tubeleech/Models/videos.dart';
import 'package:tubeleech/Pages/bottom_page.dart';
import 'Repo/locator.dart';
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  var initializationSettingsAndroid = AndroidInitializationSettings("ic_launcher");
  var initializationSettingsIos = IOSInitializationSettings(
    requestAlertPermission: true,
    requestSoundPermission: true,
    requestBadgePermission: true,
    onDidReceiveLocalNotification: (id, title, body, payload) async{},);
  var initilizationSettings=InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIos);
  await flutterLocalNotificationsPlugin.initialize(initilizationSettings,
      onSelectNotification: (String payload) async {
        if (payload != null) {
          debugPrint('notification payload: ' + payload);
          OpenFile.open(payload);
        }
      });
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(VideosAdapter());
  await Hive.openBox<Videos>("videos");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
    return BlocProvider<VideosBloc>(
      child: BottomPage(),
      create: (context) => VideosBloc(),
    );
  }
}
