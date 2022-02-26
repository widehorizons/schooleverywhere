import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:schooleverywhere/Chat/cubit/chatcubit_cubit.dart';
import 'Chat/app_bloc_observer.dart';
import 'Pages/SplashScreen.dart';
import 'Staff/SendToClass.dart';
import 'Student/ReceiveFromTeacher.dart';
import 'Student/MailInboxPage.dart';
import 'Student/Attendance.dart';
import 'Student/StudentAssignments.dart';
import 'Pages/StudentPage.dart';
import 'Pages/StaffPage.dart';
import 'Pages/ParentPage.dart';
import 'Staff/Assignments.dart';
import 'Pages/ManagementPage.dart';
import 'SharedPreferences/Prefs.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = AppBlocObserver();
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

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  await FlutterDownloader.initialize();
  runApp(new BlocProvider(create: (context) => ChatCubit(), child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: "Main Navigator");
  String textValue = 'Hello World !';
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  late ChatCubit chatCubit;

  String? typeUser;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getLoggedInUser();
    chatCubit = BlocProvider.of<ChatCubit>(context);
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      print("Message recived ${message!.data}");
      _notificationNavigator(message);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('A new onMessage event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'mipmap/ic_launcher',
              ),
            ));
      }
      _notificationNavigator(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Map<String, dynamic> messageData = message.data;
      print('A new onMessageOpenedApp event was published!' +
          messageData['screen'].toString());
      _notificationNavigator(message);
    });
  }

  Future<void> getLoggedInUser() async {
    String? type = await (getUserType());
    setState(() {
      typeUser = type;
    });
  }

  void _notificationNavigator(RemoteMessage? message) {
    Map<String, dynamic> messageData = message!.data;
    print("Notification Data ==================>> $messageData");
    switch (messageData['screen']) {
      case "ReceiveFromTeacher":
        navigatorKey.currentState!.push(
            MaterialPageRoute(builder: (_) => ReceiveFromTeacher(typeUser!)));
        break;
      case "Mail Inbox":
        navigatorKey.currentState!
            .push(MaterialPageRoute(builder: (_) => MailInboxPage(typeUser!)));
        break;
      case "New Mailbox":
        navigatorKey.currentState!
            .push(MaterialPageRoute(builder: (_) => MailInboxPage(typeUser!)));
        break;
      case "Student Attendance":
        navigatorKey.currentState!
            .push(MaterialPageRoute(builder: (_) => Attendance(typeUser!)));
        break;
      case "Assignment":
        navigatorKey.currentState!.push(
            MaterialPageRoute(builder: (_) => StudentAssignments(typeUser!)));
        break;
      case "Reply Send to class":
        print("Notification Data For Chat ==================>> $messageData");
        chatCubit.getAllMessages(
            messageData['role'], messageData['id'], messageData['regno'],
            staffid: messageData['staffid']);

        break;
      case "Reply Assignment":
        navigatorKey.currentState!
            .push(MaterialPageRoute(builder: (_) => Assignments()));
        break;
      default:
        if (typeUser == "Student") {
          navigatorKey.currentState!
              .push(MaterialPageRoute(builder: (_) => StudentPage()));
        } else if (typeUser == "Staff") {
          navigatorKey.currentState!
              .push(MaterialPageRoute(builder: (_) => StaffPage()));
        } else if (typeUser == "Parent") {
          navigatorKey.currentState!
              .push(MaterialPageRoute(builder: (_) => ParentPage()));
        } else if (typeUser == "Management") {
          navigatorKey.currentState!
              .push(MaterialPageRoute(builder: (_) => ManagementPage()));
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
