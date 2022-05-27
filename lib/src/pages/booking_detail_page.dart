import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_app/src/model/doctor_model.dart';
import 'package:health_app/src/providers/booking_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../theme/light_color.dart';
import '../widgets/navigation.dart';

class BookingDetailPage extends StatefulWidget {
  const BookingDetailPage({Key key}) : super(key: key);

  @override
  State<BookingDetailPage> createState() => _BookingDetailPageState();
}

class _BookingDetailPageState extends State<BookingDetailPage> {
  // Show Dialog
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Đang trong quá trình xử lý, \nvui lòng đợi!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Sau khi xử lí thành công'),
                Text('Thông tin chi tiết sẽ được gửi về email của bạn'),
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showResult() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Đặt lịch hẹn thành công'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Thông tin chi tiết sẽ gửi về Email của bạn'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Xem danh sách lịch hẹn'),
              onPressed: () {
                Navigator.pushNamed(context, "/ListBookingPage");
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showResultFail() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Đặt lịch hẹn thất bại'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Vui lòng tiến hành lại'),
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
          ],
        );
      },
    );
  }

  final _infoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context).settings.arguments as Map;
    // How to user arg
    // randomVar1 = arg['v1'];
    // arguments: {
    //   "datebooking": datebooking,
    //   "begin_at": begin_at,
    //   "end_at": end_at,
    //   "index_date": index_time,
    //   "doctor": doctorParam
    // });
    Doctor doctor = arg['doctor'];

    BookingProvider bookingProvider =
        Provider.of<BookingProvider>(context, listen: true);

    addBooking(String date, String begin_at, String end_at, String index_day,
        String order_info, String doctor_id) async {
      bool result = await bookingProvider.bookingSlot(
          date, begin_at, end_at, index_day, order_info, doctor_id);

      if (result == true) {
        _showResult();
      } else {
        _showResultFail();
      }
    }

    var loading = Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          CircularProgressIndicator(),
          SizedBox(
            width: 20,
          ),
          Text(" Đang Xử lý ... Vui lòng đợi")
        ],
      ),
    );
// bookingProvider.bookingInStatus == Status.Booking
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Color.fromARGB(255, 237, 237, 237),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView(children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        height: 20,
                      ),
                      Text(
                        "Thời gian",
                        style: GoogleFonts.nunito(
                          textStyle: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                      _inforCard(
                        title: "Ngày gặp",
                        date: arg['datebooking'],
                      ),
                      _inforCard(
                        title: "Thời gian bắt đầu",
                        date: arg['begin_at'],
                      ),
                      _inforCard(
                        title: "Thời gian kết thúc",
                        date: arg['end_at'],
                      ),
                      Text(
                        "Thông tin bác sỹ",
                        style: GoogleFonts.nunito(
                          textStyle: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                      _inforCard(
                        title: "Họ tên",
                        date: doctor.name,
                      ),
                      _inforCard(
                        title: "Phí",
                        date: NumberFormat.simpleCurrency(
                                locale: 'vi', decimalDigits: 0)
                            .format(int.parse(doctor.price.toString()))
                            .toString(),
                      ),
                      _inforCard(
                        title: "SĐT",
                        date: doctor.phone,
                      ),
                      _inforCard(
                        title: "Email",
                        date: doctor.email,
                      ),
                      Text(
                        "Thông tin triệu chứng",
                        style: GoogleFonts.nunito(
                          textStyle: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextField(
                        controller: _infoController,
                        decoration: new InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2.0),
                          ),
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines:
                            2, // when user presses enter it will adapt to it
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        alignment: Alignment.center,
                        child: bookingProvider.bookingInStatus == Status.Booking
                            ? loading
                            : ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    Color(LightColor.primary),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 30, right: 30, top: 10, bottom: 10),
                                  child: Text('Xác nhận'),
                                ),
                                onPressed: () {
                                  addBooking(
                                      arg['datebooking'],
                                      arg['begin_at'],
                                      arg['end_at'],
                                      arg['index_date'],
                                      _infoController.text,
                                      doctor.id.toString());
                                  // _showMyDialog();
                                },
                              ),
                      )
                    ],
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _inforCard extends StatelessWidget {
  String date;
  String title;
  _inforCard({
    Key key,
    this.date,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            title + ": ",
            style: GoogleFonts.nunito(
              textStyle: TextStyle(fontSize: 20),
            ),
          ),
          Text(
            date,
            style: GoogleFonts.nunito(
              textStyle: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
