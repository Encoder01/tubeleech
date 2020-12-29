import 'package:get_it/get_it.dart';
import 'package:tubeleech/Repo/video_repo.dart';

import 'package:tubeleech/utils/services.dart';

final getIt = GetIt.instance;


void setupLocator() {
  getIt.registerLazySingleton(() => Services());
  getIt.registerLazySingleton(() => VideoRepository());
  print("registered");
}