import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Vistas/anio.dart';
import 'package:flutter_app/Vistas/login.dart';
import 'package:flutter_app/Vistas/principal.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:ui';
import 'dart:async';

class Fondos extends StatefulWidget {
  @override
  _FondosView createState() => _FondosView();
  final int idCliente;
  final int anio;
  final int clave;
  Fondos({
    this.idCliente,
    this.anio,
    this.clave,
  });
}

class _FondosView extends State<Fondos> {
  String nombreMunicipio;
  String email;
  String logo;
  List<double> montoComprometido;
  List<double> montoProyectado;
  List<String> nombreCorto;
  int idCliente;
  int anio;
  String direccion;
  String rfc;
  String nombreDistrito;
  String anioInicio;
  String anioFin;
  bool entro = false;
  String url;
  int claveMunicipio;
  bool inicio = false;
  List<Widget> send = [];
  List<Widget> fondos = [];

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
    _returnValue(context);
    final Fondos args = ModalRoute.of(context).settings.arguments;
    anio = args.anio;
    idCliente = args.idCliente;
    claveMunicipio = args.clave;
    if (inicio) {
      _options();
    }
    if (send.isEmpty) {
      _getListado(context);
      inicio = true;
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(9, 46, 116, 1.0),
          centerTitle: true,
          title: Text("FUENTES DE FINANCIAMIENTO"),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/Fondo06.png"),
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
        bottomSheet: _menuInferior(context),
      ),
    );
  }

  Widget _menuInferior(BuildContext context) {
    return CurvedNavigationBar(
      key: GlobalKey(),
      index: 2,
      height: 50.0,
      items: <Widget>[
        Icon(
          CupertinoIcons.house,
          size: 30,
          color: Colors.white,
        ),
        Icon(
          CupertinoIcons.calendar,
          size: 30,
          color: Colors.white,
        ),
        Icon(
          CupertinoIcons.money_dollar,
          size: 30,
          color: Colors.white,
        ),
        Icon(
          CupertinoIcons.square_arrow_left,
          size: 30,
          color: Colors.white,
        ),
      ],
      color: Color.fromRGBO(9, 46, 116, 1.0),
      buttonBackgroundColor: Color.fromRGBO(9, 46, 116, 1.0),
      backgroundColor: Colors.transparent,
      animationCurve: Curves.fastOutSlowIn,
      animationDuration: Duration(milliseconds: 600),
      onTap: (i) {},
      letIndexChange: (index) {
        if (index == 3) {
          _showAlertDialog();
          return false;
        }
        if (index == 0) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/inicio', (Route<dynamic> route) => false,
              arguments: Welcome(
                cliente: idCliente,
              ));
          return false;
        }
        if (index == 1) {
          Navigator.pushNamed(
            context,
            '/anio',
            arguments: Anio(
              anio: anio,
              cliente: idCliente,
              clave: claveMunicipio,
            ),
          );
          return false;
        }
        return false;
      },
    );
  }

  void _showAlertDialog() {
    showDialog(
        context: context,
        builder: (buildcontext) {
          return AlertDialog(
            title: Text(
              "¿Está seguro de que desea salir?",
              style: TextStyle(
                color: Color.fromRGBO(9, 46, 116, 1.0),
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ),
            ),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(
                color: Color.fromRGBO(9, 46, 116, 1.0),
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text(
                  "ACEPTAR",
                  style: TextStyle(
                    color: Color.fromRGBO(9, 46, 116, 1.0),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  elevation: 0,
                ),
                /*color: Colors.transparent,
                elevation: 0,
                highlightColor: Colors.transparent,
                highlightElevation: 0,*/
                onPressed: () {
                  Navigator.of(context).pop();
                  _saveValue(null);
                  Navigator.pushAndRemoveUntil(
                    context,
                    PageTransition(
                      alignment: Alignment.bottomCenter,
                      curve: Curves.easeInOut,
                      duration: Duration(milliseconds: 1000),
                      reverseDuration: Duration(milliseconds: 1000),
                      type: PageTransitionType.rightToLeftJoined,
                      child: LoginForm(),
                      childCurrent: new Container(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
              ElevatedButton(
                child: Text(
                  "CANCELAR",
                  style: TextStyle(
                    color: Color.fromRGBO(9, 46, 116, 1.0),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void showHome(BuildContext context) {
    Navigator.pop(context);
  }

  void _options() {
    send.clear();
    send.add(
      SizedBox(
        height: 20,
      ),
    );
    send.add(
      Container(
        child: Column(
          children: fondos,
        ),
      ),
    );
    send.add(
      SizedBox(
        height: 70,
      ),
    );
  }

  Widget cards(
    BuildContext context,
    ramo,
    proyectado,
    comprometido,
    pendiente,
    porcentajeComprometido,
    porcentajePendiente,
  ) {
    int pC = porcentajeComprometido.toInt();
    int pP = porcentajePendiente.toInt();
    return Card(
      // RoundedRectangleBorder para proporcionarle esquinas circulares al Card

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: BorderSide(
          color: Color.fromRGBO(9, 46, 116, 1.0),
        ),
      ),
      // margen para el Card
      margin: EdgeInsets.only(
        left: 30,
        right: 30,
        bottom: 10,
        top: 10,
      ),
      // La sombra que tiene el Card aumentará
      color: Colors.transparent,
      elevation: 0,

      //Colocamos una fila en dentro del card
      child: Padding(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: new Text(
                ramo,
                style: TextStyle(
                  color: Color.fromRGBO(9, 46, 116, 1.0),
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: new Text(
                "Recibido:",
                style: TextStyle(
                  color: Color.fromRGBO(9, 46, 116, 1.0),
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: new Text(
                "\u0024 $proyectado",
                style: TextStyle(
                  color: Color.fromRGBO(9, 46, 116, 1.0),
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CircularPercentIndicator(
                    radius: 80.0,
                    animation: true,
                    animationDuration: 1000,
                    percent: porcentajeComprometido * 0.01,
                    circularStrokeCap: CircularStrokeCap.round,
                    center: Text(
                      "$pC%",
                      style: TextStyle(
                        color: Color.fromRGBO(9, 46, 116, 1.0),
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                      ),
                    ),
                    progressColor: Colors.blue,
                    backgroundColor: Colors.grey[350],
                    lineWidth: 7,
                    footer: new Container(
                      margin: EdgeInsets.only(top: 10, bottom: 20),
                      child: Column(
                        children: [
                          Text(
                            "Comprometido:",
                            style: TextStyle(
                                color: Color.fromRGBO(9, 46, 116, 1.0),
                                fontWeight: FontWeight.w300,
                                fontSize: 16.0),
                          ),
                          Text(
                            "$comprometido",
                            style: TextStyle(
                                color: Color.fromRGBO(9, 46, 116, 1.0),
                                fontWeight: FontWeight.w300,
                                fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: CircularPercentIndicator(
                    radius: 80.0,
                    animation: true,
                    animationDuration: 1000,
                    percent: porcentajePendiente * 0.01,
                    circularStrokeCap: CircularStrokeCap.round,
                    center: Text(
                      "$pP%",
                      style: TextStyle(
                        color: Color.fromRGBO(9, 46, 116, 1.0),
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                      ),
                    ),
                    progressColor: Colors.blue,
                    backgroundColor: Colors.grey[350],
                    lineWidth: 7,
                    footer: new Container(
                      margin: EdgeInsets.only(top: 10, bottom: 20),
                      child: Column(
                        children: [
                          Text(
                            "Pendiente:",
                            style: TextStyle(
                                color: Color.fromRGBO(9, 46, 116, 1.0),
                                fontWeight: FontWeight.w300,
                                fontSize: 16.0),
                          ),
                          Text(
                            "$pendiente",
                            style: TextStyle(
                                color: Color.fromRGBO(9, 46, 116, 1.0),
                                fontWeight: FontWeight.w300,
                                fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> listado(List<dynamic> info) {
    List<Widget> lista = [];
    info.forEach((elemento) {
      int elementoCliente = elemento['id_cliente'];
      lista.add(Text("$elementoCliente"));
    });
    return lista;
  }

  Future<dynamic> _getListado(BuildContext context) async {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.white
      ..backgroundColor = Colors.transparent
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..maskColor = Colors.black.withOpacity(0.88)
      ..userInteractions = false
      ..dismissOnTap = false;

    EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
    EasyLoading.show(
      indicator: Container(
        height: 100,
        width: 120,
        child: SpinKitCubeGrid(
          size: 90,
          duration: Duration(milliseconds: 900),
          itemBuilder: (BuildContext context, int index) {
            int i = index + 1;
            return DecoratedBox(
              decoration: BoxDecoration(
                /*color: index.isEven ? Colors.red : Colors.green,*/
                image: DecorationImage(
                  image: AssetImage("images/icono$i.png"),
                ),
              ),
            );
          },
        ),
      ),
      maskType: EasyLoadingMaskType.custom,
    );
    url =
        "http://sistema.mrcorporativo.com/api/getFuentesCliente/$idCliente,$anio";
    send.clear();
    try {
      final respuesta = await http.get(Uri.parse(url));
      print(respuesta.body);
      if (respuesta.statusCode == 200) {
        if (respuesta.body != "") {
          final data = json.decode(respuesta.body);
          data.forEach((e) {
            /*ramo, proyectado, comprometido, pendiente, porcentaje_comprometido, porcentaje_pendiente,*/
            String ramo = e['nombre_corto'];
            double comprometido =
                double.parse(e['monto_comprometido'].toString());
            double proyectado = double.parse(e['monto_proyectado'].toString());
            double pendiente = proyectado - comprometido;
            double porcentajeComprometido = comprometido * 100 / proyectado;
            double porcentajePendiente = 100 - porcentajeComprometido;
            fondos.add(cards(
              context,
              ramo,
              numberFormat(proyectado),
              numberFormat(comprometido),
              numberFormat(pendiente),
              int.parse(porcentajeComprometido.toStringAsFixed(0)).toDouble(),
              int.parse(porcentajePendiente.toStringAsFixed(0)).toDouble(),
            ));
          });
          send.add(
            SizedBox(
              height: 20,
            ),
          );
          _onRefresh();
          _onLoading();
          return jsonDecode(respuesta.body);
        } else {
          return null;
        }
      } else {
        EasyLoading.dismiss();
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

  String numberFormat(double x) {
    List<String> parts = x.toString().split('.');
    RegExp re = RegExp(r'\B(?=(\d{3})+(?!\d))');

    parts[0] = parts[0].replaceAll(re, ',');
    if (parts.length == 1) {
      parts.add('00');
    } else {
      parts[1] = parts[1].padRight(2, '0').substring(0, 2);
    }
    return parts.join('.');
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
    return token;
  }
}
