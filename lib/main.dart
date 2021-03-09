import 'package:flutter/material.dart';

import 'Vistas/login.dart';
import 'Vistas/principal.dart';
import 'Vistas/obra_publica.dart';
import 'Vistas/fondos.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prueba',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MainHome(),
        '/inicio': (context) => Welcome(),
        '/obras': (context) => Obras(),
        '/fondos': (context) => Fondos(),
      },
    );
  }
}

