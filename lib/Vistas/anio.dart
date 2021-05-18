import 'package:flutter/material.dart';
import 'package:flutter_app/Vistas/fondos.dart';
import 'package:flutter_app/Vistas/obra_publica.dart';
import 'package:flutter_app/Vistas/principal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:flutter_app/Vistas/anio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Anio extends StatefulWidget {
  int anio;
  int id_cliente;
  _AnioView createState() => _AnioView();

  Anio({
    this.anio,
    this.id_cliente,
  });
}

class _AnioView extends State<Anio> {
  int anio;
  int id_cliente;
  String nombre_municipio = "Ejemplo 1";
  String nombre_distrito = "Ejemplo 1";
  String email = "Ejemplo 1";
  String direccion = "Ejemplo q";
  String rfc = "Ejemplo 1";
  int anio_inicio = 2020;
  int anio_fin = 2022;
  bool inicio = false;
  String logo =
      'https://raw.githubusercontent.com/tirado12/CMRInicio/master/logo_rojas.png';
  String prodim = '';
  Color c = const Color(0xFF42A5F5);
  String url;
  final formkey = GlobalKey<FormState>();

  List<Widget> send = [];

  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) setState(() {});
    _refreshController.loadComplete();
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    final Anio args = ModalRoute.of(context).settings.arguments;
    id_cliente = args.id_cliente;
    anio = args.anio;
    _returnValue(context);
    if (inicio) {
      _options();
    }
    if (send.isEmpty) {
      _getListado();
      inicio = true;
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(9, 46, 116, 1.0),
          centerTitle: true,
          title: Text("EJERCICIO $anio"),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/fondo.jpg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SmartRefresher(
            enablePullDown: false,
            enablePullUp: false,
            controller: _refreshController,
            child: ListView.builder(
              itemBuilder: (c, i) => send[i],
              itemCount: send.length,
            ),
          ),
        ),
        bottomNavigationBar: _menuInferior(context),
      ),
    );
  }

  Widget _menuInferior(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 1, // this will be set when a new tab is tapped
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        if (index == 0) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/inicio', (Route<dynamic> route) => false,
              arguments: Welcome(
                id_cliente: id_cliente,
              ));
        }
        if (index == 2) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
          _saveValue(null);
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: new Icon(Icons.home_rounded),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: new Icon(Icons.calendar_today),
          label: 'Ejercicio $anio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: 'Salir',
        ),
      ],
    );
  }

  void showHome(BuildContext context) {
    Navigator.pop(context);
  }

  void _options() {
    send.clear();

    send.add(
      Padding(
        padding: EdgeInsets.all(20.0),
      ),
    );
    send.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: SizedBox(
              height: 80,
              width: 260,
              child: ElevatedButton(
                child: Row(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.monetization_on_rounded,
                          color: Colors.white,
                          size: 30,
                        )),
                    Container(
                        margin: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          "Fondo de \nFinanciamiento",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                          ),
                        )),
                  ],
                ),
                onPressed: () {
                  /*Navigator.pushNamed(context, '/fondos');*/

                  Navigator.pushNamed(context, '/fondos',
                      arguments: Fondos(
                        anio: anio,
                        id_cliente: id_cliente,
                      ));
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromRGBO(9, 46, 116, 1.0),
                  shape: RoundedRectangleBorder(
                    //borde del boton
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.white),
                  ),
                  elevation: 8.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
    send.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: SizedBox(
              height: 80,
              width: 260,
              child: ElevatedButton(
                child: Row(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.construction,
                          color: Colors.white,
                          size: 30,
                        )),
                    Container(
                        margin: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          "Obra Pública",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                          ),
                        )),
                  ],
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/obras',
                      arguments: Obras(
                        anio: anio,
                        id_cliente: id_cliente,
                      ));
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromRGBO(9, 46, 116, 1.0),
                  shape: RoundedRectangleBorder(
                    //borde del boton
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.white),
                  ),
                  elevation: 8.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
    if (prodim != null) {
      send.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: SizedBox(
                height: 80,
                width: 260,
                child: ElevatedButton(
                  child: Row(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 30,
                          )),
                      Container(
                          margin: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            prodim,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                            ),
                          )),
                    ],
                  ),
                  onPressed: () {
                    /*Navigator.pushNamed(context, '/obras',
                      arguments: Obras(
                        anio: anio,
                        id_cliente: id_cliente,
                      ));*/
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(9, 46, 116, 1.0),
                    shape: RoundedRectangleBorder(
                      //borde del boton
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.white),
                    ),
                    elevation: 8.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  void _showSecondPage(BuildContext context) {
    _getListado();
  }

  List<Widget> listado(List<dynamic> info) {
    List<Widget> lista = [];
    info.forEach((elemento) {
      int elemento_cliente = elemento['id_cliente'];
      lista.add(Text("$elemento_cliente"));
    });
    return lista;
  }

  Future<dynamic> _getListado() async {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.white
      ..backgroundColor = const Color.fromRGBO(9, 46, 116, 1.0)
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..maskColor = Colors.black.withOpacity(0.88)
      ..userInteractions = false
      ..dismissOnTap = false;

    EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
    EasyLoading.show(
      status: 'CARGANDO',
      maskType: EasyLoadingMaskType.custom,
    );
    url = "http://192.168.10.160/api/getProdim/$id_cliente,$anio";

    try {
      final respuesta = await http.get(Uri.parse(url));
      if (respuesta.statusCode == 200) {
        if (respuesta.body != "") {
          final data = json.decode(respuesta.body);
          data.forEach((e) {
            if (e['prodim'] == 1) {
              prodim = 'PRODIM';
            }

            if (e['gastos_indirectos'] == 1) {
              print(e['prodim']);
              if (prodim != '') {
                prodim = prodim + '\n';
              }
              prodim = prodim + 'Gastos Indirectos';
            }
          });
          _onRefresh();
          _onLoading();
          return jsonDecode(respuesta.body);
        } else {
          return null;
        }
      } else {
        print("Error con la respusta");
      }
    } catch (e) {
      EasyLoading.instance
        ..displayDuration = const Duration(milliseconds: 2000)
        ..indicatorType = EasyLoadingIndicatorType.fadingCircle
        ..loadingStyle = EasyLoadingStyle.dark
        ..indicatorSize = 45.0
        ..radius = 10.0
        ..progressColor = Colors.white
        ..backgroundColor = Colors.red[900]
        ..indicatorColor = Colors.white
        ..textColor = Colors.white
        ..maskColor = Colors.black.withOpacity(0.88)
        ..userInteractions = false
        ..dismissOnTap = true;
      EasyLoading.dismiss();
      EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
      EasyLoading.showError(
        'ERROR DE CONEXIÓN ',
        maskType: EasyLoadingMaskType.custom,
      );
    }
  }

  _saveValue(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(token);
    await prefs.setString('token', token);
  }

  Future<String> _returnValue(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = await prefs.getString("token");
    print(token);
    /*if (token != null) {
      Navigator.pushReplacementNamed(context, '/inicio',
          arguments: Welcome(
            id_cliente: 1,
          ));
    }*/
    return token;
  }

  void _fondos(
    BuildContext context,
    nombre_municipio,
    email,
    logo,
    monto_comprometido,
    monto_proyectado,
    nombre_corto,
    anio,
    id_cliente,
    direccion,
    rfc,
    nombre_distrito,
    anio_inicio,
    anio_fin,
  ) {
    print("datos correctos");
    if (email == null) {
      email = "Sin dato";
    }

    Navigator.pushReplacementNamed(context, '/fondos',
        arguments: Fondos(
          anio: anio,
          id_cliente: id_cliente,
        ));
  }
}
