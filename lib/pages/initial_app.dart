import 'package:fastmu_rajal/config/colors.dart';
import 'package:fastmu_rajal/config/constant.dart';
import 'package:fastmu_rajal/pages/list_periksa.dart';
import 'package:fastmu_rajal/pages/login_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class InitApp extends StatefulWidget {
  const InitApp({super.key});

  @override
  State<InitApp> createState() => _InitAppState();
}

class _InitAppState extends State<InitApp> {
  late SharedPreferences prefs;
  final dio = Dio();

  @override
  void initState() {
    super.initState();
    _loginCheck();
  }

  @override

  Future<void> _loginCheck() async {
    prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    Response tokenCheck;
    if (token != null) {
      try {
        tokenCheck = await dio.get(
          '$API_URL/login',
          options: Options(
            headers: { 'Authorization': token }
          )
        );
        
        if (!tokenCheck.data['token_expired']) {
          Navigator.pushNamedAndRemoveUntil(
            context, 
            ListPeriksa.nameRoute,
            ModalRoute.withName(ListPeriksa.nameRoute), 
          );
        } 
        else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            LoginApp.nameRoute, 
            ModalRoute.withName(LoginApp.nameRoute), 
          );
        } 

      } on DioError catch(e) {

        if (e.response?.data.containsKey('token_expired') && e.response!.data['token_expired']) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            LoginApp.nameRoute, 
            ModalRoute.withName(LoginApp.nameRoute)
          );
        }
      }

    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        LoginApp.nameRoute, 
        ModalRoute.withName(LoginApp.nameRoute), 
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 1.0,
        width: MediaQuery.of(context).size.width * 1.0,
        child: Center(
          child: CircularProgressIndicator(
            color: MyColor.primary,
            value: 0.3,
          ),
        ),
      ),
    );
  }
}