import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/presentation/screens/personal/home/home_person_screen.dart';
import 'package:mobile/presentation/screens/personal/layout.dart';
import 'package:mobile/presentation/screens/personal/profile/profile_person_screen.dart';
import 'package:mobile/presentation/screens/personal/voucher/voucher_person_screen.dart';

enum RoutePath {
  homePersonalScreen(path: "/home"),
  profilePersonScreen(path: "/profile"),
  voucherPersonScreen(path: "/voucher");

  final String path;

  const RoutePath({required this.path});
}

final GoRouter router = GoRouter(
  initialLocation: RoutePath.homePersonalScreen.path,
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return PersonalLayout(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePath.homePersonalScreen.path,
              name: RoutePath.homePersonalScreen.name,
              builder: (context, state) {
                return const HomePersonScreen();
              },
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePath.voucherPersonScreen.path,
              name: RoutePath.voucherPersonScreen.name,
              builder: (context, state) {
                return const VoucherPersonScreen();
              },
            )
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: RoutePath.profilePersonScreen.path,
              name: RoutePath.profilePersonScreen.name,
              builder: (context, state) {
                return const ProfilePersonScreen();
              },
            )
          ])
        ]),
  ],
);
