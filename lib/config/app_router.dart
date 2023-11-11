// // ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:register/login.dart';
import 'package:register/widget/button_custom/register_screens.dart';
import 'package:register/widget/maps_screens.dart';

final GoRouter appRouter = GoRouter(initialLocation: '/', routes: <RouteBase>[
  GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      }),
  GoRoute(
      path: '/registro',
      builder: (BuildContext context, GoRouterState state) {
        return const Register();
      }),
  GoRoute(
      path: '/mapa',
      builder: (BuildContext context, GoRouterState state) {
        return const MapSample();
      }),
]);
