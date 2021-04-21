import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Vistas/anio.dart';
import 'package:flutter_app/Vistas/counter.dart';
import 'package:flutter_app/Vistas/obra_admin.dart';
import 'package:flutter_app/Vistas/obra_contrato.dart';
import 'package:flutter_app/Vistas/observer.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'Vistas/login.dart';
import 'Vistas/principal.dart';
import 'Vistas/obra_publica.dart';
import 'Vistas/fondos.dart';
// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  const SystemUiOverlayStyle light = SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xFF000000),
    systemNavigationBarDividerColor: const Color.fromRGBO(9, 46, 116, 1.0),
    statusBarColor: const Color.fromRGBO(9, 46, 116, 1.0),
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  );

  SystemChrome.setSystemUIOverlayStyle(light);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CMR APP',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/counter',
      routes: {
        /*'/': (context) => LoginForm(),
        '/inicio': (context) => Welcome(),
        '/obras': (context) => Obras(),
        '/fondos': (context) => Fondos(),
        '/anio': (context) => Anio(),
        '/admin': (context) => Obras_admin(),
        '/contrato': (context) => Obras_contrato(),*/
        '/counter': (context) => MessagingExampleApp(),
      },
      builder: EasyLoading.init(),
    );
  }
}
