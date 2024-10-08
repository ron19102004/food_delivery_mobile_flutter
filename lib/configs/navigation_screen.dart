import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/datasource/services/auth_service.dart';
import 'package:mobile/presentation/screens/auth/login_screen.dart';
import 'package:mobile/presentation/screens/auth/register_screen.dart';
import 'package:mobile/presentation/screens/build_widget.dart';
import 'package:mobile/presentation/screens/personal/food/food_details_person_screen.dart';
import 'package:mobile/presentation/screens/personal/food/foods_by_category_id_screen.dart';
import 'package:mobile/presentation/screens/personal/home/home_person_screen.dart';
import 'package:mobile/presentation/screens/personal/layout.dart';
import 'package:mobile/presentation/screens/personal/my_order/my_order_person_screen.dart';
import 'package:mobile/presentation/screens/personal/profile/profile_person_screen.dart';
import 'package:mobile/presentation/screens/personal/profile/profile_seller_at_person_screen.dart';
import 'package:mobile/presentation/screens/personal/search/search_person_screen.dart';
import 'package:mobile/presentation/screens/personal/voucher/voucher_person_screen.dart';

enum RoutePath {
  homePersonalScreen(path: "/home"),
  profilePersonScreen(path: "/profile"),
  voucherPersonScreen(path: "/voucher"),
  loginScreen(path: "/login"),
  registerScreen(path: "/register"),
  foodDetailsPersonScreen(path: "details/:foodId"),
  foodsByCategoryIdPersonScreen(
      path: "foods_category/:categoryId/:categoryName"),
  sellerDetailsAtPersonScreen(path: "seller/details/:id"),
  searchProductPersonScreen(path: "search"),
  myOrderPersonScreen(path: "myOrder");

  final String path;

  const RoutePath({required this.path});
}

String? _redirectWhenAuth() {
  return AuthService.isAuthenticated ? null : RoutePath.loginScreen.path;
}

enum BottomBarIndex{
  home(idx: 0),
  voucher(idx: 1),
  me(idx: 2);
  final int idx;
  const BottomBarIndex({required this.idx});
}
class BottomBarState {
  static int indexPersonBottomBar = BottomBarIndex.home.idx;
}

final GoRouter router = GoRouter(
  initialLocation: RoutePath.homePersonalScreen.path,
  // initialLocation: "/",
  routes: <RouteBase>[
    GoRoute(
      path: "/",
      name: "/",
      builder: (context, state) {
        return const BuildWidget();
      },
    ),
    GoRoute(
      path: RoutePath.loginScreen.path,
      name: RoutePath.loginScreen.name,
      builder: (context, state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: RoutePath.registerScreen.path,
      name: RoutePath.registerScreen.name,
      builder: (context, state) {
        return const RegisterScreen();
      },
    ),
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
                routes: [
                  GoRoute(
                    path: RoutePath.foodDetailsPersonScreen.path,
                    name: RoutePath.foodDetailsPersonScreen.name,
                    builder: (context, state) {
                      return FoodDetailsPersonScreen(
                          foodId: int.parse(
                              state.pathParameters["foodId"] ?? "-1"));
                    },
                  ),
                  GoRoute(
                    path: RoutePath.foodsByCategoryIdPersonScreen.path,
                    name: RoutePath.foodsByCategoryIdPersonScreen.name,
                    builder: (context, state) {
                      return FoodsByCategoryIdScreen(
                          categoryName: state.pathParameters["categoryName"] ??
                              "Unknown category",
                          categoryId: int.parse(
                              state.pathParameters["categoryId"] ?? "-1"));
                    },
                  ),
                  GoRoute(
                    path: RoutePath.sellerDetailsAtPersonScreen.path,
                    name: RoutePath.sellerDetailsAtPersonScreen.name,
                    builder: (context, state) {
                      return ProfileSellerAtPersonScreen(
                          id: int.parse(state.pathParameters["id"] ?? "0"));
                    },
                  ),
                  GoRoute(
                    path: RoutePath.searchProductPersonScreen.path,
                    name: RoutePath.searchProductPersonScreen.name,
                    builder: (context, state) {
                      return const SearchPersonScreen();
                    },
                  )
                ]),
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
                redirect: (context, state) {
                  return _redirectWhenAuth();
                },
                routes: [
                  GoRoute(
                    path: RoutePath.myOrderPersonScreen.path,
                    name: RoutePath.myOrderPersonScreen.name,
                    builder: (context, state) {
                      return const MyOrderPersonScreen();
                    },
                  ),
                ])
          ])
        ]),
  ],
);
