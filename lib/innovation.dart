import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../firebase_config.dart';
import 'Chat/cubit/chatcubit_cubit.dart';
import 'app.dart';
import 'config/flavor_config.dart';

Future<void> main() async {
  FlavorConfig(
      flavor: Flavor.INNOVATION,
      values: FlavorValues(
        baseUrl: "https://schooleverywhere-innovation.com/schooleverywhere/",
        schoolName: 'Innovation International School',
        imagePath: 'img/innovation.png',
        schoolWebsite: 'https://innovation-schools.com/',
      ));

  WidgetsFlutterBinding.ensureInitialized();
  // Bloc.observer = AppBlocObserver();

  await Firebase.initializeApp();

  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }

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
