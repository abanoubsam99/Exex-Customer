// import 'dart:io';
//
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// import '../../firebase_options.dart';
//
// class NotificationHelper {
//   static final NotificationHelper _instance = NotificationHelper._internal();
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   factory NotificationHelper() {
//     return _instance;
//   }
//
//   NotificationHelper._internal();
//
//   Future<void> initialize() async {
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//     await _initializeLocalNotifications();
//     await _requestPermissions();
//
//     _configureForegroundNotification();
//     _configureBackgroundNotification();
//     getToken();
//   }
//
//   Future<void> _initializeLocalNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher'); // Add your app icon here
//
//     const DarwinInitializationSettings initializationSettingsIOS =
//     DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );
//
//     const InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );
//
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }
//
//   Future<void> _requestPermissions() async {
//     NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//     print('User granted permission: ${settings.authorizationStatus}');
//   }
//
//   void _configureForegroundNotification() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Received a message while in the foreground!');
//       print('Message data: ${message.data}');
//
//       if (message.notification != null) {
//         print('Message also contained a notification: ${message.notification}');
//         _showNotification(message);
//       }
//     });
//   }
//
//   void _configureBackgroundNotification() {
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('A new onMessageOpenedApp event was published!');
//       print('Message data: ${message.data}');
//
//       if (message.notification != null) {
//         print('Message also contained a notification: ${message.notification}');
//       }
//     });
//   }
//
//   Future<void> _showNotification(RemoteMessage message) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//     AndroidNotificationDetails(
//       'your_channel_id', // Your channel ID
//       'your_channel_name', // Your channel name
//       channelDescription:'your_channel_description' ,
//       importance: Importance.max,
//       priority: Priority.high,
//       showWhen: false,
//     );
//
//     const DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails();
//
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//       iOS: iOSPlatformChannelSpecifics,
//     );
//
//     await flutterLocalNotificationsPlugin.show(
//       0, // Notification ID
//       message.notification?.title,
//       message.notification?.body,
//       platformChannelSpecifics,
//       payload: 'Notification Payload',
//     );
//   }
//
//   // static Future<String?> getToken() async {
//   //   String? token = await FirebaseMessaging.instance.getToken();
//   //   print("FCM Token: $token");
//   //   return token;
//   // }
//   static Future<String?> getToken() async {
//     String? token ="";
//     if (Platform.isIOS) {
//       token = await FirebaseMessaging.instance.getAPNSToken();
//       print("APNS Token: $token");
//     }else{
//       token = await FirebaseMessaging.instance.getToken();
//       print("FCM Token: $token");
//     }
//     return token;
//   }
// }
//
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('Handling a background message: ${message.messageId}');
// }
