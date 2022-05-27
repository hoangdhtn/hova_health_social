import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_app/src/model/booking_model.dart';
import 'package:health_app/src/model/doctor_model.dart';
import 'package:health_app/src/providers/booking_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../widgets/booking_item.dart';
import '../widgets/doctor_cart.dart';

class ListBookingPage extends StatefulWidget {
  const ListBookingPage({Key key}) : super(key: key);

  @override
  State<ListBookingPage> createState() => _ListBookingPageState();
}

class _ListBookingPageState extends State<ListBookingPage> {
  List<Booking> bookingList = [];

  @override
  void initState() {
    // id = widget.id;
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        getBookingLisst();
      });
    }
    super.initState();
  }

  getBookingLisst() async {
    var fetchedBooking =
        await Provider.of<BookingProvider>(context, listen: false)
            .getListBookingUser();
    setState(() {
      bookingList = fetchedBooking;
    });
    print(bookingList);
  }

  delBooking(int id_booking) async {
    bool result = await Provider.of<BookingProvider>(context, listen: false)
        .deleteBookingUser(id_booking);
    if (result == true) {
      getBookingLisst();
      Flushbar(
        title: "Thông báo",
        message: "Hủy lịch thành công",
        duration: Duration(seconds: 5),
      ).show(context);
    } else {
      getBookingLisst();
      Flushbar(
        title: "Thông báo",
        message: "Hủy lịch thất bại",
        duration: Duration(seconds: 5),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, "/BottomNavigation", (route) => false);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back,
                    color: Colors.black54,
                    size: 36.0,
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Center(
                child: Text(
                  "Danh sách lịch hẹn của bạn",
                  style: GoogleFonts.nunito(textStyle: TextStyle(fontSize: 20)),
                ),
              ),
              ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: bookingList != null ? bookingList.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  return BookingItem(
                    department: bookingList[index].doctor.departments.name,
                    doctorName: bookingList[index].doctor.name,
                    date: bookingList[index].date,
                    time: bookingList[index].begin_at,
                    img: bookingList[index].doctor.ava_url,
                    price: NumberFormat.simpleCurrency(
                            locale: 'vi', decimalDigits: 0)
                        .format(int.parse(
                            bookingList[index].doctor.price.toString()))
                        .toString(),
                    enabled: bookingList[index].enabled,
                    payment: bookingList[index].payment_status,
                    onTapCancel: () {
                      delBooking(bookingList[index].id);
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
