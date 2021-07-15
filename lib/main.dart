import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Vistas/anio.dart';
import 'package:flutter_app/Vistas/bienvenida.dart';
import 'package:flutter_app/Vistas/expediente_contrato.dart';
import 'package:flutter_app/Vistas/obra_admin.dart';
import 'package:flutter_app/Vistas/obra_contrato.dart';
import 'package:flutter_app/Vistas/plataformas.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'dart:ui';

import 'package:flutter_downloader/flutter_downloader.dart';

//Codigo correcto
import 'Vistas/login.dart';
import 'Vistas/principal.dart';
import 'Vistas/obra_publica.dart';
import 'Vistas/fondos.dart';
// Import the firebase_core plugin

const debug = true;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: debug);
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CMR APP',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/home': (context) => Animacion(),
        '/': (context) => LoginForm(),
        '/inicio': (context) => Welcome(),
        '/obras': (context) => Obras(
              key: key,
              anio: 2020,
              idCliente: 1,
              platform: Theme.of(context).platform,
            ),
        '/fondos': (context) => Fondos(),
        '/anio': (context) => Anio(),
        '/admin': (context) => ObrasAdmin(
              key: key,
              anio: 2020,
              idCliente: 1,
              platform: Theme.of(context).platform,
            ),
        '/contrato': (context) => ObrasContrato(
              key: key,
              anio: 2020,
              idCliente: 1,
              platform: Theme.of(context).platform,
            ),
        '/plataformas': (context) => Plataformas(
              key: key,
              anio: 2020,
              cliente: 1,
              platform: Theme.of(context).platform,
            ),
        '/expediente': (context) => ExpedienteContrato(),
      },
      builder: EasyLoading.init(
        builder: (context, child) {
          return MediaQuery(
            child: child,
            data: MediaQuery.of(context).copyWith(textScaleFactor: 0.85),
          );
        },
      ),
    );
  }
}
