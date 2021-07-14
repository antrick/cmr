import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Vistas/anio.dart';
import 'package:flutter_app/Vistas/login.dart';
import 'package:flutter_app/Vistas/sizes_helpers.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'dart:convert';
import 'dart:ui';
import 'dart:async';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeView createState() => _WelcomeView();
  final int cliente;
  Welcome({
    this.cliente,
  });
}

class _WelcomeView extends State<Welcome> {
  int idCliente;
  String nombreMunicipio = "Ejemplo 1";
  String nombreDistrito = "Ejemplo 1";
  String email = "Ejemplo 1";
  String direccion = "Ejemplo q";
  String rfc = "Ejemplo 1";
  int anioInicio = 2020;
  int anioFin = 2022;
  bool inicio = false;
  String logo =
      'https://raw.githubusercontent.com/tirado12/CMRInicio/master/logo_rojas.png';
  Color c = const Color(0xFF42A5F5);
  int currentIndex = 2;
  GlobalKey _bottomNavigationKey = GlobalKey();
  int activeIndex = 0;
  String url;
  final formkey = GlobalKey<FormState>();
  int claveMunicipio;

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
    _returnValue(context);
    final Welcome args = ModalRoute.of(context).settings.arguments;
    idCliente = args.cliente;
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
          title: Text("BIENVENIDO"),
        ),
        body: Container(
          height: displayHeight(context),
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
        bottomNavigationBar: Container(
          height: 25,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(9, 46, 116, 1.0),
          ),
          child: Center(
            child: new RichText(
              text: new TextSpan(
                children: [
                  new TextSpan(
                    text: 'Desarrollado por ',
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  new TextSpan(
                    text: 'INGENINN 360',
                    style: new TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                      decorationThickness: 2,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () {
                        launch('https://www.ingeninn360.com/');
                      },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuInferior(BuildContext context) {
    return CurvedNavigationBar(
      key: _bottomNavigationKey,
      index: 0,
      height: 50.0,
      items: <Widget>[
        Icon(
          CupertinoIcons.house,
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
      onTap: (index) {
        setState(() {
          currentIndex = 0;
          print(currentIndex);
        });
      },
      letIndexChange: (index) {
        if (index == 1) {
          _showAlertDialog();
          return false;
        }
        return true;
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
    send.add(Padding(
      padding: EdgeInsets.all(18.0),
    ));
    send.add(
      Container(
        width: 130.0,
        height: 130.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Color.fromRGBO(9, 46, 116, 1.0),
          ),
          image: new DecorationImage(
            fit: BoxFit.contain,
            image: new NetworkImage(logo),
          ),
        ),
      ),
    );
    send.add(
      SizedBox(
        height: displayHeight(context) * 0.02,
      ),
    );
    send.add(
      Text(
        "H. Ayuntamiento Constitucional de",
        style: TextStyle(
          color: Color.fromRGBO(9, 46, 116, 1.0),
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),
        textAlign: TextAlign.center,
      ),
    );
    send.add(
      Text(
        nombreMunicipio,
        style: TextStyle(
          color: Color.fromRGBO(9, 46, 116, 1.0),
          fontWeight: FontWeight.w500,
          fontSize: 25,
        ),
        textAlign: TextAlign.center,
      ),
    );
    send.add(
      Text(
        "$nombreDistrito, Oaxaca.",
        style: TextStyle(
          color: Color.fromRGBO(9, 46, 116, 1.0),
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),
        textAlign: TextAlign.center,
      ),
    );
    send.add(
      SizedBox(
        height: displayHeight(context) * 0.03,
      ),
    );
    send.add(
      Text(
        "RFC: $rfc",
        style: TextStyle(
          color: Color.fromRGBO(9, 46, 116, 1.0),
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),
        textAlign: TextAlign.center,
      ),
    );

    send.add(
      SizedBox(
        height: displayHeight(context) * 0.02,
      ),
    );
    send.add(
      Container(
        child: Text(
          "$direccion",
          style: TextStyle(
            color: Color.fromRGBO(9, 46, 116, 1.0),
            fontWeight: FontWeight.w400,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
        margin: const EdgeInsets.only(left: 50, right: 50),
      ),
    );
    send.add(
      SizedBox(
        height: displayHeight(context) * 0.02,
      ),
    );

    send.add(
      Text(
        "EJERCICIO",
        style: TextStyle(
          color: Color.fromRGBO(9, 46, 116, 1.0),
          fontWeight: FontWeight.w500,
          fontSize: 20,
        ),
        textAlign: TextAlign.center,
      ),
    );
    send.add(
      SizedBox(
        height: displayHeight(context) * 0.02,
      ),
    );
    DateTime date = DateTime.now();
    int anioActual = date.year;
    if (anioActual + 1 > anioFin) {
      anioActual = anioFin;
    }
    for (var i = anioInicio; i < anioActual + 1; i++) {
      send.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: SizedBox(
                height: displayHeight(context) * 0.06,
                width: 200,
                child: ElevatedButton(
                  child: Text(
                    '$i',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/anio',
                      arguments: Anio(
                        anio: i,
                        cliente: idCliente,
                        clave: claveMunicipio,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue[700],
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
    for (var i = anioActual + 1; i < anioFin + 1; i++) {
      send.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: SizedBox(
                height: displayHeight(context) * 0.06,
                width: 200,
                child: ElevatedButton(
                  child: Text(
                    '$i',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
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

  List<Widget> listado(List<dynamic> info) {
    List<Widget> lista = [];
    info.forEach((elemento) {
      int elementoCliente = elemento['id_cliente'];
      lista.add(Text("$elementoCliente"));
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
    url = "http://sistema.mrcorporativo.com/api/getCliente/$idCliente";
    try {
      final respuesta = await http.get(Uri.parse(url));
      if (respuesta.statusCode == 200) {
        if (respuesta.body != "") {
          print(respuesta.body);
          final data = json.decode(respuesta.body);
          data.forEach((e) {
            idCliente = e['id_cliente'];
            claveMunicipio = e['clave'];
            nombreMunicipio = e['nombre_municipio'];
            nombreDistrito = e['nombre_distrito'];
            email = e['rfc'];
            direccion = e['direccion'];
            rfc = e['rfc'];
            anioInicio = int.parse(e['anio_inicio']);
            anioFin = int.parse(e['anio_fin']);
            logo = e['logo'];
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
    return token;
  }
}
