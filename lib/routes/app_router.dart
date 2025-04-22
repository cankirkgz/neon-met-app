import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:neon_met_app/data/models/object_model.dart';
import 'package:neon_met_app/views/artworks/artwork_detail_screen.dart';
import 'package:neon_met_app/views/artworks/artwork_list_screen.dart';
import 'package:neon_met_app/views/collections/collection_screen.dart';
import 'package:neon_met_app/views/collections/search_collections.dart';
import 'package:neon_met_app/views/home/home_screen.dart';
import 'package:neon_met_app/views/info/info_screen.dart';
import 'package:neon_met_app/views/main_screen.dart';
import 'package:neon_met_app/views/splash/splash_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(
          page: MainRoute.page,
          path: '/',
          children: [
            AutoRoute(page: HomeRoute.page, path: 'home', initial: true),
            AutoRoute(page: CollectionRoute.page, path: 'collection'),
            AutoRoute(page: InfoRoute.page, path: 'info'),
          ],
        ),
        AutoRoute(page: ArtworkDetailRoute.page),
        AutoRoute(page: ArtworkListRoute.page),
        AutoRoute(page: SearchCollectionsRoute.page),
      ];
}
