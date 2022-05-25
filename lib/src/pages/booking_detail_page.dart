import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  @override
  Widget build(BuildContext context) {
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
                        date: "2022-12-01",
                      ),
                      _inforCard(
                        title: "Thời gian bắt đầu",
                        date: "2022-12-01",
                      ),
                      _inforCard(
                        title: "Thời gian kết thúc",
                        date: "2022-12-01",
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
                        date: "Phạm Huy Hoàng",
                      ),
                      _inforCard(
                        title: "Phí",
                        date: "100.000",
                      ),
                      Text(
                        "Lời nhắn",
                        style: GoogleFonts.nunito(
                          textStyle: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextField(
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
                            5, // when user presses enter it will adapt to it
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              Color(LightColor.primary),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, top: 10, bottom: 10),
                            child: Text('Xác nhận'),
                          ),
                          onPressed: () {
                            print("Đặt lịch hẹn");
                            Navigator.pushNamed(context, "/ListBookingPage");
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
