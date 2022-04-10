import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/user_model.dart';
import '../providers/auth.dart';
import '../providers/user_provider.dart';
import '../widgets/background.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passController = TextEditingController();

  bool _submitted = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    AuthProvider auth = Provider.of<AuthProvider>(context);

    String _errEmail() {
      final text = _usernameController.text;

      if (text.isEmpty) {
        return "Không được để trống";
      }

      if (!text.contains("@")) {
        return "Định dạng email không đúng";
      }

      return null;
    }

    String _errUsername() {
      final text = _usernameController.text;

      if (text.isEmpty) {
        return "Không được để trống";
      }

      if (text.length < 6) {
        return "Định dạng tài khoản không đúng";
      }

      return null;
    }

    String _errPass() {
      final text = _passController.value.text;

      if (text.isEmpty) {
        return "Không được để trống";
      }

      if (text.length < 6) {
        return "Mật khẩu không hợp lệ";
      }

      return null;
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
          Text(" Đang đăng kí ... Vui lòng đợi")
        ],
      ),
    );

    // ignore: unused_element
    void doRegister(String email, String username, String pass) {
      if (_errEmail() == null && _errPass() == null && _errUsername() == null) {
        setState(() {
          _submitted = true;
        });
        auth.register(email, username, pass).then((response) {
          if (response['status']) {
            Flushbar(
              title: "Đăng kí thành công",
              message: response['message'],
              duration: const Duration(seconds: 10),
            ).show(context);
          } else {
            Flushbar(
              title: "Đăng kí thất bại",
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

    var registerBtn = Container(
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: ElevatedButton(
        onPressed: () => {
          doRegister(_emailController.text, _usernameController.text,
              _passController.text)
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
            "ĐĂNG KÍ",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
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
                  "ĐĂNG KÍ",
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
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      labelText: "EMAIL",
                      errorText: !_submitted ? _errEmail() : null),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                      labelText: "TÀI KHOẢN",
                      errorText: !_submitted ? _errUsername() : null),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: _passController,
                  decoration: InputDecoration(
                      labelText: "MẬT KHẨU",
                      errorText: !_submitted ? _errPass() : null),
                  obscureText: true,
                ),
              ),
              SizedBox(height: size.height * 0.05),
              auth.registeredInStatus == Status.Registering
                  ? loading
                  : registerBtn,
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
