// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    ArtworkDetailRoute.name: (routeData) {
      final args = routeData.argsAs<ArtworkDetailRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ArtworkDetailScreen(
          key: args.key,
          objectId: args.objectId,
        ),
      );
    },
    ArtworkListRoute.name: (routeData) {
      final args = routeData.argsAs<ArtworkListRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: ArtworkListScreen(
          key: args.key,
          title: args.title,
          objects: args.objects,
        ),
      );
    },
    CollectionRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const CollectionScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeScreen(),
      );
    },
    InfoRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const InfoScreen(),
      );
    },
    MainRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MainScreen(),
      );
    },
    SearchCollectionsRoute.name: (routeData) {
      final args = routeData.argsAs<SearchCollectionsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: SearchCollectionsScreen(
          key: args.key,
          departmentId: args.departmentId,
          departmentName: args.departmentName,
        ),
      );
    },
    SplashRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SplashScreen(),
      );
    },
  };
}

/// generated route for
/// [ArtworkDetailScreen]
class ArtworkDetailRoute extends PageRouteInfo<ArtworkDetailRouteArgs> {
  ArtworkDetailRoute({
    Key? key,
    required int objectId,
    List<PageRouteInfo>? children,
  }) : super(
          ArtworkDetailRoute.name,
          args: ArtworkDetailRouteArgs(
            key: key,
            objectId: objectId,
          ),
          initialChildren: children,
        );

  static const String name = 'ArtworkDetailRoute';

  static const PageInfo<ArtworkDetailRouteArgs> page =
      PageInfo<ArtworkDetailRouteArgs>(name);
}

class ArtworkDetailRouteArgs {
  const ArtworkDetailRouteArgs({
    this.key,
    required this.objectId,
  });

  final Key? key;

  final int objectId;

  @override
  String toString() {
    return 'ArtworkDetailRouteArgs{key: $key, objectId: $objectId}';
  }
}

/// generated route for
/// [ArtworkListScreen]
class ArtworkListRoute extends PageRouteInfo<ArtworkListRouteArgs> {
  ArtworkListRoute({
    Key? key,
    required String title,
    required List<ObjectModel> objects,
    List<PageRouteInfo>? children,
  }) : super(
          ArtworkListRoute.name,
          args: ArtworkListRouteArgs(
            key: key,
            title: title,
            objects: objects,
          ),
          initialChildren: children,
        );

  static const String name = 'ArtworkListRoute';

  static const PageInfo<ArtworkListRouteArgs> page =
      PageInfo<ArtworkListRouteArgs>(name);
}

class ArtworkListRouteArgs {
  const ArtworkListRouteArgs({
    this.key,
    required this.title,
    required this.objects,
  });

  final Key? key;

  final String title;

  final List<ObjectModel> objects;

  @override
  String toString() {
    return 'ArtworkListRouteArgs{key: $key, title: $title, objects: $objects}';
  }
}

/// generated route for
/// [CollectionScreen]
class CollectionRoute extends PageRouteInfo<void> {
  const CollectionRoute({List<PageRouteInfo>? children})
      : super(
          CollectionRoute.name,
          initialChildren: children,
        );

  static const String name = 'CollectionRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [InfoScreen]
class InfoRoute extends PageRouteInfo<void> {
  const InfoRoute({List<PageRouteInfo>? children})
      : super(
          InfoRoute.name,
          initialChildren: children,
        );

  static const String name = 'InfoRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MainScreen]
class MainRoute extends PageRouteInfo<void> {
  const MainRoute({List<PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SearchCollectionsScreen]
class SearchCollectionsRoute extends PageRouteInfo<SearchCollectionsRouteArgs> {
  SearchCollectionsRoute({
    Key? key,
    required int departmentId,
    required String departmentName,
    List<PageRouteInfo>? children,
  }) : super(
          SearchCollectionsRoute.name,
          args: SearchCollectionsRouteArgs(
            key: key,
            departmentId: departmentId,
            departmentName: departmentName,
          ),
          initialChildren: children,
        );

  static const String name = 'SearchCollectionsRoute';

  static const PageInfo<SearchCollectionsRouteArgs> page =
      PageInfo<SearchCollectionsRouteArgs>(name);
}

class SearchCollectionsRouteArgs {
  const SearchCollectionsRouteArgs({
    this.key,
    required this.departmentId,
    required this.departmentName,
  });

  final Key? key;

  final int departmentId;

  final String departmentName;

  @override
  String toString() {
    return 'SearchCollectionsRouteArgs{key: $key, departmentId: $departmentId, departmentName: $departmentName}';
  }
}

/// generated route for
/// [SplashScreen]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
