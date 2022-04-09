import 'package:flutter/material.dart';
import 'package:health_app/src/pages/login_page.dart';
import 'package:health_app/src/pages/medical_page.dart';
import 'package:health_app/src/pages/personal_page.dart';
import 'package:health_app/src/pages/register_page.dart';
import 'package:health_app/src/pages/social_page.dart';

import '../pages/detail_page.dart';
import '../pages/forget_pass_page.dart';
import '../pages/home_page.dart';
import '../pages/splash_page.dart';
import '../widgets/coustom_route.dart';
import '../widgets/navigation.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoute() {
    return <String, WidgetBuilder>{
      '/': (_) => SplashPage(),
      '/LoginPage': (_) => LoginPage(),
      '/RegisterPage': (_) => RegisterPage(),
      '/ForgetPassPage': (_) => ForgetPassPage(),
      '/BottomNavigation': (_) => BottomNavigation(),
      '/HomePage': (_) => HomePage(),
      '/MedicalPage': (_) => MedicalPage(),
      '/SocialPage': (_) => SocialPage(),
      '/PersonalPage': (_) => PersonalPage(),
    };
  }

  static Route onGenerateRoute(RouteSettings settings) {
    final List<String> pathElements = settings.name.split('/');
    if (pathElements[0] != '' || pathElements.length == 1) {
      return null;
    }
    switch (pathElements[1]) {
      case "DetailPage":
        return CustomRoute<bool>(
            builder: (BuildContext context) => DetailPage(
                  model: settings.arguments,
                ));
    }
  }
}
