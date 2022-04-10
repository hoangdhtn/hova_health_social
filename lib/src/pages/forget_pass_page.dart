// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../widgets/background.dart';

class ForgetPassPage extends StatefulWidget {
  const ForgetPassPage({Key key}) : super(key: key);

  @override
  State<ForgetPassPage> createState() => _ForgetPassPageState();
}

class _ForgetPassPageState extends State<ForgetPassPage> {
  final _emailController = TextEditingController();
  final _keyEmailController = TextEditingController();
  final _passController = TextEditingController();
  final _rePassController = TextEditingController();

  Timer _timer;
  int _start = 10;
  bool sentMail = true;
  bool _submitted = true;

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

    AuthProvider auth = Provider.of<AuthProvider>(context);

    String _errEmail() {
      final text = _emailController.text;

      if (text.isEmpty) {
        return "Không được để trống";
      }

      if (!text.contains("@")) {
        return "Định dạng email không đúng";
      }

      return null;
    }

    String _errKeyEmail() {
      final text = _keyEmailController.text;

      if (text.isEmpty) {
        return "Không được để trống";
      }

      return null;
    }

    String _errPass() {
      final text = _passController.text;

      if (text.isEmpty) {
        return "Không được để trống";
      }

      if (text.length < 6) {
        return "Định dạng tài khoản không đúng";
      }

      return null;
    }

    String _errRePass() {
      final text = _rePassController.value.text;
      final passOld = _passController.value.text;

      if (text.isEmpty) {
        return "Không được để trống";
      }

      if (text.length < 6) {
        return "Mật khẩu không hợp lệ";
      }

      if (text != passOld) {
        return "Lập lại mật khẩu không đúng";
      }

      return null;
    }

    void _ontapSentMail(String email) {
      setState(() => sentMail = false);
      startTimer();

      if (_errEmail() == null) {
        setState(() => _submitted = true);
        Future<Map<String, dynamic>> successSentMail = auth.sentMail(email);
        successSentMail.then((response) {
          if (response['status']) {
            Flushbar(
              title: "Gửi mail thành công",
              message: response['message'],
              duration: const Duration(seconds: 10),
            ).show(context);
          } else {
            Flushbar(
              title: "Gửi mail thất bại",
              message: response['message'],
              duration: const Duration(seconds: 10),
            ).show(context);
          }
        });
      } else {
        setState(() {
          _start = 0;
          _submitted = false;
        });
      }
    }

    void resetPass(String email, String keymail, String pass) {
      if (_errEmail() == null &&
          _errKeyEmail() == null &&
          _errPass() == null &&
          _errRePass() == null) {
        setState(() => _submitted = true);
        Future<Map<String, dynamic>> resetPass =
            auth.ressetPass(email, keymail, pass);

        resetPass.then((response) {
          if (response['status']) {
            Flushbar(
              title: "Đổi mật khẩu thành công",
              message: response['message'],
              duration: const Duration(seconds: 10),
            ).show(context);
          } else {
            Flushbar(
              title: "Đổi mật khẩu thất bại",
              message: response['message'],
              duration: const Duration(seconds: 10),
            ).show(context);
          }
        });
      } else {
        setState(() {
          _submitted = false;
        });
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
          Text(" Đang xử lý... Vui lòng đợi")
        ],
      ),
    );

    var resetPassBtn = Container(
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: ElevatedButton(
        onPressed: () {
          resetPass(_emailController.text, _keyEmailController.text,
              _passController.text);
        },
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
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
    var changePass = Column(
      children: [
        SizedBox(height: size.height * 0.03),
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 40),
          child: TextField(
            controller: _keyEmailController,
            decoration: InputDecoration(
                labelText: "MÃ BẢO VỆ",
                errorText: !_submitted ? _errKeyEmail() : null),
          ),
        ),
        SizedBox(height: size.height * 0.03),
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 40),
          child: TextField(
            controller: _passController,
            decoration: InputDecoration(
                labelText: "MẬT KHẨU MỚI",
                errorText: !_submitted ? _errPass() : null),
            obscureText: true,
          ),
        ),
        SizedBox(height: size.height * 0.03),
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 40),
          child: TextField(
            controller: _rePassController,
            decoration: InputDecoration(
                labelText: "NHẬP LẠI MẬT KHẨU",
                errorText: !_submitted ? _errRePass() : null),
            obscureText: true,
          ),
        ),
        SizedBox(height: size.height * 0.05),
        auth.resetpassInStatus == Status.ResetPasswording
            ? loading
            : resetPassBtn,
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
                      controller: _emailController,
                      decoration: InputDecoration(
                          labelText: "EMAIL",
                          errorText: !_submitted ? _errEmail() : null),
                    ),
                    GestureDetector(
                      onTap: (() {
                        if (sentMail == true) {
                          print("EMAIL" + _emailController.text);
                          _ontapSentMail(_emailController.text);
                        } else {
                          return null;
                        }
                      }),
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
              auth.sentmailInStatus == Status.SentMailing
                  ? loading
                  : SizedBox(),
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
