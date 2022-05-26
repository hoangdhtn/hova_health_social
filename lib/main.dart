import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_app/src/model/department_model.dart';
import 'package:health_app/src/providers/category_provider.dart';
import 'package:health_app/src/providers/department_provider.dart';
import 'package:health_app/src/providers/medical_provider.dart';
import 'package:health_app/src/providers/news_provider.dart';
import 'package:health_app/src/providers/user_provider.dart';
import 'package:health_app/src/theme/theme.dart';
import 'package:provider/provider.dart';

import 'src/config/route.dart';
import 'src/providers/auth.dart';
import 'src/providers/booking_provider.dart';
import 'src/providers/doctor_provider.dart';
import 'src/providers/post_provider.dart';

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
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => MedicalProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
        ChangeNotifierProvider(create: (_) => DepartmentProvider()),
        ChangeNotifierProvider(create: (_) => DoctorProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
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
