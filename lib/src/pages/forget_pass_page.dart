// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/background.dart';

class ForgetPassPage extends StatefulWidget {
  const ForgetPassPage({Key key}) : super(key: key);

  @override
  State<ForgetPassPage> createState() => _ForgetPassPageState();
}

class _ForgetPassPageState extends State<ForgetPassPage> {
  Timer _timer;
  int _start = 10;
  bool sentMail = true;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    // ignore: unnecessary_new
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            sentMail = true;
            _start = 10;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void _ontap() {
    setState(() => sentMail = false);
    startTimer();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    var changePass = Column(
      children: [
        SizedBox(height: size.height * 0.03),
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 40),
          child: const TextField(
            decoration: InputDecoration(labelText: "MÃ BẢO VỆ"),
          ),
        ),
        SizedBox(height: size.height * 0.03),
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 40),
          child: const TextField(
            decoration: InputDecoration(labelText: "MẬT KHẨU MỚI"),
          ),
        ),
        SizedBox(height: size.height * 0.03),
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 40),
          child: const TextField(
            decoration: InputDecoration(labelText: "NHẬP LẠI MẬT KHẨU"),
            obscureText: true,
          ),
        ),
        SizedBox(height: size.height * 0.05),
        Container(
          alignment: Alignment.centerRight,
          margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: ElevatedButton(
            onPressed: () => {},
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80.0),
              ),
              padding: const EdgeInsets.all(0),
            ),
            child: Container(
              alignment: Alignment.center,
              height: 50.0,
              width: size.width * 0.5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80.0),
                  gradient: const LinearGradient(colors: [
                    Color.fromARGB(255, 255, 136, 34),
                    Color.fromARGB(255, 255, 177, 41)
                  ])),
              padding: const EdgeInsets.all(0),
              child: const Text(
                "THAY ĐỔI MẬT KHẨU",
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
    return Scaffold(
      body: SingleChildScrollView(
        child: Background(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: const Text(
                  "QUÊN MẬT KHẨU",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2661FA),
                      fontSize: 36),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: Stack(
                  alignment: AlignmentDirectional.centerEnd,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: "EMAIL"),
                    ),
                    GestureDetector(
                      onTap: sentMail ? _ontap : null,
                      child: Text(
                        "GỬI MÃ ($_start s)",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: sentMail == false
                                ? Colors.grey
                                : Color.fromARGB(255, 0, 57, 155)),
                      ),
                    ),
                  ],
                ),
              ),
              changePass,
              Container(
                alignment: Alignment.centerRight,
                margin:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: GestureDetector(
                  onTap: () => {Navigator.pop(context)},
                  child: const Text(
                    "Nếu bạn đã có tài khoản? Hãy đăng nhập nào",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2661FA)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
