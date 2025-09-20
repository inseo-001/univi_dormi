import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/main.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/services/auth_wrapper.dart';

import '/index.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  bool showSplashImage = true;

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      navigatorKey: appNavigatorKey,
      errorBuilder: (context, state) => StartPageWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => const AuthWrapper(),
        ),
        FFRoute(
          name: HomePageWidget.routeName,
          path: HomePageWidget.routePath,
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'HomePage')
              : HomePageWidget(),
        ),
        FFRoute(
          name: StartPageWidget.routeName,
          path: StartPageWidget.routePath,
          builder: (context, params) => StartPageWidget(),
        ),
        FFRoute(
          name: LoginMainWidget.routeName,
          path: LoginMainWidget.routePath,
          builder: (context, params) => LoginMainWidget(),
        ),
        FFRoute(
          name: JoinMainWidget.routeName,
          path: JoinMainWidget.routePath,
          builder: (context, params) => JoinMainWidget(),
        ),
        FFRoute(
          name: TermsofUseWidget.routeName,
          path: TermsofUseWidget.routePath,
          builder: (context, params) => TermsofUseWidget(),
        ),
        FFRoute(
          name: JoinCompleteWidget.routeName,
          path: JoinCompleteWidget.routePath,
          builder: (context, params) => JoinCompleteWidget(),
        ),
        FFRoute(
          name: PassWordFindWidget.routeName,
          path: PassWordFindWidget.routePath,
          builder: (context, params) => PassWordFindWidget(),
        ),
        FFRoute(
          name: PassWordCordWidget.routeName,
          path: PassWordCordWidget.routePath,
          builder: (context, params) => PassWordCordWidget(),
        ),
        FFRoute(
          name: PassworREWidget.routeName,
          path: PassworREWidget.routePath,
          builder: (context, params) => PassworREWidget(),
        ),
        FFRoute(
          name: CompletePassWordWidget.routeName,
          path: CompletePassWordWidget.routePath,
          builder: (context, params) => CompletePassWordWidget(),
        ),
        FFRoute(
            name: ChatingMainWidget.routeName,
            path: ChatingMainWidget.routePath,
            builder: (context, params) => params.isEmpty
                ? NavBarPage(initialPage: 'ChatingMain')
                : NavBarPage(
                    initialPage: 'ChatingMain',
                    page: ChatingMainWidget(),
                  )),
        FFRoute(
          name: ProfileMainWidget.routeName,
          path: ProfileMainWidget.routePath,
          builder: (context, params) => ProfileMainWidget(),
        ),
        FFRoute(
            name: Homepage2Widget.routeName,
            path: Homepage2Widget.routePath,
            builder: (context, params) => NavBarPage(
                  initialPage: '',
                  page: Homepage2Widget(),
                )),
        FFRoute(
            name: NoticeMainWidget.routeName,
            path: NoticeMainWidget.routePath,
            builder: (context, params) => NavBarPage(
                  initialPage: '',
                  page: NoticeMainWidget(),
                )),
        FFRoute(
            name: NoticeBigWidget.routeName,
            path: NoticeBigWidget.routePath,
            builder: (context, params) => NavBarPage(
                  initialPage: '',
                  page: NoticeBigWidget(),
                )),
        FFRoute(
          name: SleepoverMainWidget.routeName,
          path: SleepoverMainWidget.routePath,
          builder: (context, params) => SleepoverMainWidget(),
        ),
        FFRoute(
          name: CivilcomplaintMainWidget.routeName,
          path: CivilcomplaintMainWidget.routePath,
          builder: (context, params) => CivilcomplaintMainWidget(),
        ),
        FFRoute(
          name: JoinWidget.routeName,
          path: JoinWidget.routePath,
          builder: (context, params) => JoinWidget(),
        ),
        FFRoute(
          name: LeaveWidget.routeName,
          path: LeaveWidget.routePath,
          builder: (context, params) => LeaveWidget(),
        ),
        FFRoute(
          name: BBSListWidget.routeName,
          path: BBSListWidget.routePath,
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'BBSList')
              : BBSListWidget(),
        ),
        FFRoute(
          name: BBSMainWidget.routeName,
          path: BBSMainWidget.routePath,
          builder: (context, params) => BBSMainWidget(),
        ),
        FFRoute(
          name: BBSWriteWidget.routeName,
          path: BBSWriteWidget.routePath,
          builder: (context, params) => BBSWriteWidget(),
        ),
        FFRoute(
          name: MenuMainWidget.routeName,
          path: MenuMainWidget.routePath,
          builder: (context, params) => params.isEmpty
              ? NavBarPage(initialPage: 'menuMain')
              : MenuMainWidget(),
        ),
        FFRoute(
          name: MassageDetailRoommateCopyWidget.routeName,
          path: MassageDetailRoommateCopyWidget.routePath,
          builder: (context, params) => MassageDetailRoommateCopyWidget(),
        ),
        FFRoute(
          name: 'notificationList',
          path: '/notifications',
          builder: (context, params) => NotificationListWidget(),
        ),
        FFRoute(
          name: ScoreReasonWidget.routeName,
          path: ScoreReasonWidget.routePath,
          builder: (context, params) => ScoreReasonWidget(),
        ),
        FFRoute(
          name: ScoreMainWidget.routeName,
          path: ScoreMainWidget.routePath,
          builder: (context, params) => ScoreMainWidget(),
        ),
        FFRoute(
          name: ScoreApplicationWidget.routeName,
          path: ScoreApplicationWidget.routePath,
          builder: (context, params) => ScoreApplicationWidget(),
        )
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
