import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/user_model.dart';
import '../providers/auth.dart';
import '../providers/user_provider.dart';
import '../widgets/background.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passController = TextEditingController();

  bool _submitted = true;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

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
          Text(" Đang đăng nhập ... Vui lòng đợi")
        ],
      ),
    );

    void doLogin(String username, String pass) {
      if (_errPass() == null && _errUsername() == null) {
        setState(() => _submitted = true);
        final Future<Map<String, dynamic>> successfulMessage =
            auth.login(username, pass);

        successfulMessage.then((response) {
          if (response['status']) {
            User user = response['user'];
            Provider.of<UserProvider>(context, listen: false).setUser(user);
            Navigator.pushNamed(context, "/BottomNavigation");
          } else {
            Flushbar(
              title: "Đăng nhập thất bại",
              message: response['message'].toString(),
              duration: Duration(seconds: 3),
            ).show(context);
          }
        });
      } else {
        setState(() => _submitted = false);
      }
    }

    Size size = MediaQuery.of(context).size;

    var loginBtn = Container(
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: ElevatedButton(
        onPressed: () {
          //Navigator.pushNamed(context, "/BottomNavigation");
          doLogin(_usernameController.text, _passController.text);
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
            "ĐĂNG NHẬP",
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
                  "ĐĂNG NHẬP",
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
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: "TÀI KHOẢN",
                    errorText: !_submitted ? _errUsername() : null,
                  ),
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
                    errorText: !_submitted ? _errPass() : null,
                  ),
                  obscureText: true,
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                margin:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/ForgetPassPage");
                  },
                  child: const Text(
                    "QUÊN MẬT KHẨU?",
                    style: TextStyle(fontSize: 12, color: Color(0XFF2661FA)),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.05),
              auth.loggedInStatus == Status.Authenticating ? loading : loginBtn,
              Container(
                alignment: Alignment.centerRight,
                margin:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: GestureDetector(
                  onTap: () => {Navigator.pushNamed(context, "/RegisterPage")},
                  child: const Text(
                    "Nếu bạn chưa có tài khoản? Hãy đăng kí nào",
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
