import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Vistas/anio.dart';
import 'package:flutter_app/Vistas/login.dart';
import 'package:flutter_app/Vistas/principal.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getwidget/components/accordian/gf_accordian.dart';
import 'package:ndialog/ndialog.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:ui';
import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ObrasAdmin extends StatefulWidget with WidgetsBindingObserver {
  final TargetPlatform platform;
  @override
  _ObrasView createState() => _ObrasView();
  final int idObra;
  final int idCliente;
  final int anio;
  final int clave;
  final String nombre;
  final String nombreArchivo;
  final String path;
  ObrasAdmin({
    Key key,
    this.idObra,
    this.idCliente,
    this.anio,
    this.platform,
    this.clave,
    this.nombre,
    this.nombreArchivo,
    this.path,
  }) : super(key: key);
}

class _ObrasView extends State<ObrasAdmin> {
  String nombreObra = 'Ejemplo de nombre de obra';
  String nombreCorto = 'Ejemplo de nombre de obra';
  String monto = '10,000';
  double avanceFisico = 20.0;
  double avanceTecnico = 20.0;
  double avanceEconomico = 20.0;
  String url;
  bool inicio = false;
  int idCliente;
  int anio;
  int modalidad = 2;
  int idObra;
  List<Widget> listaObras = [];
  List<Widget> send = [];
  List<int> exp = [];
  List<String> fondo = [];
  List<Widget> facturas = [];
  List<Widget> listas = [];
  List<Widget> arrendamientos = [];
  String observaciones = '';
  int claveMunicipio;
  String nombreArchivo;
  String fechaActualizacion;

  //DOWNLOAD ARCHIVOS
  bool visibilityObj = false;

  //Variables descargar archivos
  bool isLoading;
  bool _allowWriteFile = false;
  String ruta;

  String progress = "";
  Dio dio;
  Course s;
  String _localPath;

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
    final ObrasAdmin args = ModalRoute.of(context).settings.arguments;
    idObra = args.idObra;
    idCliente = args.idCliente;
    anio = args.anio;
    claveMunicipio = args.clave;
    nombreCorto = args.nombre;
    nombreArchivo = args.nombreArchivo;
    _localPath = args.path;
    /*_getListado(context);*/
    if (exp.isNotEmpty && inicio) {
      _options();
    }
    if (send.isEmpty && !inicio) {
      _getListado(context);
      listas.add(
        Container(
          height: 30,
          child: Card(
            // RoundedRectangleBorder para proporcionarle esquinas circulares al Card
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            // margen para el Card
            margin: EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: 8,
            ),
            // La sombra que tiene el Card aumentará
            elevation: 0,
            //Colocamos una fila en dentro del card
            color: Colors.transparent,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    flex: 3,
                    child: Text('Fecha de inicio',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromRGBO(9, 46, 116, 1.0),
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ))),
                Expanded(
                    flex: 3,
                    child: Text('Fecha de fin',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromRGBO(9, 46, 116, 1.0),
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ))),
                Expanded(
                    flex: 3,
                    child: Text('Monto',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromRGBO(9, 46, 116, 1.0),
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ))),
              ],
            ),
          ),
        ),
      );
      arrendamientos.add(
        Container(
          height: 30,
          child: Card(
            // RoundedRectangleBorder para proporcionarle esquinas circulares al Card
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            // margen para el Card
            margin: EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: 8,
            ),
            // La sombra que tiene el Card aumentará
            elevation: 0,
            //Colocamos una fila en dentro del card
            color: Colors.transparent,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    flex: 3,
                    child: Text('Fecha de inicio',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromRGBO(9, 46, 116, 1.0),
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ))),
                Expanded(
                    flex: 3,
                    child: Text('Fecha de fin',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromRGBO(9, 46, 116, 1.0),
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ))),
                Expanded(
                    flex: 3,
                    child: Text('Monto',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromRGBO(9, 46, 116, 1.0),
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ))),
              ],
            ),
          ),
        ),
      );
      facturas.add(
        Container(
          height: 30,
          child: Card(
            // RoundedRectangleBorder para proporcionarle esquinas circulares al Card
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            // margen para el Card
            margin: EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: 8,
            ),
            // La sombra que tiene el Card aumentará
            elevation: 0,
            //Colocamos una fila en dentro del card
            color: Colors.transparent,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Folio fiscal',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromRGBO(9, 46, 116, 1.0),
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Monto',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromRGBO(9, 46, 116, 1.0),
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      inicio = true;
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(9, 46, 116, 1.0),
          centerTitle: true,
          title: Text("EXPEDIENTE TÉCNICO"),
        ),
        bottomNavigationBar: _menuInferior(context),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/Fondo06.png"),
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
        ),
      ),
    );
  }

  void _options() {
    send.clear();
    int avanceFisico1 = avanceFisico.toInt();
    int avanceEconomico1 = avanceEconomico.toInt();
    int avanceTecnico1 = avanceTecnico.toInt();
    bool nombre = nombreCorto == nombreObra;

    Course object = Course(
        title: "CHECKLIST OBRA",
        path:
            'http://sistema.mrcorporativo.com/archivos/$claveMunicipio/$anio/obras/$idObra/checklist/$nombreArchivo.pdf');
    String url = object.path;
    String title = object.title;
    String extension = url.substring(url.lastIndexOf("/"));
    File f = File(_localPath + "$extension");
    send.add(SizedBox(
      height: 30,
    ));

    send.add(visibilityObj
        ? new Container()
        : Container(
            margin: EdgeInsets.only(left: 15, right: 15),
            child: Text(
              nombreCorto.toUpperCase(),
              style: TextStyle(
                color: Color.fromRGBO(9, 46, 116, 1.0),
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ));
    send.add(
      visibilityObj
          ? Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: Text(
                nombreObra.toUpperCase(),
                style: TextStyle(
                  color: Color.fromRGBO(9, 46, 116, 1.0),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                textAlign: TextAlign.justify,
              ),
            )
          : new Container(),
    );
    send.add(
      Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: InkWell(
          onTap: () {
            _changed(visibilityObj);
          },
          child: Card(
            // RoundedRectangleBorder para proporcionarle esquinas circulares al Card
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(color: Colors.transparent),
            ),
            // margen para el Card
            margin: EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: 8,
            ),
            // La sombra que tiene el Card aumentará
            elevation: 0,
            //Colocamos una fila en dentro del card
            color: Colors.transparent,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: nombre ? 0 : 5,
                  child: nombre
                      ? new Container()
                      : Container(
                          child: Text(
                            visibilityObj ? "Ver menos" : "Ver más",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: RawMaterialButton(
                          onPressed: () {
                            if (f.existsSync()) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return PDFScreen(
                                  pathPDF: f.path,
                                  nombre: title,
                                );
                              }));
                              return;
                            }
                            
                            downloadFile(url, "$_localPath/$extension");
                          },
                          child: f.existsSync()
                              ? Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 5),
                                    child: new Icon(
                                      Icons.remove_red_eye,
                                      color: Colors.green,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Descargar checklist',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                        ),
                      ),
                      Expanded(
                        flex: f.existsSync() ? 2 : 0,
                        child: f.existsSync()
                            ? RawMaterialButton(
                                onPressed: () {
                                  delete("$_localPath/$extension");
                                },
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: new Icon(
                                      Icons.delete_forever,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              )
                            : new Container(
                                height: 0,
                              ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    send.add(SizedBox(
      height: 10,
    ));
    send.add(
      Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Text(
          'Modalidad de ejecucion: Administración Directa',
          style: TextStyle(
            color: Color.fromRGBO(9, 46, 116, 1.0),
            fontWeight: FontWeight.w300,
            fontSize: 18,
          ),
        ),
      ),
    );

    send.add(SizedBox(
      height: 10,
    ));
    send.add(
      Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 20),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                flex: 3,
                child: Text('Inversión',
                    style: TextStyle(
                      color: Color.fromRGBO(9, 46, 116, 1.0),
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ))),
            Expanded(
              //columna fecha
              flex: 5,
              child: Text(
                '\u0024 $monto',
                style: TextStyle(
                  color: Color.fromRGBO(9, 46, 116, 1.0),
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    for (var i = 0; i < fondo.length; i++) {
      String fondoT = fondo[i];
      i++;
      String montoT = fondo[i];
      send.add(
        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                  flex: 3,
                  child: Text(fondoT,
                      style: TextStyle(
                        color: Color.fromRGBO(9, 46, 116, 1.0),
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                      ))),
              Expanded(
                //columna fecha
                flex: 5,
                child: Text(
                  '\u0024 $montoT',
                  style: TextStyle(
                    color: Color.fromRGBO(9, 46, 116, 1.0),
                    fontWeight: FontWeight.w300,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    send.add(
      SizedBox(
        height: 20,
      ),
    );
    send.add(
      Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Row(
          children: [
            Text(
              'Última modificación: ',
              style: TextStyle(
                color: Color.fromRGBO(9, 46, 116, 1.0),
                fontWeight: FontWeight.w400,
                fontSize: 17,
              ),
            ),
            Text(
              '$fechaActualizacion',
              style: TextStyle(
                color: Color.fromRGBO(9, 46, 116, 1.0),
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
    send.add(SizedBox(
      height: 30,
    ));
    send.add(
      Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Text(
          'Porcentaje de avance',
          style: TextStyle(
            color: Color.fromRGBO(9, 46, 116, 1.0),
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
    send.add(SizedBox(
      height: 10,
    ));
    send.add(
      Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 5),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            /*Expanded(
                flex: 3,
                child: Text('Avance Financiero',
                    style: TextStyle(
                      color: Color.fromRGBO(9, 46, 116, 1.0),
                      fontWeight: FontWeight.w300,
                      fontSize: 17,
                    ))),*/
            Expanded(
              //columna fecha
              flex: 5,
              child: CircularPercentIndicator(
                radius: 80.0,
                animation: true,
                animationDuration: 1000,
                percent: avanceFisico1 * 0.01,
                circularStrokeCap: CircularStrokeCap.round,
                center: Text(
                  "$avanceFisico1%",
                  style: TextStyle(
                    color: Color.fromRGBO(9, 46, 116, 1.0),
                    fontWeight: FontWeight.w400,
                    fontSize: 17,
                  ),
                ),
                progressColor: Colors.blue,
                backgroundColor: Colors.grey[350],
                lineWidth: 8,
                footer: Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  height: 30,
                  child: Center(
                    child: Text(
                      "Fisico",
                      style: new TextStyle(
                          color: Color.fromRGBO(9, 46, 116, 1.0),
                          fontWeight: FontWeight.w400,
                          fontSize: 17.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              //columna fecha
              flex: 5,
              child: CircularPercentIndicator(
                radius: 80.0,
                animation: true,
                animationDuration: 1000,
                percent: avanceEconomico * 0.01,
                circularStrokeCap: CircularStrokeCap.round,
                center: Text(
                  "$avanceEconomico1%",
                  style: TextStyle(
                    color: Color.fromRGBO(9, 46, 116, 1.0),
                    fontWeight: FontWeight.w400,
                    fontSize: 17,
                  ),
                ),
                progressColor: Colors.blue,
                backgroundColor: Colors.grey[350],
                lineWidth: 8,
                footer: Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  height: 30,
                  child: Center(
                    child: Text(
                      "Financiero",
                      style: new TextStyle(
                          color: Color.fromRGBO(9, 46, 116, 1.0),
                          fontWeight: FontWeight.w400,
                          fontSize: 17.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              //columna fecha
              flex: 5,
              child: CircularPercentIndicator(
                radius: 80.0,
                animation: true,
                animationDuration: 1000,
                percent: avanceTecnico1 * 0.01,
                circularStrokeCap: CircularStrokeCap.round,
                center: Text(
                  '$avanceTecnico1%',
                  style: TextStyle(
                    color: Color.fromRGBO(9, 46, 116, 1.0),
                    fontWeight: FontWeight.w400,
                    fontSize: 17,
                  ),
                ),
                progressColor: Colors.blue,
                backgroundColor: Colors.grey[350],
                lineWidth: 8,
                footer: Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  height: 30,
                  child: Center(
                    child: Text(
                      'Expediente\nTécnico',
                      style: new TextStyle(
                          color: Color.fromRGBO(9, 46, 116, 1.0),
                          fontWeight: FontWeight.w400,
                          fontSize: 17.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    send.add(SizedBox(
      height: 10,
    ));

    send.add(
      Container(
        child: GFAccordion(
          titleBorder: Border.all(
            width: 1.0,
            color: Color.fromRGBO(9, 46, 116, 1.0),
          ),
          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
          titlePadding:
              EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          titleChild: Text(
            'Parte social',
            style: TextStyle(
              color: Color.fromRGBO(9, 46, 116, 1.0),
              fontWeight: FontWeight.w500,
              fontSize: 17,
            ),
          ),
          expandedTitleBackgroundColor: Colors.transparent,
          collapsedTitleBackgroundColor: Colors.transparent,
          contentBackgroundColor: Color.fromRGBO(204, 204, 204, 0.3),
          contentChild: Container(
            child: Column(
              children: [
                cards(
                    context,
                    "Acta de integración del consejo de desarrollo municipal",
                    exp[0]),
                cards(context, "Acta de selección de obras", exp[1]),
                cards(
                    context,
                    "Acta de priorización de obras, acciones sociales básicas e inversión",
                    exp[2]),
                cards(context, "Convenio celebrado para mezcla de recursos",
                    exp[3]),
                cards(
                    context, "Acta de integración del comité de obras", exp[4]),
                cards(context, "Convenio de concertación", exp[5]),
                cards(
                    context,
                    "Acta de aprobación y autorización de obras, acciones sociales e inversiones",
                    exp[6]),
                cards(
                    context,
                    "Acta de acuerdo de cabildo para administración directa",
                    exp[7]),
              ],
            ),
          ),
          collapsedIcon: Icon(
            Icons.arrow_drop_down_outlined,
            color: Color.fromRGBO(9, 46, 116, 1.0),
          ),
          expandedIcon: Icon(
            Icons.arrow_drop_up,
            color: Color.fromRGBO(9, 46, 116, 1.0),
          ),
        ),
      ),
    );
    send.add(
      Container(
        child: GFAccordion(
          titleBorder: Border.all(
            width: 1.0,
            color: Color.fromRGBO(9, 46, 116, 1.0),
          ),
          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
          titlePadding:
              EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          titleChild: Text(
            'Proyecto ejecutivo',
            style: TextStyle(
              color: Color.fromRGBO(9, 46, 116, 1.0),
              fontWeight: FontWeight.w500,
              fontSize: 17,
            ),
          ),
          expandedTitleBackgroundColor: Colors.transparent,
          collapsedTitleBackgroundColor: Colors.transparent,
          contentBackgroundColor: Color.fromRGBO(204, 204, 204, 0.3),
          contentChild: Container(
            child: Column(
              children: [
                cards(context, "Estudio de factibilidad técnica", exp[8]),
                cards(
                    context,
                    "Oficio de notificación de aprobación y autorización de obras",
                    exp[9]),
                cards(context, "Anexo del oficio de notificación", exp[10]),
                cards(context, "Cédula de información básica", exp[11]),
                cards(context, "Generalidades de la inversión", exp[12]),
                cards(
                    context,
                    "Documentos que acrediten la tenecia de la tierra",
                    exp[13]),
                cards(context, "Dictamen de impacto ambiental", exp[14]),
                cards(context, "Presupuesto de obra", exp[15]),
                cards(context, "Catálogo de conceptos", exp[16]),
                cards(context, "Explosión de insumos", exp[17]),
                cards(context, "Generadores de obra programada", exp[18]),
                cards(context, "Planos del proyecto", exp[19]),
                cards(context, "Especificaciones generales y particulares",
                    exp[20]),
                cards(context, "Firma del director responsable de obra (DRO)",
                    exp[21]),
                cards(context, "Croquis de macrolocalización", exp[22]),
                cards(context, "Croquis de microlocalización", exp[23]),
              ],
            ),
          ),
          collapsedIcon: Icon(
            Icons.arrow_drop_down_outlined,
            color: Color.fromRGBO(9, 46, 116, 1.0),
          ),
          expandedIcon: Icon(
            Icons.arrow_drop_up,
            color: Color.fromRGBO(9, 46, 116, 1.0),
          ),
        ),
      ),
    );
    send.add(
      Container(
        child: GFAccordion(
          titleBorder: Border.all(
            width: 1.0,
            color: Color.fromRGBO(9, 46, 116, 1.0),
          ),
          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
          titlePadding:
              EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          titleChild: Text(
            'Documentación comprobatoria',
            style: TextStyle(
              color: Color.fromRGBO(9, 46, 116, 1.0),
              fontWeight: FontWeight.w500,
              fontSize: 17,
            ),
          ),
          expandedTitleBackgroundColor: Colors.transparent,
          collapsedTitleBackgroundColor: Colors.transparent,
          contentBackgroundColor: Color.fromRGBO(204, 204, 204, 0.3),
          contentChild: Container(
            child: Column(
              children: [
                cards(
                    context,
                    "Inventario de maquinarias y equipo de construcción",
                    exp[24]),
                cards(context, "Identificación oficial de los trabajadores",
                    exp[25]),
                cards(context, "Reporte fotografico", exp[26]),
                cards(context, "Notas de bitacoras", exp[27]),
                cards(
                    context,
                    "Acta entrega recepción del municipio a los beneficiarios",
                    exp[28]),
                cards(context, "Cedula detallada de facturación", exp[29]),
              ],
            ),
          ),
          collapsedIcon: Icon(
            Icons.arrow_drop_down_outlined,
            color: Color.fromRGBO(9, 46, 116, 1.0),
          ),
          expandedIcon: Icon(
            Icons.arrow_drop_up,
            color: Color.fromRGBO(9, 46, 116, 1.0),
          ),
        ),
      ),
    );
    if (listas.length > 1) {
      send.add(
        Container(
          child: GFAccordion(
            titleBorder: Border.all(
              width: 1.0,
              color: Color.fromRGBO(9, 46, 116, 1.0),
            ),
            margin: EdgeInsets.only(top: 10, left: 25, right: 10),
            titlePadding:
                EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            titleChild: Text(
              'Lista de raya',
              style: TextStyle(
                color: Color.fromRGBO(9, 46, 116, 1.0),
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ),
            ),
            expandedTitleBackgroundColor: Colors.transparent,
            collapsedTitleBackgroundColor: Colors.transparent,
            contentBackgroundColor: Color.fromRGBO(204, 204, 204, 0.3),
            contentChild: Container(
              child: Column(
                children: listas,
              ),
            ),
            collapsedIcon: Icon(
              Icons.arrow_drop_down_outlined,
              color: Color.fromRGBO(9, 46, 116, 1.0),
            ),
            expandedIcon: Icon(
              Icons.arrow_drop_up,
              color: Color.fromRGBO(9, 46, 116, 1.0),
            ),
          ),
        ),
      );
    }
    if (arrendamientos.length > 1) {
      send.add(
        Container(
          child: GFAccordion(
            titleBorder: Border.all(
              width: 1.0,
              color: Color.fromRGBO(9, 46, 116, 1.0),
            ),
            margin: EdgeInsets.only(top: 10, left: 25, right: 10),
            titlePadding:
                EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            titleChild: Text(
              'Contratos de arrendamiento',
              style: TextStyle(
                color: Color.fromRGBO(9, 46, 116, 1.0),
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ),
            ),
            expandedTitleBackgroundColor: Colors.transparent,
            collapsedTitleBackgroundColor: Colors.transparent,
            contentBackgroundColor: Color.fromRGBO(204, 204, 204, 0.3),
            contentChild: Container(
              child: Column(
                children: arrendamientos,
              ),
            ),
            collapsedIcon: Icon(
              Icons.arrow_drop_down_outlined,
              color: Color.fromRGBO(9, 46, 116, 1.0),
            ),
            expandedIcon: Icon(
              Icons.arrow_drop_up,
              color: Color.fromRGBO(9, 46, 116, 1.0),
            ),
          ),
        ),
      );
    }
    if (facturas.length > 1) {
      send.add(
        Container(
          child: GFAccordion(
            titleBorder: Border.all(
              width: 1.0,
              color: Color.fromRGBO(9, 46, 116, 1.0),
            ),
            margin: EdgeInsets.only(top: 10, left: 25, right: 10),
            titlePadding:
                EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            titleChild: Text(
              'Facturas',
              style: TextStyle(
                color: Color.fromRGBO(9, 46, 116, 1.0),
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ),
            ),
            expandedTitleBackgroundColor: Colors.transparent,
            collapsedTitleBackgroundColor: Colors.transparent,
            contentBackgroundColor: Color.fromRGBO(204, 204, 204, 0.3),
            contentChild: Container(
              child: Column(
                children: facturas,
              ),
            ),
            collapsedIcon: Icon(
              Icons.arrow_drop_down_outlined,
              color: Color.fromRGBO(9, 46, 116, 1.0),
            ),
            expandedIcon: Icon(
              Icons.arrow_drop_up,
              color: Color.fromRGBO(9, 46, 116, 1.0),
            ),
          ),
        ),
      );
    }
    if (observaciones != '') {
      observaciones = observaciones.substring(0, observaciones.length - 3);
      send.add(
        Container(
          child: GFAccordion(
            titleBorder: Border.all(
              width: 1.0,
              color: Color.fromRGBO(9, 46, 116, 1.0),
            ),
            margin: EdgeInsets.only(top: 10, left: 10, right: 10),
            titlePadding:
                EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            titleChild: Text(
              'Observaciones',
              style: TextStyle(
                color: Color.fromRGBO(9, 46, 116, 1.0),
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ),
            ),
            expandedTitleBackgroundColor: Colors.transparent,
            collapsedTitleBackgroundColor: Colors.transparent,
            contentBackgroundColor: Color.fromRGBO(204, 204, 204, 0.3),
            contentChild: Container(
              child: Column(children: [
                Container(
                  width: MediaQuery.of(context).size.height,
                  child: Card(
                    // RoundedRectangleBorder para proporcionarle esquinas circulares al Card
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: BorderSide(
                        color: Color.fromRGBO(9, 46, 116, 1.0),
                      ),
                    ),
                    // margen para el Card
                    // La sombra que tiene el Card aumentará
                    elevation: 0,
                    //Colocamos una fila en dentro del card
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        observaciones,
                        style: TextStyle(
                          color: Color.fromRGBO(9, 46, 116, 1.0),
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            collapsedIcon: Icon(
              Icons.arrow_drop_down_outlined,
              color: Color.fromRGBO(9, 46, 116, 1.0),
            ),
            expandedIcon: Icon(
              Icons.arrow_drop_up,
              color: Color.fromRGBO(9, 46, 116, 1.0),
            ),
          ),
        ),
      );
    }
    send.add(SizedBox(
      height: 35,
    ));
  }

//menu inferior
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
          CupertinoIcons.book,
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
              path: _localPath,
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
                  _saveValue("");
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

  void _changed(bool visibility) {
    setState(() {
      visibilityObj = !visibility;
    });
  }

//-----------Cards de Actas preliminares------------
  Widget cards(BuildContext context, nombre, estado) {
    IconData estadoIcon;
    Color color;
    Widget ret;

    if (estado == 1) {
      estadoIcon = Icons.check_circle_rounded;
      color = Colors.blue;
    }
    if (estado == 2) {
      estadoIcon = Icons.cancel /*check_circle_rounded*/;
      color = Colors.red;
    }

    if (estado == 3) {
      estadoIcon = Icons.remove_circle;
      color = Colors.yellow;
    }
    bool estado_2 = estado == 3;
    estado_2
        ? ret = new Container()
        : ret = new Container(
            height: 65,
            child: Card(
              // RoundedRectangleBorder para proporcionarle esquinas circulares al Card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: BorderSide(
                  color: Color.fromRGBO(9, 46, 116, 1.0),
                ),
              ),
              // margen para el Card
              margin: EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 8,
              ),
              // La sombra que tiene el Card aumentará
              elevation: 0,
              //Colocamos una fila en dentro del card
              color: Colors.transparent,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        nombre,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color.fromRGBO(9, 46, 116, 1.0),
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Icon(
                      estadoIcon,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          );
    return ret;
  }

  Widget cardsFacturas(BuildContext context, folio, monto) {
    return Container(
      height: 65,
      child: Card(
        // RoundedRectangleBorder para proporcionarle esquinas circulares al Card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(
            color: Color.fromRGBO(9, 46, 116, 1.0),
          ),
        ),
        // margen para el Card
        margin: EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: 8,
        ),
        // La sombra que tiene el Card aumentará
        elevation: 0,
        //Colocamos una fila en dentro del card
        color: Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  folio,
                  style: TextStyle(
                    color: Color.fromRGBO(9, 46, 116, 1.0),
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  monto,
                  style: TextStyle(
                    color: Color.fromRGBO(9, 46, 116, 1.0),
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardsLista(BuildContext context, fechaInicio, fechaFin, monto) {
    return Container(
      height: 65,
      child: Card(
        // RoundedRectangleBorder para proporcionarle esquinas circulares al Card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(
            color: Color.fromRGBO(9, 46, 116, 1.0),
          ),
        ),
        // margen para el Card
        margin: EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: 8,
        ),
        // La sombra que tiene el Card aumentará
        elevation: 0,
        //Colocamos una fila en dentro del card
        color: Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  fechaInicio,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(9, 46, 116, 1.0),
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  fechaFin,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(9, 46, 116, 1.0),
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10, left: 30),
                child: Text(
                  monto,
                  style: TextStyle(
                    color: Color.fromRGBO(9, 46, 116, 1.0),
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
// ------------- Cards Listado de obras -------------------

  Widget cardsListado(
      BuildContext context, nombre, monto, avance, idObra, modalidad) {
    send.clear();

    return Container(
        height: 70,
        child: InkWell(
          onTap: () {},
          child: Card(
            // RoundedRectangleBorder para proporcionarle esquinas circulares al Card
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(
                color: Color.fromRGBO(9, 46, 116, 1.0),
              ),
            ),
            // margen para el Card
            margin: EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: 8,
            ),
            // La sombra que tiene el Card aumentará
            elevation: 0,
            //Colocamos una fila en dentro del card
            color: Colors.transparent,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    flex: 3,
                    child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(nombre,
                            style: TextStyle(
                              color: Color.fromRGBO(9, 46, 116, 1.0),
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            )))),
                Expanded(
                  //columna fecha
                  flex: 2,
                  child: Text("\u0024 $monto",
                      style: TextStyle(
                        color: Color.fromRGBO(9, 46, 116, 1.0),
                        fontWeight: FontWeight.w400,
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

  List<Widget> listado(List<dynamic> info) {
    List<Widget> lista = [];
    info.forEach((elemento) {
      int elementoCliente = elemento['id_cliente'];
      lista.add(Text("$elementoCliente"));
    });
    return lista;
  }

  Future<dynamic> _getListado(BuildContext context) async {
    send.clear();
    listaObras.clear();
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.white
      ..backgroundColor = Colors.transparent
      ..boxShadow = [BoxShadow(color: Colors.transparent)]
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
    url = "http://sistema.mrcorporativo.com/api/getObraExpediente/$idObra";
    try {
      final respuesta = await http.get(Uri.parse(url));
      if (respuesta.statusCode == 200) {
        if (respuesta.body != "") {
          final data = json.decode(respuesta.body);
          /*final parte_social = json.encode(data['parte_social']);
          final data1 = json.decode(parte_social);*/
          data.forEach((e) {
            final parteSocial = json.encode(e['parte_social']);

            dynamic data1 = json.decode(parteSocial);
            data1.forEach((i) {
              if (i != null) {
                exp.add(i['acta_integreacion_consejo']);
                exp.add(i['acta_seleccion_obras']);
                exp.add(i['acta_priorizacion_obras']);
                exp.add(i['convenio_mezcla']);
                exp.add(i['acta_integracion_comite']);
                exp.add(i['convenio_concertacion']);
                exp.add(i['acta_aprobacion_obra']);
                exp.add(i['acta_excep_licitacion']);
                exp.add(i['estudio_factibilidad']);
                exp.add(i['oficio_aprobacion_obra']);
                exp.add(i['anexos_oficio_notificacion']);
                exp.add(i['cedula_informacion_basica']);
                exp.add(i['generalidades_inversion']);
                exp.add(i['tenencia_tierra']);
                exp.add(i['dictamen_impacto_ambiental']);
                exp.add(i['presupuesto_obra']);
                exp.add(i['catalogo_conceptos']);
                exp.add(i['explosion_insumos']);
                exp.add(i['generadores_obra']);
                exp.add(i['planos_proyecto']);
                exp.add(i['especificaciones_generales_particulares']);
                exp.add(i['dro']);
                exp.add(i['croquis_macro']);
                exp.add(i['croquis_micro']);
              }
            });
            final parteAdmin = json.encode(e['obra_exp']);
            data1 = json.decode(parteAdmin);
            data1.forEach((i) {
              if (i != null) {
                exp.add(i['inventario_maquinaria_construccion']);
                exp.add(i['indentificacion_oficial_trabajadores']);
                exp.add(i['reporte_fotografico']);
                exp.add(i['notas_bitacora']);
                exp.add(i['acta_entrega_municipio']);
                exp.add(i['cedula_detallada_facturacion']);
              }
            });
            final parteObra = json.encode(e['obra']);
            data1 = json.decode('[' + parteObra + ']');
            data1.forEach((i) {
              if (i != null) {
                nombreObra = i['nombre_obra'];
                nombreCorto = i['nombre_corto'];
                monto = numberFormat(i['monto_contratado'].toDouble());
                avanceFisico =
                    int.parse(i['avance_fisico'].toStringAsFixed(0)).toDouble();
                avanceEconomico =
                    int.parse(i['avance_economico'].toStringAsFixed(0))
                        .toDouble();
                fechaActualizacion = i['fecha_actualizacion'];
                avanceTecnico =
                    int.parse(i['avance_tecnico'].toStringAsFixed(0))
                        .toDouble();
              }
            });
            final parteFondo = json.encode(e['fondo']);
            data1 = json.decode(parteFondo);
            data1.forEach((i) {
              if (i != null) {
                fondo.add(i['nombre_corto']);
                fondo.add(numberFormat(i['monto'].toDouble()));
              }
            });
            final parteLista = json.encode(e['obra_lista']);
            data1 = json.decode(parteLista);
            data1.forEach((i) {
              if (i != null) {
                String monto = numberFormat(i['total'].toDouble());
                listas.add(
                  cardsLista(context, i['fecha_inicio'], i['fecha_fin'],
                      '\u0024 $monto'),
                );
              }
            });
            final parteFacturas = json.encode(e['obra_facturas']);
            data1 = json.decode(parteFacturas);
            data1.forEach((i) {
              if (i != null) {
                String monto = numberFormat(i['total'].toDouble());
                facturas.add(
                  cardsFacturas(context, i['folio_fiscal'], '\u0024 $monto'),
                );
              }
            });
            final parteArre = json.encode(e['arrendamientos']);
            data1 = json.decode(parteArre);
            data1.forEach((i) {
              if (i != null) {
                String monto = numberFormat(i['monto_contratado'].toDouble());
                arrendamientos.add(
                  cardsLista(context, i['fecha_inicio'], i['fecha_fin'],
                      '\u0024 $monto'),
                );
              }
            });

            final parteObs = json.encode(e['observaciones']);
            data1 = json.decode(parteObs);
            data1.forEach((i) {
              if (i != null) {
                observaciones =
                    observaciones + '* ' + i['observacion'] + '\n\n';
              }
            });
          });
          _onRefresh();
          _onLoading();
          return jsonDecode(respuesta.body);
        } else {
          return null;
        }
      } else {
        EasyLoading.instance
          ..displayDuration = const Duration(milliseconds: 2000)
          ..indicatorType = EasyLoadingIndicatorType.fadingCircle
          ..loadingStyle = EasyLoadingStyle.dark
          ..indicatorSize = 45.0
          ..radius = 10.0
          ..progressColor = Colors.white
          ..backgroundColor = Colors.transparent
          ..boxShadow = [BoxShadow(color: Colors.transparent)]
          ..indicatorColor = Colors.blue[700]
          ..indicatorSize = 70
          ..textStyle = TextStyle(
              color: Colors.grey[500],
              fontSize: 20,
              fontWeight: FontWeight.bold)
          ..maskColor = Colors.black.withOpacity(0.88)
          ..userInteractions = false
          ..dismissOnTap = true;
        EasyLoading.dismiss();
        EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
        EasyLoading.showError(
          'Error de conexión',
          maskType: EasyLoadingMaskType.custom,
        );
      }
    } catch (e) {
      EasyLoading.instance
          ..displayDuration = const Duration(milliseconds: 2000)
          ..indicatorType = EasyLoadingIndicatorType.fadingCircle
          ..loadingStyle = EasyLoadingStyle.dark
          ..indicatorSize = 45.0
          ..radius = 10.0
          ..progressColor = Colors.white
          ..backgroundColor = Colors.transparent
          ..boxShadow = [BoxShadow(color: Colors.transparent)]
          ..indicatorColor = Colors.blue[700]
          ..indicatorSize = 70
          ..textStyle = TextStyle(
              color: Colors.grey[500],
              fontSize: 20,
              fontWeight: FontWeight.bold)
          ..maskColor = Colors.black.withOpacity(0.88)
          ..userInteractions = false
          ..dismissOnTap = true;
        EasyLoading.dismiss();
        EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
        EasyLoading.showError(
          'Error de conexión',
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
    await prefs.setString('token', token);
  }

  @override
  void initState() {
    super.initState();
    getDirectoryPath();
    dio = Dio();
  }

  requestWritePermission() async {
    if (await Permission.storage.request().isGranted) {
      setState(() {
        _allowWriteFile = true;
      });
    } else {
      // ignore: unused_local_variable
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
    }
  }

  Future<String> getDirectoryPath() async {
    final appDocDirectory = await getExternalStorageDirectory();

    Directory directory = await new Directory(
            (appDocDirectory?.path).toString() + Platform.pathSeparator + 'dir')
        .create(recursive: true);
    _localPath = directory.path;
    return directory.path;
  }

  Future downloadFile(String url, path) async {
    if (!_allowWriteFile) {
      requestWritePermission();
    }
    try {
      ProgressDialog progressDialog = ProgressDialog(
        context,
        dialogTransitionType: DialogTransitionType.Bubble,
        title: Text(
          'Descargando archivo',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        message: Text(
          'Iniciando descarga',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.black.withOpacity(0.88),
        dialogStyle: DialogStyle(
          titleDivider: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );

      progressDialog.show();
      final client = http.Client();
      final request = new http.Request('GET', Uri.parse(url))
        ..followRedirects = false;
      final response = await client.send(request);

      if (response.statusCode == 200) {
        await dio.download(url, path, onReceiveProgress: (rec, total) {
          setState(() {
            isLoading = true;
            progress = ((rec / total) * 100).toStringAsFixed(0) + "%";
            progressDialog.setMessage(
              Text(
                "Descargando $progress",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            );
          });
        });
        progressDialog.dismiss();
      } else {
        EasyLoading.instance
          ..displayDuration = const Duration(milliseconds: 2000)
          ..indicatorType = EasyLoadingIndicatorType.fadingCircle
          ..loadingStyle = EasyLoadingStyle.dark
          ..indicatorSize = 45.0
          ..radius = 10.0
          ..progressColor = Colors.white
          ..backgroundColor = Colors.transparent
          ..boxShadow = [BoxShadow(color: Colors.transparent)]
          ..indicatorColor = Colors.blue[700]
          ..indicatorSize = 70
          ..textStyle = TextStyle(
              color: Colors.grey[500],
              fontSize: 20,
              fontWeight: FontWeight.bold)
          ..maskColor = Colors.black.withOpacity(0.88)
          ..userInteractions = false
          ..dismissOnTap = true;
        EasyLoading.dismiss();
        EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
        EasyLoading.showError(
          'Error de conexión',
          maskType: EasyLoadingMaskType.custom,
        );
      }
    } catch (e) {
      //print(e.toString());
    }
  }

  Future delete(path) async {
    try {
      File(path).delete(recursive: true);
      setState(() {});
    } catch (e) {
      //print(e);
    }
  }

  Widget download(Course object) {
    String url = object.path;
    String title = object.title;
    String extension = url.substring(url.lastIndexOf("/"));
    File f = File(ruta + "$extension");
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "$title",
                style: TextStyle(
                    fontSize: 26,
                    color: Colors.purpleAccent,
                    fontWeight: FontWeight.bold),
              ),
              RawMaterialButton(
                onPressed: () {
                  if (f.existsSync()) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return PDFScreen(pathPDF: f.path, nombre: title);
                    }));
                    return;
                  }

                  downloadFile(url, "$ruta/$extension");
                },
                child: f.existsSync()
                    ? Icon(
                        Icons.remove_red_eye,
                        color: Colors.green,
                      )
                    : Icon(
                        Icons.file_download,
                        color: Colors.blue,
                      ),
              ),
              f.existsSync()
                  ? RawMaterialButton(
                      onPressed: () {
                        delete("$ruta/$extension");
                      },
                      child: Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                      ),
                    )
                  : new Container(
                      height: 0,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class PDFScreen extends StatelessWidget {
  String pathPDF = "";
  String nombre = "";
  PDFScreen({this.pathPDF, this.nombre});
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(9, 46, 116, 1.0),
          centerTitle: true,
          title: Text(nombre),
        ),
        body: Container(
          child: SfPdfViewer.file(
            File(pathPDF),
            key: _pdfViewerKey,
          ),
        ),
      ),
    );
  }
}

class Course {
  String title;
  String path;
  dynamic existe;
  Course({this.title, this.path, this.existe});
}
