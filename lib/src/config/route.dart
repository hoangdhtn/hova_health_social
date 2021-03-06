import 'package:flutter/material.dart';
import 'package:health_app/src/pages/booking_detail_page.dart';
import 'package:health_app/src/pages/login_page.dart';
import 'package:health_app/src/pages/medical_add_page.dart';
import 'package:health_app/src/pages/medical_page.dart';
import 'package:health_app/src/pages/personal_page.dart';
import 'package:health_app/src/pages/register_page.dart';
import 'package:health_app/src/pages/social_add_post_page.dart';
import 'package:health_app/src/pages/social_page.dart';

import '../pages/booking_page.dart';
import '../pages/category_detail_page.dart';
import '../pages/department_page.dart';
import '../pages/detail_page.dart';
import '../pages/doctor_detail_page.dart';
import '../pages/forget_pass_page.dart';
import '../pages/home_page.dart';
import '../pages/list_booking_page.dart';
import '../pages/listdoctor_page.dart';
import '../pages/medical_all_page.dart';
import '../pages/medical_detail_page.dart';
import '../pages/medical_today_add_page.dart';
import '../pages/medical_today_page.dart';
import '../pages/personal_setting_page.dart';
import '../pages/social_post_detail.dart';
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
      '/CategoryDetailPage': (_) => CategoryDetailPage(),
      '/MedicalAllPage': (_) => MedicalAllPage(),
      '/MedicalDetailPage': (_) => MedicalDetailPage(),
      '/MedicalTodayPage': (_) => MedicalTodayPage(),
      '/MedicalTodayAddPage': (_) => MedicalTodayAddPage(),
      '/MedicalAddPage': (_) => MedicalAddPage(),
      '/SocialAddPostPage': (_) => SocialAddPostPage(),
      '/SocialPostDetail': (_) => SocialPostDetail(),
      '/BookingPage': (_) => BookingPage(),
      '/ListDoctorPage': (_) => ListDoctorPage(),
      '/DoctorDetailPage': (_) => DoctorDetailPage(),
      '/BookingDetailPage': (_) => BookingDetailPage(),
      '/ListBookingPage': (_) => ListBookingPage(),
      '/PersonalSettingPage': (_) => PersonalSettingPage(),
      '/DepartmentPage': (_) => DepartmentPage(),
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
        break;
      case "CategoryDetailPage":
        return CustomRoute<bool>(
            builder: (BuildContext context) => CategoryDetailPage(
                  model: settings.arguments,
                ));
        break;
    }
  }
}
