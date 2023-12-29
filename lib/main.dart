import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fastmu_rajal/pages/initial_app.dart';
import 'package:fastmu_rajal/pages/login_view.dart';
import 'package:fastmu_rajal/pages/list_periksa.dart';
import 'package:fastmu_rajal/pages/list_berkas.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      // Status Bar
      statusBarColor: Color(0xff263C92),
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    )
  );

  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/' : (context) => const InitApp(),
        LoginApp.nameRoute : (context) => const LoginApp(),
        ListPeriksa.nameRoute : (context) => ListPeriksa(),
        ListBerkas.nameRoute : (context) => ListBerkas(),
      },
    );
  }
}

// Fastmu Rawat inap