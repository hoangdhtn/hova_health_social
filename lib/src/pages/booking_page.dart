import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/light_color.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({Key key}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime _selectedDate;
  int checkedIndex = 0;

  @override
  void initState() {
    super.initState();
    _resetSelectedDate();
  }

  void _resetSelectedDate() {
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Lựa chọn thời gian',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CalendarTimeline(
                          showYears: true,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)),
                          onDateSelected: (date) {
                            setState(() {
                              _selectedDate = date;
                            });
                            print(date);
                          },
                          leftMargin: 20,
                          monthColor: Colors.black,
                          dayColor: Colors.black,
                          dayNameColor: Colors.white,
                          activeDayColor: Colors.white,
                          activeBackgroundDayColor: Colors.blueAccent,
                          dotsColor: Color(0xFFFFFFFF),
                          selectableDayPredicate: (date) => date.day != 23,
                          locale: 'en',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: TextButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blueAccent)),
                      child: Text('Làm mới',
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255))),
                      onPressed: () => setState(() => _resetSelectedDate()),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2.4,
                    child: GridView.count(
                      // Create a grid with 2 columns. If you change the scrollDirection to
                      // horizontal, this produces 2 rows.
                      crossAxisCount: 3,
                      // Generate 100 widgets that display their index in the List.
                      children: List.generate(100, (index) {
                        bool checked = index == checkedIndex;
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                checkedIndex = index;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: checked
                                    ? Colors.orangeAccent
                                    : Colors.greenAccent,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('$index:00',
                                      style: GoogleFonts.nunito(
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Color(LightColor.primary),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 60, right: 60, top: 10, bottom: 10),
                            child: Text('Tiếp theo'),
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
