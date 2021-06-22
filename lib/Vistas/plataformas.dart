import 'package:flutter/material.dart';
import 'package:flutter_app/Vistas/anio.dart';
import 'package:flutter_app/Vistas/obra_admin.dart';
import 'package:flutter_app/Vistas/obra_contrato.dart';
import 'package:flutter_app/Vistas/obra_publica.dart';
import 'package:flutter_app/Vistas/principal.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Plataformas extends StatefulWidget {
  @override
  _PlataformasView createState() => _PlataformasView();
  int id_cliente;
  int anio;

  Plataformas({
    this.id_cliente,
    this.anio,
  });
}

class _PlataformasView extends State<Plataformas> {
  String fecha_integracion = '';
  String fecha_priorizacion = '';
  String fecha_adendum = '';
  String url;
  bool inicio = false;
  int id_cliente;
  int anio;
  List<Widget> lista_obras = [];
  List<Widget> send = [];
  int firma_electronica;
  int convenio;
  int validado;
  int revisado;
  bool prodim;
  bool gi;
  List<Widget> mids = [];
  List<Widget> sisplade = [];
  List<Widget> rft = [];
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
    final Plataformas args = ModalRoute.of(context).settings.arguments;
    id_cliente = args.id_cliente;
    anio = args.anio;

    if (!mids.isEmpty && inicio) {
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
            title: Text("PLATAFORMAS DIGITALES"),
          ),
          bottomNavigationBar: _menuInferior(context),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/Fondo03.png"),
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
    send.add(
      Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Matriz de Inversión para el Desarrollo Social (MIDS)",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
    send.add(SizedBox(
      height: 10,
    ));
    send.add(Container(
      child: Column(
        children: mids,
      ),
    ));
    send.add(SizedBox(
      height: 30,
    ));
    send.add(
      Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Sistema de Información para la Planeación del Desarrollo de Oaxaca (SISPLADE)",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
    send.add(SizedBox(
      height: 10,
    ));
    send.add(Container(
      child: Column(
        children: sisplade,
      ),
    ));
    send.add(SizedBox(
      height: 30,
    ));
    send.add(
      Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Informe de Recursos Federales Transferidos (RFT)",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
    send.add(SizedBox(
      height: 10,
    ));
    send.add(
      Container(
        child: Column(
          children: rft,
        ),
      ),
    );
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

  Widget cards_listado(
      BuildContext context, nombre, primero, segundo, tercero, cuarto) {
    return Container(
        height: 130,
        child: InkWell(
          child: Card(
              // RoundedRectangleBorder para proporcionarle esquinas circulares al Card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    nombre,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Trimestre',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "1ro",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        //columna fecha
                        flex: 2,
                        child: Text(
                          "2do",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        //columna fecha
                        flex: 2,
                        child: Text(
                          "3ro",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        //columna fecha
                        flex: 2,
                        child: Text(
                          "4to",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 2,
                        child: LinearPercentIndicator(
                          animation: true,
                          animationDuration: 1000,
                          lineHeight: 20.0,
                          percent: primero * 0.01,
                          linearStrokeCap: LinearStrokeCap.butt,
                          center: Text(
                            "$primero%",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                            ),
                          ),
                          progressColor: const Color.fromRGBO(0, 153, 51, 1.0),
                          backgroundColor:
                              const Color.fromRGBO(133, 138, 141, 1.0),
                        ),
                      ),
                      Expanded(
                        //columna fecha
                        flex: 2,
                        child: LinearPercentIndicator(
                          animation: true,
                          animationDuration: 1000,
                          lineHeight: 20.0,
                          percent: segundo * 0.01,
                          linearStrokeCap: LinearStrokeCap.butt,
                          center: Text(
                            "$segundo%",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                            ),
                          ),
                          progressColor: const Color.fromRGBO(0, 153, 51, 1.0),
                          backgroundColor:
                              const Color.fromRGBO(133, 138, 141, 1.0),
                        ),
                      ),
                      Expanded(
                        //columna fecha
                        flex: 2,
                        child: LinearPercentIndicator(
                          animation: true,
                          animationDuration: 1000,
                          lineHeight: 20.0,
                          percent: tercero * 0.01,
                          linearStrokeCap: LinearStrokeCap.butt,
                          center: Text(
                            "$tercero%",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                            ),
                          ),
                          progressColor: const Color.fromRGBO(0, 153, 51, 1.0),
                          backgroundColor:
                              const Color.fromRGBO(133, 138, 141, 1.0),
                        ),
                      ),
                      Expanded(
                        //columna fecha
                        flex: 2,
                        child: Center(
                          child: LinearPercentIndicator(
                            animation: true,
                            animationDuration: 1000,
                            lineHeight: 20.0,
                            percent: cuarto * 0.01,
                            linearStrokeCap: LinearStrokeCap.butt,
                            center: Text(
                              "$cuarto%",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 13,
                              ),
                            ),
                            progressColor:
                                const Color.fromRGBO(0, 153, 51, 1.0),
                            backgroundColor:
                                const Color.fromRGBO(133, 138, 141, 1.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ));
  }

  Widget cards_desglose(BuildContext context, nombre, monto) {
    return Container(
      height: 65,
      child: Card(
        // RoundedRectangleBorder para proporcionarle esquinas circulares al Card
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        // margen para el Card
        margin: EdgeInsets.only(
          left: 30,
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
              flex: 1,
              child: Text("\u0024 $monto",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 15,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget cards(BuildContext context, nombre, estado) {
    IconData estado_icon;
    Color color;
    Color color_barra;
    if (estado == 1) {
      estado_icon = Icons.check_circle_rounded;
      color = Colors.green;
      color_barra = const Color.fromRGBO(9, 46, 116, 1.0);
    }
    if (estado == 2) {
      estado_icon = Icons.cancel /*check_circle_rounded*/;
      color = Colors.red;
      color_barra = const Color.fromRGBO(9, 46, 116, 1.0);
    }

    if (estado == 3) {
      estado_icon = Icons.remove_circle;
      color = Colors.yellow;
      color_barra = Colors.grey[500];
    }
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
        color: color_barra,
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
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        )))),
            Expanded(
              flex: 1,
              child: Icon(
                estado_icon,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
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
    mids.clear();
    rft.clear();
    sisplade.clear();
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
    url = "http://192.168.10.160:8000/api/getRFT/$id_cliente,$anio";
    print('$id_cliente $anio');
    try {
      final respuesta = await http.get(Uri.parse(url));
      print(respuesta.body);
      if (respuesta.statusCode == 200) {
        bool resp = respuesta.body == "";
        if (respuesta.body != "") {
          final data = json.decode(respuesta.body);
          data.forEach((e) {
            final mids_1 = json.encode(e['mids']);
            dynamic mids_2 = json.decode(mids_1);

            mids_2.forEach((i) {
              mids.add(cards(context, 'Planeado', i['planeado']));
              mids.add(cards(context, 'Validado', i['validado']));
              mids.add(cards(context, 'Firmado', i['firmado']));
            });

            final sisplade_1 = json.encode(e['sisplade']);
            dynamic sisplade_2 = json.decode(sisplade_1);

            sisplade_2.forEach((i) {
              sisplade.add(cards(context, 'Planeado', i['planeado']));
              sisplade.add(cards(context, 'Capturado', i['capturado']));
              sisplade.add(cards(context, 'Validado', i['validado']));
            });

            final comprometido = json.encode(e['rft']);
            print("hola3");
            dynamic comprometido_1 = json.decode(comprometido);

            comprometido_1.forEach((i) {
              print(i['nombre_obra']);
              print(i['primer_trimestre']);
              print(i['segundo_trimestre']);
              print(i['tercer_trimestre']);
              print(i['cuarto_trimestre']);
              rft.add(cards_listado(
                  context,
                  i['nombre_obra'],
                  i['primer_trimestre'],
                  i['segundo_trimestre'],
                  i['tercer_trimestre'],
                  i['cuarto_trimestre']));
            });
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
