import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:health_app/src/pages/home_page.dart';
import 'package:health_app/src/pages/medical_page.dart';
import 'package:health_app/src/pages/personal_page.dart';
import 'package:health_app/src/pages/social_page.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int selectedpage = 0;
  final _pageOption = [HomePage(), MedicalPage(), SocialPage(), PersonalPage()];

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
                    icon: Icons.home,
                    text: 'Bệnh án',
                  ),
                  GButton(
                    icon: Icons.home,
                    text: 'Cộng đồng',
                  ),
                  GButton(
                    icon: Icons.home,
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
