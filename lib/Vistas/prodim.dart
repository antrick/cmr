import 'package:flutter/material.dart';
import 'package:flutter_app/Vistas/anio.dart';
import 'package:flutter_app/Vistas/obra_admin.dart';
import 'package:flutter_app/Vistas/obra_contrato.dart';
import 'package:flutter_app/Vistas/principal.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Obras extends StatefulWidget {
  @override
  _ObrasView createState() => _ObrasView();
  int id_cliente;
  int anio;
  Obras({
    this.id_cliente,
    this.anio,
  });
}

class _ObrasView extends State<Obras> {
  String fecha_integracion = '';
  String fecha_priorizacion = '';
  String fecha_adendum = '';
  String url;
  bool inicio = false;
  int id_cliente;
  int anio;
  List<Widget> lista_obras = [];
  List<Widget> send = [];
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
    final Obras args = ModalRoute.of(context).settings.arguments;
    id_cliente = args.id_cliente;
    anio = args.anio;
    if (!lista_obras.isEmpty && inicio) {
      _options();
    }
    if (send.isEmpty && !inicio) {
      _getListado(context);
      inicio = true;
    }
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(9, 46, 116, 1.0),
            centerTitle: true,
            title: Text("OBRA PÚBLICA"),
          ),
          bottomNavigationBar: _menuInferior(context),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/fondo.jpg.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: NestedScrollView(
              // Setting floatHeaderSlivers to true is required in order to float
              // the outer slivers over the inner scrollable.
              floatHeaderSlivers: false,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    toolbarHeight: 1,
                    title: const Text(''),
                    floating: false,
                    centerTitle: true,
                    forceElevated: innerBoxIsScrolled,
                    backgroundColor: const Color.fromRGBO(9, 46, 116, 1.0),
                  ),
                ];
              },
              body: SmartRefresher(
                enablePullDown: false,
                enablePullUp: false,
                controller: _refreshController,
                child: ListView.builder(
                  itemBuilder: (c, i) => send[i],
                  itemCount: send.length,
                ),
              ), //menu(context), //menu(context),
            ),
          )),
    );
  }

  void _options() {
    send.clear();
    send.add(SizedBox(
      height: 20,
    ));
    send.add(Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "ACTAS PRELIMINARES",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ),
    ));
    send.add(SizedBox(
      height: 10,
    ));
    send.add(Container(
      child: Column(
        children: [
          cards(
              context,
              "Acta de Integración del Consejo de Desarrollo Municipal",
              fecha_integracion),
          cards(context, "Acta de Priorización de Obras", fecha_priorizacion),
          cards(context, "Acta de Adendum a la Priorización de Obras",
              fecha_adendum),
        ],
      ),
    ));
    send.add(Container(
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          SizedBox(
            child: Center(
                child: Text(
              "LISTADO DE OBRAS",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            )),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    ));
    send.add(Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                "PROYECTO",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                "INVERSIÓN",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                "AVANCE",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        )));
    send.add(SizedBox(
      height: 10,
    ));
    send.add(Container(
      child: Column(
        children: lista_obras,
      ),
    ));
  }

//menu inferior
  Widget _menuInferior(BuildContext context) {
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
        if (index == 2) {
          Navigator.pushNamed(context, '/obras',
              arguments: Obras(
                anio: anio,
                id_cliente: id_cliente,
              ));
        }
        if (index == 3) {
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

//-----------Cards de Actas preliminares------------
  Widget cards(BuildContext context, nombre, fecha) {
    return Container(
      height: 65,
      child: Card(
        // RoundedRectangleBorder para proporcionarle esquinas circulares al Card
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        // margen para el Card
        margin: EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: 8,
        ),
        // La sombra que tiene el Card aumentará
        elevation: 10,
        //Colocamos una fila en dentro del card
        color: const Color.fromRGBO(9, 46, 116, 1.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                flex: 3,
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(nombre,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 15,
                        )))),
            Expanded(
              //columna fecha
              flex: 2,
              child: Text(fecha,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 15,
                  )),
            ),
            Expanded(
              flex: 1,
              child: Icon(
                Icons.get_app_rounded,
                color: Colors.green,
              ),
            )
          ],
        ),
      ),
    );
  }
// ------------- Cards Listado de obras -------------------

  Widget cards_listado(
      BuildContext context, nombre, monto, avance, id_obra, modalidad) {
    return Container(
        height: 70,
        child: InkWell(
          onTap: () {
            if (modalidad == 1) {
              Navigator.pushNamed(context, '/admin',
                  arguments: Obras_admin(
                    id_obra: id_obra,
                    id_cliente: id_cliente,
                    anio: anio,
                  ));
            }
            if (modalidad == 2) {
              Navigator.pushNamed(context, '/contrato',
                  arguments: Obras_contrato(
                    id_obra: id_obra,
                    id_cliente: id_cliente,
                    anio: anio,
                  ));
            }
          },
          child: Card(
            // RoundedRectangleBorder para proporcionarle esquinas circulares al Card
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(color: Colors.white),
            ),
            // margen para el Card
            margin: EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: 8,
            ),
            // La sombra que tiene el Card aumentará
            elevation: 10,
            //Colocamos una fila en dentro del card
            color: const Color.fromRGBO(9, 46, 116, 1.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    flex: 3,
                    child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(nombre,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontSize: 15,
                            )))),
                Expanded(
                  //columna fecha
                  flex: 2,
                  child: Text("\u0024 $monto",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 15,
                      )),
                ),
                Expanded(
                  flex: 1,
                  child: LinearPercentIndicator(
                    width: 60.0,
                    animation: true,
                    animationDuration: 1000,
                    lineHeight: 20.0,
                    percent: avance * 0.01,
                    linearStrokeCap: LinearStrokeCap.butt,
                    center: Text("$avance%"),
                    progressColor: Colors.green,
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void _showSecondPage(BuildContext context) {
    _getListado(context);
  }

  List<Widget> listado(List<dynamic> info) {
    List<Widget> lista = [];
    info.forEach((elemento) {
      int elemento_cliente = elemento['id_cliente'];
      lista.add(Text("$elemento_cliente"));
    });
    return lista;
  }

  Future<dynamic> _getListado(BuildContext context) async {
    send.clear();
    lista_obras.clear();
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
    url = "http://192.168.10.141/api/getObrasCliente/$id_cliente,$anio";
    print('$id_cliente $anio');
    try {
      final respuesta = await http.get(Uri.parse(url));
      if (respuesta.statusCode == 200) {
        bool resp = respuesta.body == "";
        if (respuesta.body != "") {
          final data = json.decode(respuesta.body);
          data.forEach((e) {
            fecha_integracion = e['acta_integracion_consejo'];
            fecha_priorizacion = e['acta_priorizacion'];
            fecha_adendum = e['adendum_priorizacion'];
            double avance =
                int.parse(e['avance_tecnico'].toStringAsFixed(0)).toDouble();
            double monto_contratado = e['monto_contratado'].toDouble();
            String nombre = e['nombre_obra'];
            if (nombre.length > 48) {
              nombre = nombre.substring(0, 53) + '...';
            }
            lista_obras.add(cards_listado(
                context,
                nombre,
                numberFormat(monto_contratado),
                avance,
                e['id_obra'],
                e['modalidad_ejecucion']));
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
      print(e);
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
}
