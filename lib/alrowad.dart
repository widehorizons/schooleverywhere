import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'Chat/app_bloc_observer.dart';
import 'Chat/cubit/chatcubit_cubit.dart';
import 'app.dart';
import 'config/flavor_config.dart';
import 'firebase_config.dart';

Future<void> main() async {
  FlavorConfig(
      flavor: Flavor.SCHOOLEVERYWHERE,
      values: FlavorValues(
          baseUrl: "https://schooleverywhere-alrowad.com/schooleverywhere/",
          schoolName: 'Al Rowad Language School Tanta',
          imagePath: 'img/alrowad.png',
          schoolWebsite: 'https://schooleverywhere-alrowad.com/',
          audioFilePath:
              '/data/user/0/com.schooleverywhere-alrowad/cache/audio.wav'));

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = AppBlocObserver();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  await FlutterDownloader.initialize(debug: true);
  runApp(new BlocProvider(create: (context) => ChatCubit(), child: MyApp()));
}
