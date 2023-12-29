import 'package:fastmu_rajal/pages/list_periksa.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fastmu_rajal/config/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginApp extends StatefulWidget {
  const LoginApp({super.key});
  static const nameRoute = '/login';

  @override
  State<LoginApp> createState() => _LoginAppState();
}

class _LoginAppState extends State<LoginApp> {
  late SharedPreferences prefs;
  String? _errorMessage;
  late FocusNode usernameFocus;
  late FocusNode passwordFocus;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final dio = Dio();

  @override
  void initState() {
    usernameFocus = FocusNode();
    passwordFocus = FocusNode();
    super.initState();
  }

  void handleLogin() async {
    late Response response;
    if (_formKey.currentState!.validate()) {
      try {
        response = await dio.post('$API_URL/login',
            options: Options(responseType: ResponseType.json),
            data: {
              'username': usernameController.text,
              'password': passwordController.text
            });

        if (!response.data['success']) {
          setState(() {
            _errorMessage = response.data['message'];
          });
          return;
        } else if (response.data['nama_group'] != "Perawat Rajal") {
          setState(() {
            _errorMessage = "Akses ditolak !";
          });
          return;
        }

        prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data['token']);
        await prefs.setString('nama_user', response.data['nama']);
        Navigator.popAndPushNamed(context, ListPeriksa.nameRoute);
      } on DioError catch (e) {
        print(e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
          child: Container(
        constraints:
            BoxConstraints(maxWidth: screen.width, maxHeight: screen.height),
        color: const Color(0xff263C92),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Color(0xff263C92),
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(50))),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(15.0),
                            child: Image.asset(
                              'assets/img/fastmu-logo.png',
                              height: screen.width * 0.25,
                              width: screen.width * 0.25,
                            ),
                          ),
                          Text(
                            'Fulan'.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screen.height / 33,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 5,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              'Fastmu Rawat Jalan',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screen.height / 55,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ]),
                  )),
            ),
            Expanded(
                flex: 4,
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screen.height / 40,
                        vertical: screen.height / 30,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Selamat Datang',
                            style: TextStyle(
                                color: Colors.blueGrey[900],
                                fontSize: screen.height / 38,
                                fontWeight: FontWeight.w700),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: Text(
                              'Silahkan masuk untuk melanjutkan !',
                              style: TextStyle(
                                color: Colors.blueGrey[400],
                                fontSize: screen.height / 58,
                              ),
                            ),
                          ),
                          Container(
                            child: Form(
                              key: _formKey,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 35,
                                    width: MediaQuery.of(context).size.width,
                                    child: Center(
                                      child: Text(_errorMessage ?? "-",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.red)),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      'Username',
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Username tidak boleh kosong';
                                      }
                                      return null;
                                    },
                                    controller: usernameController,
                                    focusNode: usernameFocus,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    autocorrect: false,
                                    style: TextStyle(
                                      color: Colors.lightBlue[900],
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(10),
                                        filled: true,
                                        fillColor: Colors.grey[100],
                                        enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Colors.transparent),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0))),
                                        focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Colors.transparent),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0))),
                                        errorBorder: InputBorder.none,
                                        focusedErrorBorder: InputBorder.none,
                                        hintText: 'Masukkan username',
                                        hintStyle: TextStyle(
                                            fontSize: 15,
                                            color: Colors.blueGrey[300],
                                            fontWeight: FontWeight.normal)),
                                  ),
                                  const SizedBox(height: 25),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      'Password',
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Password tidak boleh kosong';
                                      }
                                      return null;
                                    },
                                    controller: passwordController,
                                    focusNode: passwordFocus,
                                    style: TextStyle(
                                      color: Colors.lightBlue[900],
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    onEditingComplete: () => handleLogin(),
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.go,
                                    autocorrect: false,
                                    obscureText: true,
                                    cursorColor: Colors.blueAccent,
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(10),
                                        filled: true,
                                        fillColor: Colors.grey[100],
                                        enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Colors.transparent),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0))),
                                        focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: Colors.transparent),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0))),
                                        errorBorder: InputBorder.none,
                                        focusedErrorBorder: InputBorder.none,
                                        hintText: 'Masukkan Password',
                                        hintStyle: TextStyle(
                                            fontSize: 15,
                                            color: Colors.blueGrey[300],
                                            fontWeight: FontWeight.normal)),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 12.0, bottom: 22.0),
                                    child: Text(
                                      'Lupa password ?',
                                      style: TextStyle(
                                          color: Colors.indigo[700],
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  TextButton(
                                      onPressed: () => handleLogin(),
                                      style: ButtonStyle(
                                          padding:
                                              const MaterialStatePropertyAll(
                                                  EdgeInsets.all(15)),
                                          backgroundColor:
                                              const MaterialStatePropertyAll(
                                                  Color(0xff263C92)),
                                          shape: MaterialStatePropertyAll(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25.0)))),
                                      child: Center(
                                        child: Text(
                                          'masuk'.toUpperCase(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ))),
          ],
        ),
      )),
    ));
  }
}
