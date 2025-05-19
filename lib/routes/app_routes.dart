import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:newsee/AppData/app_route_constants.dart';
import 'package:newsee/AppSamples/ReactiveForms/view/loginpage_view.dart';
import 'package:newsee/AppSamples/ToolBarWidget/view/toolbar_view.dart';
import 'package:newsee/Model/login_request.dart';
import 'package:newsee/blocs/login/login_bloc.dart';
import 'package:newsee/pages/home_page.dart';
import 'package:newsee/pages/newlead_page.dart';
import 'package:newsee/pages/masters_page.dart';
import 'package:newsee/pages/not_found_error.page.dart';

final routes = GoRouter(
  initialLocation: '/master',

  routes: <RouteBase>[
    GoRoute(
      path: AppRouteConstants.LOGIN_PAGE['path']!,
      name: AppRouteConstants.LOGIN_PAGE['name'],
      builder:
          (context, state) => Scaffold(
            body: BlocProvider(
              create:
                  (_) => LoginBloc(
                    loginRequest: LoginRequest(username: '', password: ''),
                  ),
              child: const LoginpageView(),
            ),
          ),
    ),
    GoRoute(
      path: AppRouteConstants.HOME_PAGE['path']!,
      name: AppRouteConstants.HOME_PAGE['name'],
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: AppRouteConstants.NEWLEAD_PAGE['path']!,
      name: AppRouteConstants.NEWLEAD_PAGE['name'],
      builder: (context, state) => NewLeadPage(),
    ),
    GoRoute(
      path: AppRouteConstants.MASTER_PAGE['path']!,
      name: AppRouteConstants.MASTER_PAGE['name'],
      builder: (context, state) => MastersPage(),
    ),
  ],
  redirect: (context, state) {
    print(state.fullPath);
    if (state.fullPath == '/') {
      return '/login';
    } else {
      return null;
    }
  },
  errorBuilder: (context, state) => NotFoundErrorPage(),
);
