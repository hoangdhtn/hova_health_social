import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:health_app/src/pages/home_page.dart';
import 'package:health_app/src/pages/medical_page.dart';
import 'package:health_app/src/pages/personal_page.dart';
import 'package:health_app/src/pages/social_page.dart';

import '../pages/booking_page.dart';
import '../pages/department_page.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int selectedpage = 0;
  final _pageOption = [
    HomePage(),
    MedicalPage(),
    SocialPage(),
    DepartmentPage(),
    PersonalPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOption[selectedpage],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                rippleColor: Colors.grey[300],
                hoverColor: Colors.grey[100],
                gap: 8,
                activeColor: Colors.black,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 23, vertical: 12),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: Colors.grey[100],
                color: Colors.black,
                tabs: [
                  GButton(
                    icon: Icons.home,
                    text: 'Trang chủ',
                  ),
                  GButton(
                    icon: Icons.monitor_heart,
                    text: 'Bệnh án',
                  ),
                  GButton(
                    icon: Icons.volunteer_activism,
                    text: 'Cộng đồng',
                  ),
                  GButton(
                    icon: Icons.support_agent,
                    text: 'Tư vấn',
                  ),
                  GButton(
                    icon: Icons.manage_accounts,
                    text: 'Trang cá nhân',
                  ),
                ],
                selectedIndex: selectedpage,
                onTabChange: (index) {
                  setState(() {
                    selectedpage = index;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
