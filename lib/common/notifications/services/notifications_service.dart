import 'dart:io';

import 'package:future_hub/common/graphql/graphql_client.dart';
import 'package:future_hub/common/notifications/graphql/notifications.gql.dart';
import 'package:future_hub/common/notifications/models/notification_model.dart';
import 'package:future_hub/common/shared/utils/fetch_exception.dart';
import 'package:future_hub/common/shared/utils/paginator_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:package_info_plus/package_info_plus.dart';

class NotificationsService {
  Future<PaginatorInfo<Notification>> getNotifications({int page = 1}) async {
    final result = await Client.current.queryNotifications(
      OptionsQueryNotifications(
        variables: VariablesQueryNotifications(
          page: page,
        ),
      ),
    );

    final data = result.parsedData?.notifications;
    final notifications = data!.data;
    final hasMorePages = data.paginatorInfo.hasMorePages;
    final total = data.paginatorInfo.total;

    if (result.hasException) {
      throw FetchException.fromOperation(result.exception!);
    }

    return PaginatorInfo(
      data: notifications
          .map(
            (notification) => Notification(
              id: notification.id,
              message: notification.message,
              createdAt: notification.created_at != null
                  ? DateTime.parse(notification.created_at!)
                  : null,
              seen: notification.seen == true,
            ),
          )
          .toList(),
      hasMorePages: hasMorePages,
      total: total,
    );
  }

  Future<void> handleFCMNotification() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
      playSound: true,
    );
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('img');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;

      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: "img",
            ),
          ));
    });

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
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
                icon: 'img',
              ),
            ));
      }
    });
  }

  Future<void> updateFCMToken({
    required String? token,
    required String userType,
  }) async {
    String platform = getPlatform();
    String version = await getAppVersion();
    String deviceId = await getDeviceID();

    final result = await Client.current.mutateUpdateFCMToken(
      OptionsMutationUpdateFCMToken(
        variables: VariablesMutationUpdateFCMToken(
          fcm_token: token!,
          device_id: deviceId,
          platform: platform,
          version: version,
        ),
      ),
    );

    FirebaseMessaging.instance.subscribeToTopic(userType);

    FirebaseMessaging.instance.onTokenRefresh.listen((event) async {
      updateFCMToken(
        userType: userType,
        token: await FirebaseMessaging.instance.getToken(),
      );
    });

    final data = result.parsedData?.updateFCMToken;
    final status = data?.status;
    final message = data?.message;

    if (result.hasException) {
      throw FetchException.fromOperation(result.exception!);
    }

    if (status == 'FAIL') {
      throw FetchException(message!);
    }

    debugPrint(message);
  }

  Future<String> getDeviceID() async {
    String deviceId = await FlutterUdid.udid;
    return deviceId;
  }

  Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    return version;
  }

  String getPlatform() {
    if (Platform.isIOS) {
      return "ios";
    } else if (Platform.isAndroid) {
      return "android";
    } else {
      return "not detected";
    }
  }
}
