// lib/main.dart
import 'package:flutter/material.dart';
import 'package:neon_met_app/core/theme/app_theme.dart';
import 'package:neon_met_app/data/services/notification_service.dart';
import 'package:neon_met_app/viewmodel/department_viewmodel.dart';
import 'package:neon_met_app/viewmodel/info_viewmodel.dart';
import 'package:neon_met_app/viewmodel/object_viewmodel.dart';
import 'package:neon_met_app/viewmodel/search_collections_viewmodel.dart';
import 'package:neon_met_app/viewmodel/favorite_viewmodel.dart';
import 'routes/app_router.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:neon_met_app/data/models/favorite_artwork.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocDir.path);
  Hive.registerAdapter(FavoriteArtworkAdapter());
  await Hive.openBox<FavoriteArtwork>('favorites');

  final notificationService = NotificationService();
  await notificationService.initNotification();
  await notificationService.cancelAllNotifications();

  // ⛑️ Burayı try-catch içine alıyoruz
  try {
    await notificationService.scheduleRandomArtworkNotification();
  } catch (e) {
    debugPrint('Bildirim planlama başarısız: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DepartmentViewModel()),
        ChangeNotifierProvider(create: (_) => ObjectViewModel()),
        ChangeNotifierProvider(create: (_) => InfoViewModel()),
        ChangeNotifierProvider(create: (_) => SearchCollectionsViewModel()),
        ChangeNotifierProvider(create: (_) {
          final favVm = FavoriteViewModel();
          favVm.init();
          return favVm;
        }),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter().config(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}
