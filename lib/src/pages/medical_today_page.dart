import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:health_app/src/model/medical_today_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_url.dart';
import '../model/user_model.dart';
import '../providers/user_provider.dart';
import '../theme/const.dart';
import '../widgets/cardMedicalToday.dart';
import '../widgets/card_section.dart';
import '../widgets/custom_clipper.dart';

class MedicalTodayPage extends StatefulWidget {
  const MedicalTodayPage({Key key}) : super(key: key);

  @override
  State<MedicalTodayPage> createState() => _MedicalTodayPageState();
}

class _MedicalTodayPageState extends State<MedicalTodayPage> {
  List<MedicalToday> list;
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    loadSharedPreferencesAndData();
    super.initState();
  }

  void loadSharedPreferencesAndData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loadData();
  }

  void loadData() {
    List<String> listString =
        sharedPreferences.getStringList('listMedicalToday');
    if (listString != null) {
      list = listString
          .map((item) => MedicalToday.fromMap(json.decode(item)))
          .toList();
      setState(() {
        list = list;
      });
    }
  }

  void saveData() {
    List<String> stringList =
        list.map((item) => json.encode(item.toMap())).toList();
    sharedPreferences.setStringList('listMedicalToday', stringList);
  }

  void removeItem(MedicalToday item) {
    list.remove(item);
    saveData();
    loadData();
  }

  void editCheckItem(MedicalToday item, bool check) {
    item.completed = check;
    saveData();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    User user;
    user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: MyCustomClipper(clipType: ClipType.bottom),
                  child: Container(
                    color: Theme.of(context).accentColor,
                    height: Constants.headerHeight + statusBarHeight - 30,
                  ),
                ),
                Positioned(
                  right: -45,
                  top: -30,
                  child: ClipOval(
                    child: Container(
                      color: Colors.black.withOpacity(0.05),
                      height: 220,
                      width: 220,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(Constants.paddingSide),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const <Widget>[
                          BackButton(
                            color: Colors.white,
                          ),
                        ],
                      ),
                      // Header - Greetings and Avatar
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              "Lịch trình thuốc hôm nay của,\n${user.full_name}",
                              style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white),
                            ),
                          ),
                          CircleAvatar(
                              radius: 26.0,
                              backgroundImage: user.avatar_url == null
                                  ? const AssetImage(
                                      'assets/icons/profile_picture.png')
                                  : NetworkImage(
                                      API_URL.getImage + user.avatar_url))
                        ],
                      ),

                      // Main Cards - Heartbeat and Blood Pressure

                      // Info Medical
                      SizedBox(height: 70),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "",
                            style: TextStyle(
                                color: Constants.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, "/MedicalTodayAddPage");
                            },
                            child: const Text(
                              "THÊM",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            list != null
                ? ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        background: Container(
                            color: Color.fromARGB(255, 255, 255, 255)),
                        direction: DismissDirection.endToStart,
                        onDismissed: (DismissDirection direction) {
                          removeItem(list[index]);
                        },
                        key: ValueKey<MedicalToday>(list[index]),
                        child: CardMedicalToday(
                          image: AssetImage('assets/icons/capsule.png'),
                          title: list[index].name,
                          value: list[index].info,
                          unit: "",
                          time: list[index].time,
                          isDone: list[index].completed != null
                              ? list[index].completed
                              : false,
                          onPressed: () {
                            debugPrint(
                                "Button clicked. Handle button setStatâe");
                            editCheckItem(list[index], !list[index].completed);
                          },
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text("Không có dữ liệu"),
                  ),
          ],
        ),
      ),
    );
  }
}
