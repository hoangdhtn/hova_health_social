import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_app/src/providers/news_provider.dart';
import 'package:health_app/src/providers/user_provider.dart';
import 'package:health_app/src/theme/theme.dart';
import 'package:provider/provider.dart';

import 'src/config/route.dart';
import 'src/providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider())
      ],
      child: MaterialApp(
        title: 'Health Care',
        theme: AppTheme.lightTheme,
        routes: Routes.getRoute(),
        onGenerateRoute: (settings) => Routes.onGenerateRoute(settings),
        debugShowCheckedModeBanner: false,
        initialRoute: "SplashPage",
      ),
    );
  }
}
