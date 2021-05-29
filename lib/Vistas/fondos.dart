import 'package:flutter/material.dart';
import 'package:flutter_app/Vistas/anio.dart';
import 'package:flutter_app/Vistas/principal.dart';
import 'package:flutter_app/Vistas/obra_publica.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Fondos extends StatefulWidget {
  @override
  _FondosView createState() => _FondosView();
  int id_cliente;
  int anio;
  Fondos({
    this.id_cliente,
    this.anio,
  });
}

class _FondosView extends State<Fondos> {
  String nombre_municipio;
  String email;
  String logo;
  List<double> monto_comprometido;
  List<double> monto_proyectado;
  List<String> nombre_corto;
  int id_cliente;
  int anio;
  String direccion;
  String rfc;
  String nombre_distrito;
  String anio_inicio;
  String anio_fin;
  List<Widget> send = [];
  bool entro = false;
  String url;

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
    print(logo);
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    final Fondos args = ModalRoute.of(context).settings.arguments;
    anio = args.anio;
    id_cliente = args.id_cliente;
    if (send.isEmpty && !entro) {
      _getListado(context);
      entro = true;
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(9, 46, 116, 1.0),
          centerTitle: true,
          title: Text("FONDOS DE FINANCIAMIENTO"),
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

  void showHome(BuildContext context) {
    Navigator.pop(context);
  }

  Widget _contenedor(BuildContext context) {
    return Container(
      child: Scrollbar(
        child: ListView(children: listado(context)),
      ),
    );
  }

  Widget _menuInferior(BuildContext context) {
    final Fondos args = ModalRoute.of(context).settings.arguments;
    return BottomNavigationBar(
      currentIndex: 2, // this will be set when a new tab is tapped

      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        if (index == 0) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/inicio', (Route<dynamic> route) => false,
              arguments: Welcome(
                id_cliente: id_cliente,
              ));
        }

        if (index == 1) {
          Navigator.pushNamed(context, '/anio',
              arguments: Anio(
                anio: anio,
                id_cliente: id_cliente,
              ));
        }
        if (index == 3) {
          Navigator.pushNamed(context, '/obras',
              arguments: Obras(
                anio: anio,
                id_cliente: id_cliente,
              ));
        }
        if (index == 4) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/',
            (Route<dynamic> route) => false,
          );
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
          label: 'Año $anio',
        ),
        BottomNavigationBarItem(
          icon: new Icon(Icons.attach_money),
          label: 'Fondos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.construction),
          label: 'Obra Publica',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: 'Salir',
        ),
      ],
    );
  }

  Widget cards(
    BuildContext context,
    ramo,
    proyectado,
    comprometido,
    pendiente,
    porcentaje_comprometido,
    porcentaje_pendiente,
  ) {
    /*porcentaje_pendiente =
        int.parse(porcentaje_pendiente.toStringAsFixed(0)).toDouble();
    porcentaje_comprometido =
        int.parse(porcentaje_comprometido.toStringAsFixed(0)).toDouble();
    print('cards');*/
    return Container(
      height: 300,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white),
        ), //bordes redondeados
        margin: EdgeInsets.all(20),
        color: const Color.fromRGBO(9, 46, 116, 1.0),
        elevation: 12,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ramo.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Row(children: [
                        Text("Recibido:",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 20.0)),
                      ]),
                      Row(children: [
                        Text("\u0024  $proyectado",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 20.0)),
                      ]),
                    ],
                  )
                ],
              ), //titulo y barra contratado

              Padding(
                padding: const EdgeInsets.all(9.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Text("Contratado:\n\u0024  $comprometido",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 16.0)),
                      ],
                    )
                  ],
                ),
              ),
              Row(
                //FILA DE BARRA
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LinearPercentIndicator(
                    width: 300.0,
                    animation: true,
                    animationDuration: 1000,
                    lineHeight: 20.0,
                    percent: porcentaje_comprometido * 0.01,
                    center: Text("$porcentaje_comprometido%"),
                    progressColor: const Color.fromRGBO(0, 153, 51, 1.0),
                  ),
                ],
              ), //titulo y barra pendiente
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Text("Pendiente:\n\u0024 $pendiente",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 16.0)),
                      ],
                    )
                  ],
                ),
              ),
              Row(
                //FILA DE BARRA
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LinearPercentIndicator(
                    width: 300.0,
                    animation: true,
                    animationDuration: 1000,
                    lineHeight: 20.0,
                    percent: porcentaje_pendiente * 0.01,
                    center: Text("$porcentaje_pendiente%"),
                    progressColor: const Color.fromRGBO(0, 204, 255, 1.0),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> listado(BuildContext context) {
    List<Widget> lista = [];
    lista.add(
      Container(
        margin: const EdgeInsets.only(
          top: 30,
        ),
      ),
    );
    double pendiente;
    double p_c;
    double p_p;
    for (var i = 0; i < nombre_corto.length; i++) {
      pendiente = monto_proyectado[i] - monto_comprometido[i];
      p_c = monto_comprometido[i] * 100 / monto_proyectado[i];
      p_p = 100 - p_c;
      lista.add(cards(
        context,
        nombre_corto[i],
        numberFormat(monto_proyectado[i]),
        numberFormat(monto_comprometido[i]),
        numberFormat(pendiente),
        p_c,
        p_p,
      ));
    }
    return lista;
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

  Future<dynamic> _getListado(BuildContext context) async {
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
    url = "http://192.168.10.141/api/getFuentesCliente/$id_cliente,$anio";
    send.clear();
    try {
      final respuesta = await http.get(Uri.parse(url));
      if (respuesta.statusCode == 200) {
        bool resp = respuesta.body == "";
        if (respuesta.body != "") {
          final data = json.decode(respuesta.body);
          data.forEach((e) {
            /*ramo, proyectado, comprometido, pendiente, porcentaje_comprometido, porcentaje_pendiente,*/
            String ramo = e['nombre_corto'];
            double comprometido =
                double.parse(e['monto_comprometido'].toString());
            double proyectado = double.parse(e['monto_proyectado'].toString());
            double pendiente = proyectado - comprometido;
            double porcentaje_comprometido = comprometido * 100 / proyectado;
            double porcentaje_pendiente = 100 - porcentaje_comprometido;
            send.add(cards(
              context,
              ramo,
              numberFormat(proyectado),
              numberFormat(comprometido),
              numberFormat(pendiente),
              int.parse(porcentaje_comprometido.toStringAsFixed(0)).toDouble(),
              int.parse(porcentaje_pendiente.toStringAsFixed(0)).toDouble(),
            ));
          });
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

  _saveValue(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(token);
    await prefs.setString('token', token);
  }
}
