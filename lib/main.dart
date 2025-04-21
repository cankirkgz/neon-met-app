import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:neon_met_app/core/theme/app_theme.dart';
import 'package:neon_met_app/data/models/favorite_artwork.dart';
import 'package:neon_met_app/data/services/favorite_service.dart';
import 'package:neon_met_app/data/services/notification_service.dart';
import 'package:neon_met_app/viewmodel/department_viewmodel.dart';
import 'package:neon_met_app/viewmodel/info_viewmodel.dart';
import 'package:neon_met_app/viewmodel/object_viewmodel.dart';
import 'package:neon_met_app/viewmodel/search_collections_viewmodel.dart';
import 'routes/app_router.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

final _appRouter = AppRouter();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocDir = await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocDir.path);

  Hive.registerAdapter(FavoriteArtworkAdapter());

  await Hive.openBox<FavoriteArtwork>('favorites');

  await FavoriteService().init();

  final notificationService = NotificationService();
  await notificationService.initNotification();
  await notificationService.cancelAllNotifications();
  await notificationService.scheduleRandomArtworkNotification();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DepartmentViewModel()),
        ChangeNotifierProvider(create: (_) => ObjectViewModel()),
        ChangeNotifierProvider(create: (_) => InfoViewModel()),
        ChangeNotifierProvider(create: (_) => SearchCollectionsViewModel()),
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
      routerConfig: _appRouter.config(),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}
