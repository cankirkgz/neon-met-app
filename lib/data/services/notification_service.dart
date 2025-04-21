import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:neon_met_app/data/models/object_model.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> initNotification() async {
    if (_isInitialized) return;

    // iOS için bildirim izni iste
    final iosPlugin = notificationsPlugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();

    await iosPlugin?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Zaman dilimi ayarları
    tz_data.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    const initSettingAndroid = AndroidInitializationSettings('ic_notification');
    const initSettingIOS = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: initSettingAndroid,
      iOS: initSettingIOS,
    );

    await notificationsPlugin.initialize(initSettings);
    _isInitialized = true;
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id',
        'Daily Notifications',
        channelDescription: 'Daily Notification Channel',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    return notificationsPlugin.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_channel_id',
          'Daily Notifications',
          channelDescription: 'Daily Notification Channel',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> scheduleNotification({
    int id = 1,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelAllNotifications() async {
    await notificationsPlugin.cancelAll();
  }

  Future<int?> getRandomObjectId() async {
    final response = await Dio().get(
      'https://collectionapi.metmuseum.org/public/collection/v1/search',
      queryParameters: {'q': '*', 'hasImages': true, 'isHighlight': true},
    );

    final ids = List<int>.from(response.data['objectIDs'] ?? []);
    if (ids.isEmpty) return null;

    ids.shuffle();
    return ids.first;
  }

  Future<ObjectModel?> getRandomArtwork() async {
    final id = await getRandomObjectId();
    if (id == null) return null;

    final response = await Dio().get(
      'https://collectionapi.metmuseum.org/public/collection/v1/objects/$id',
    );

    if (response.statusCode == 200) {
      return ObjectModel.fromJson(response.data);
    }

    return null;
  }

  Future<void> scheduleRandomArtworkNotification({
    int id = 1,
    int hour = 9,
    int minute = 0,
  }) async {
    final artwork = await getRandomArtwork();
    if (artwork == null) return;

    const title = "Art Time! 🎨";
    final body =
        'Explore a masterpiece: "${artwork.title}" (${artwork.artistDisplayName ?? 'Unknown Artist'}) – from the ${artwork.department ?? 'Museum Collection'}.';

    final now = tz.TZDateTime.now(tz.local);

    final scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time, // her gün aynı saatte
    );
  }
}
