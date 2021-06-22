import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Vistas/anio.dart';
import 'package:flutter_app/Vistas/download.dart';
import 'package:flutter_app/Vistas/notify.dart';
import 'package:flutter_app/Vistas/obra_admin.dart';
import 'package:flutter_app/Vistas/obra_contrato.dart';
import 'package:flutter_app/Vistas/plataformas.dart';
import 'package:flutter_app/Vistas/prodim.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'dart:isolate';
import 'dart:ui';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';

//======================= INICIO CODIGO PRUEBA ============================
/*const debug = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: debug);

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;

    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(
        title: 'Downloader',
        platform: platform,
      ),
    );
  }
}*/

//======================= FIN CODIGO PRUEBA ============================
//Codigo correcto
import 'Vistas/login.dart';
import 'Vistas/principal.dart';
import 'Vistas/obra_publica.dart';
import 'Vistas/fondos.dart';
// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';

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
    final platform = Theme.of(context).platform;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CMR APP',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginForm(),
        '/inicio': (context) => Welcome(),
        '/obras': (context) => Obras(
              key: key,
              anio: 2020,
              id_cliente: 1,
              platform: Theme.of(context).platform,
            ),
        '/fondos': (context) => Fondos(),
        '/anio': (context) => Anio(),
        '/admin': (context) => Obras_admin(
              key: key,
              anio: 2020,
              id_cliente: 1,
              platform: Theme.of(context).platform,
            ),
        '/contrato': (context) => Obras_contrato(
              key: key,
              anio: 2020,
              id_cliente: 1,
              platform: Theme.of(context).platform,
            ),
        '/counter': (context) => Notify(),
        '/prodim': (context) => Prodim(),
        '/plataformas': (context) => Plataformas(),
        '/MyHome': (context) =>
            MyHomePage(key, "hola", Theme.of(context).platform),
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
