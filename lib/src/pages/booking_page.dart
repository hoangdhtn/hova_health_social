import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_app/src/model/slots_vailable.dart';
import 'package:health_app/src/providers/booking_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/doctor_model.dart';
import '../theme/light_color.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({Key key}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime _selectedDate;
  String datebooking;
  String begin_at;
  String end_at;
  String index_time;
  int checkedIndex = 0;
  List<SlotsAvailable> slotsList;

  @override
  void initState() {
    super.initState();
    _resetSelectedDate();
  }

  void _resetSelectedDate() {
    _selectedDate = DateTime.now();
  }

  getDoctorsByDepart(int id_doctor, String date) async {
    var fetchedSlots =
        await Provider.of<BookingProvider>(context, listen: false)
            .getListBookingAvai(id_doctor, date);
    setState(() {
      slotsList = fetchedSlots;
    });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text('Vui lòng chọn đầy đủ thông tin'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Các thông tin bao gồm: ngày và thời gian gặp mặt'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Đã hiểu'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Data param
    Doctor doctorParam = ModalRoute.of(context).settings.arguments;
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
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context, true);
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.black54,
                            size: 36.0,
                          ),
                        ),
                        SizedBox(
                          width: 80,
                        ),
                        Text(
                          'Lựa chọn thời gian',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: Colors.black),
                        ),
                      ],
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
                            final DateFormat formatter =
                                DateFormat('yyyy-MM-dd');
                            final String formattedDay = formatter.format(date);
                            getDoctorsByDepart(doctorParam.id, formattedDay);
                            setState(() {
                              datebooking = formattedDay;
                            });
                            // print(date);
                            // print(formattedDay);
                            print("Datebooking" + datebooking);
                          },
                          leftMargin: 20,
                          monthColor: Colors.black,
                          dayColor: Colors.black,
                          dayNameColor: Colors.white,
                          activeDayColor: Colors.white,
                          activeBackgroundDayColor: Colors.blueAccent,
                          dotsColor: Color(0xFFFFFFFF),
                          selectableDayPredicate: (date) => date.day != 23,
                          locale: 'vi',
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
                      onPressed: () => setState(
                        () => _resetSelectedDate(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2.5,
                    child: GridView.builder(
                        itemCount: slotsList != null ? slotsList.length : 0,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                        itemBuilder: (_, index) {
                          bool checked = index == checkedIndex;
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  checkedIndex = index;
                                  begin_at = slotsList[index].begin_at;
                                  end_at = slotsList[index].end_at;
                                  index_time =
                                      slotsList[index].index.toString();
                                });
                                print(begin_at + " -> " + end_at);
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          slotsList[index]
                                              .begin_at
                                              .substring(0, 5),
                                          style: GoogleFonts.nunito(
                                            textStyle: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          ' - ',
                                          style: GoogleFonts.nunito(
                                            textStyle: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          slotsList[index]
                                              .end_at
                                              .substring(0, 5),
                                          style: GoogleFonts.nunito(
                                            textStyle: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
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
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                            child: Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Tiếp theo',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              if (datebooking == null || begin_at == null) {
                                _showMyDialog();
                              } else {
                                Navigator.pushNamed(
                                    context, "/BookingDetailPage",
                                    arguments: {
                                      "datebooking": datebooking,
                                      "begin_at": begin_at,
                                      "end_at": end_at,
                                      "index_date": index_time,
                                      "doctor": doctorParam
                                    });
                              }
                            },
                          ),
                        ],
                      ),
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
