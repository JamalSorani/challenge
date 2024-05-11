import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_challenge/core/routes_names.dart';
import 'package:new_challenge/feautures/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:new_challenge/feautures/auth/presentation/pages/login_page.dart';
import 'core/pages/frame_page.dart';
import 'core/pages/splash_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState!;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<AuthBloc>()
            ..add(
              TryAutoLoginEvent(),
            ),
        ),
      ],
      child: MaterialApp(
        supportedLocales: const [Locale('en'), Locale('ar')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        navigatorKey: _navigatorKey,
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: BlocListener<AuthBloc, AuthState>(
              listener: ((context, state) {
                switch (state) {
                  case LoggedInState():
                    _navigator.pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => state.authModel.isFirstLogin
                            ? const Center(
                                child: Text('new challenge page'),
                              )
                            : const Center(
                                child: Text('home page'),
                              ),
                      ),
                      (route) => false,
                    );
                  case LoggingInState():
                    _navigator.pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const SplashPage(),
                      ),
                      (route) => false,
                    );

                  case LoggedOutState():
                    _navigator.pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => state.goToLoginPage
                            ? const LoginPage()
                            : const FramePage(),
                      ),
                      (route) => false,
                    );
                  case LoadingState():
                    break;
                  case ErrorState():
                    break;
                }
              }),
              child: child,
            ),
          );
        },
        onGenerateRoute: (settings) =>
            MaterialPageRoute(builder: (context) => const SplashPage()),
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xffffffff),
            elevation: 0,
          ),
          primaryColor: const Color(0xffF1B820),
          fontFamily: 'Cairo',
        ),
        routes: {
          RoutesNames.login: (context) => const LoginPage(),
          // RoutesNames.createAccount: (context) => const CreateAccountScreen(),
          // RoutesNames.newChallenge: (context) => const NewChallengeScreen(),
          // '/forget_pass': (context) => const ForgetPassScreen(),
          // '/return_code': (context) => const ReturnCodeScreen(),
          // '/return_pass': (context) => const ReturnPassScreen(),
          // RoutesNames.home: (context) => const HomeScreen(),
        },
      ),
    );
  }
}
