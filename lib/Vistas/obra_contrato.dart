import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Vistas/anio.dart';
import 'package:flutter_app/Vistas/expediente_contrato.dart';
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
import 'dart:math';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:timelines/timelines.dart';

const completeColor = const Color.fromRGBO(9, 46, 116, 1.0);
const rechazedColor = Colors.red;
const inProgressColor = Colors.blue;
const todoColor = Color(0xffd1d2d7);

class ObrasContrato extends StatefulWidget with WidgetsBindingObserver {
  final TargetPlatform platform;
  @override
  _ObrasContrato createState() => _ObrasContrato();
  final int idObra;
  final int idCliente;
  final int anio;
  final int clave;
  final String nombre;
  final String nombreArchivo;
  final int archivos;
  final String path;
  ObrasContrato({
    Key key,
    this.idObra,
    this.idCliente,
    this.anio,
    this.platform,
    this.clave,
    this.nombre,
    this.nombreArchivo,
    this.archivos,
    this.path,
  }) : super(key: key);
}

class Vehicle {
  final String title;
  List<String> contents = [];
  List<int> icons;

  Vehicle(this.title, this.contents, this.icons);
}

class _ObrasContrato extends State<ObrasContrato> {
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
  int modalidad = 1;
  int idObra;
  List<Widget> listaObras = [];
  List<Widget> send = [];
  List<int> exp = [];
  List<String> fondo = [];
  List<Widget> facturas = [];
  List<Widget> estimacion = [];
  List<Widget> arrendamientos = [];
  List<Widget> licitacion = [];
  String observaciones = '';
  String contrato;
  int factAnticipo;
  int fAnt;
  int fCumplimiento;
  int fVicios;
  String tipoContrato;
  bool visibilityObj = false;
  bool visibilityAnticipo = false;
  int claveMunicipio;
  int obra;
  String nombreArchivo;
  String rfcContratista;
  String nombreContratista;
  String fechaActualizacion;

  Widget anticipoProceso;
  bool anticipoFin = false;
  Widget anticipoFechas;
  Widget finiquitoProceso;
  Widget finiquitoFechas;
  bool finiquitoFin = false;
  List<Widget> procesosEstimacion = [];
  List<Widget> fechasEstimacion = [];
  int archivos = 0;
  int estimacionIndex = 3;

  int _processIndex = 2;
  var _nombreProceso = [];

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
    final ObrasContrato args = ModalRoute.of(context).settings.arguments;
    idObra = args.idObra;
    idCliente = args.idCliente;
    anio = args.anio;
    claveMunicipio = args.clave;
    nombreCorto = args.nombre;
    nombreArchivo = args.nombreArchivo;
    archivos = args.archivos;
    _localPath = args.path;
    /*_getListado(context);*/
    if (inicio) {
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
    String nModa = 'Licitación pública';
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
    if (modalidad == 2) {
      nModa = 'Invitación a cuando menos tres contratistas';
    }
    if (modalidad == 3) {
      nModa = 'Adjudicación directa';
    }
    send.clear();

    send.add(
      SizedBox(
        height: 30,
      ),
    );

    send.add(
      visibilityObj
          ? new Container()
          : Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: Text(
                nombreCorto.toUpperCase(),
                style: TextStyle(
                  color: Color.fromRGBO(9, 46, 116, 1.0),
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                ),
                textAlign: TextAlign.center,
              ),
            ),
    );
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

    send.add(
      Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: RichText(
          text: new TextSpan(
            children: [
              new TextSpan(
                text: 'Modalidad de ejecución: ',
                style: new TextStyle(
                  color: Color.fromRGBO(9, 46, 116, 1.0),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              new TextSpan(
                text: 'Contrato',
                style: new TextStyle(
                  color: Color.fromRGBO(9, 46, 116, 1.0),
                  decorationThickness: 2,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    send.add(
      Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: RichText(
          text: new TextSpan(
            children: [
              new TextSpan(
                text: 'Modalidad de asignación: ',
                style: new TextStyle(
                  color: Color.fromRGBO(9, 46, 116, 1.0),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              new TextSpan(
                text: '$nModa',
                style: new TextStyle(
                  color: Color.fromRGBO(9, 46, 116, 1.0),
                  decorationThickness: 2,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    send.add(
      SizedBox(
        height: 20,
      ),
    );

    send.add(
      Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Text(
          'Datos del contratista',
          style: TextStyle(
            color: Color.fromRGBO(9, 46, 116, 1.0),
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
      ),
    );

    send.add(
      Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: RichText(
          text: new TextSpan(
            children: [
              new TextSpan(
                text: 'Razón Social: ',
                style: new TextStyle(
                  color: Color.fromRGBO(9, 46, 116, 1.0),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              new TextSpan(
                text: '$nombreContratista',
                style: new TextStyle(
                  color: Color.fromRGBO(9, 46, 116, 1.0),
                  decorationThickness: 2,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    send.add(
      Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: RichText(
          text: new TextSpan(
            children: [
              new TextSpan(
                text: 'RFC: ',
                style: new TextStyle(
                  color: Color.fromRGBO(9, 46, 116, 1.0),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              new TextSpan(
                text: '$rfcContratista',
                style: new TextStyle(
                  color: Color.fromRGBO(9, 46, 116, 1.0),
                  decorationThickness: 2,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    send.add(
      SizedBox(
        height: 10,
      ),
    );

    send.add(
      Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 20),
        child: Text(
          'Número de contrato: $contrato',
          style: TextStyle(
            color: Color.fromRGBO(9, 46, 116, 1.0),
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
      ),
    );

    send.add(
      Container(
        margin: EdgeInsets.only(
          left: 15,
          right: 15,
        ),
        child: Text(
          '$tipoContrato',
          style: TextStyle(
            color: Color.fromRGBO(9, 46, 116, 1.0),
            fontWeight: FontWeight.w400,
            fontSize: 17,
          ),
        ),
      ),
    );

    send.add(
      SizedBox(
        height: 10,
      ),
    );
    send.add(
      Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 20),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                'Inversión',
                style: TextStyle(
                  color: Color.fromRGBO(9, 46, 116, 1.0),
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                ),
              ),
            ),
            Expanded(
              //columna fecha
              flex: 5,
              child: Text(
                '\u0024 $monto',
                style: TextStyle(
                  color: Color.fromRGBO(9, 46, 116, 1.0),
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
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
                        fontWeight: FontWeight.w400,
                        fontSize: 17,
                      ))),
              Expanded(
                //columna fecha
                flex: 5,
                child: Text(
                  '\u0024 $montoT',
                  style: TextStyle(
                    color: Color.fromRGBO(9, 46, 116, 1.0),
                    fontWeight: FontWeight.w400,
                    fontSize: 17,
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

    send.add(
      SizedBox(
        height: 30,
      ),
    );

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
    send.add(
      SizedBox(
        height: 10,
      ),
    );
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
    send.add(
      SizedBox(
        height: 30,
      ),
    );

    if (anticipoProceso != null) {
      
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
              'Proceso de Anticipo',
              style: TextStyle(
                color: Color.fromRGBO(9, 46, 116, 1.0),
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ),
            ),
            showAccordion: true,
            expandedTitleBackgroundColor: Colors.transparent,
            collapsedTitleBackgroundColor: Colors.transparent,
            contentBackgroundColor: Colors.transparent,
            contentChild: Container(
              child: Column(children: [
                anticipoProceso,
                SizedBox(
                  height: 10,
                ),
                anticipoFechas,
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

    if (procesosEstimacion.length > 0) {
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
              'Proceso Estimaciones',
              style: TextStyle(
                color: Color.fromRGBO(9, 46, 116, 1.0),
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ),
            ),
            expandedTitleBackgroundColor: Colors.transparent,
            collapsedTitleBackgroundColor: Colors.transparent,
            contentBackgroundColor: Colors.transparent,
            contentChild: Container(
              child: Column(
                children: procesosEstimacion,
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

    if (finiquitoProceso != null) {
      
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
              'Proceso de Finiquito',
              style: TextStyle(
                color: Color.fromRGBO(9, 46, 116, 1.0),
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ),
            ),
            expandedTitleBackgroundColor: Colors.transparent,
            collapsedTitleBackgroundColor: Colors.transparent,
            contentBackgroundColor: Colors.transparent,
            contentChild: Container(
              child: Column(children: [
                finiquitoProceso,
                SizedBox(
                  height: 10,
                ),
                finiquitoFechas,
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

    send.add(
      SizedBox(
        height: 30,
      ),
    );
    send.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: SizedBox(
              height: 50,
              width: 160,
              child: ElevatedButton(
                child: Center(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Icon(
                            CupertinoIcons.folder_badge_plus,
                            color: Color.fromRGBO(9, 46, 116, 1.0),
                            size: 20.0,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            "Expediente",
                            style: TextStyle(
                              color: Color.fromRGBO(9, 46, 116, 1.0),
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/expediente',
                    arguments: ExpedienteContrato(
                      idObra: idObra,
                      idCliente: idCliente,
                      anio: anio,
                      clave: claveMunicipio,
                      nombre: nombreCorto,
                      nombreArchivo: nombreArchivo,
                      path: _localPath,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    //borde del boton
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(
                      color: Color.fromRGBO(9, 46, 116, 1.0),
                    ),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
    setState(
      () {
        visibilityObj = !visibility;
      },
    );
  }

  Widget fechas(revision, obs, solventacion, validacion, pago, separacion) {
    return Container(
      child: GFAccordion(
        margin: EdgeInsets.only(left: 10, right: 10),
        expandedTitleBackgroundColor: Colors.transparent,
        collapsedTitleBackgroundColor: Colors.transparent,
        contentBackgroundColor: Color.fromRGBO(204, 204, 204, 0.3),
        contentChild: Container(
          margin: EdgeInsets.only(
            left: 15,
            right: 15,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Recepción',
                      style: TextStyle(
                        color: Color.fromRGBO(9, 46, 116, 1.0),
                        fontWeight: FontWeight.w300,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      revision,
                      style: TextStyle(
                        color: Color.fromRGBO(9, 46, 116, 1.0),
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Observaciones',
                      style: TextStyle(
                        color: Color.fromRGBO(9, 46, 116, 1.0),
                        fontWeight: FontWeight.w300,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      obs,
                      style: TextStyle(
                        color: Color.fromRGBO(9, 46, 116, 1.0),
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Solventación',
                      style: TextStyle(
                        color: Color.fromRGBO(9, 46, 116, 1.0),
                        fontWeight: FontWeight.w300,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      solventacion,
                      style: TextStyle(
                        color: Color.fromRGBO(9, 46, 116, 1.0),
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Validación',
                      style: TextStyle(
                        color: Color.fromRGBO(9, 46, 116, 1.0),
                        fontWeight: FontWeight.w300,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      validacion,
                      style: TextStyle(
                        color: Color.fromRGBO(9, 46, 116, 1.0),
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Pago',
                      style: TextStyle(
                        color: Color.fromRGBO(9, 46, 116, 1.0),
                        fontWeight: FontWeight.w300,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      pago,
                      style: TextStyle(
                        color: Color.fromRGBO(9, 46, 116, 1.0),
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        collapsedIcon: Container(
          width: MediaQuery.of(context).size.width - separacion,
          child: Text(
            'Ver fechas',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w400,
              fontSize: 17,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        expandedIcon: Container(
          width: MediaQuery.of(context).size.width - separacion,
          child: Text(
            'Ocultar fechas',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w400,
              fontSize: 17,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget estimacionProceso(
      proceso, fechas, nombre, nombreArchivo, idEstimacion) {
    
    return Container(
      child: GFAccordion(
        titleBorder: Border.all(
          width: 1.0,
          color: Color.fromRGBO(9, 46, 116, 1.0),
        ),
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        titlePadding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        titleChild: Text(
          '$nombre',
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
              proceso,
              SizedBox(
                height: 10,
              ),
              fechas,
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
    );
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
                          child: Text(nombre,
                              style: TextStyle(
                                color: Color.fromRGBO(9, 46, 116, 1.0),
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                              )))),
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
                    child: Text(folio,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 15,
                        )))),
            Expanded(
                flex: 1,
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(monto,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 15,
                        )))),
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
                    child: Text(fechaInicio,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 15,
                        )))),
            Expanded(
                flex: 3,
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(fechaFin,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 15,
                        )))),
            Expanded(
                flex: 3,
                child: Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10, left: 30),
                    child: Text(monto,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 15,
                        )))),
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
                    child: Text(
                      nombre,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  //columna fecha
                  flex: 2,
                  child: Text(
                    "\u0024 $monto",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 15,
                    ),
                  ),
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

  Widget lineaTiempo(_processes, _estado, nombreProceso, separacion, ancho) {
    return Column(
      children: [
        Container(
          height: ancho,
          child: Timeline.tileBuilder(
            theme: TimelineThemeData(
              direction: Axis.horizontal,
              connectorTheme: ConnectorThemeData(
                space: 10.0,
                thickness: 5.0,
              ),
            ),
            builder: TimelineTileBuilder.connected(
              connectionDirection: ConnectionDirection.before,
              itemExtentBuilder: (_, __) =>
                  (MediaQuery.of(context).size.width - separacion) /
                  _processes.length,
              contentsBuilder: (context, index) {
                Widget padding;
                if (_estado[index] != 3) {
                  padding = Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Text(
                      _processes[index],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: getColor(index, _estado),
                      ),
                    ),
                  );
                } else {
                  padding = Padding(
                    padding: const EdgeInsets.only(top: 23.0),
                    child: Text(
                      _processes[index],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: getColor(index, _estado),
                      ),
                    ),
                  );
                }
                return padding;
              },
              indicatorBuilder: (_, index) {
                var color;
                var child;
                int estado = _estado[index];
                if (estado == 0) {
                  color = inProgressColor;
                  child = Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 3.0,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  );
                } else if (estado == 1) {
                  color = completeColor;
                  child = Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 15.0,
                  );
                } else if (estado == 2) {
                  color = rechazedColor;
                  child = Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 15.0,
                  );
                } else {
                  color = todoColor;
                }

                if (estado == 1 || estado == 2 || estado == 0) {
                  return Stack(
                    children: [
                      CustomPaint(
                        size: Size(30.0, 30.0),
                        painter: _BezierPainter(
                          color: color,
                          drawStart: index > 0,
                          drawEnd: index < _processIndex,
                        ),
                      ),
                      DotIndicator(
                        size: 30.0,
                        color: color,
                        child: child,
                      ),
                    ],
                  );
                } else {
                  return Stack(
                    children: [
                      CustomPaint(
                        size: Size(15.0, 15.0),
                        painter: _BezierPainter(
                          color: color,
                          drawEnd: index < _processes.length - 1,
                        ),
                      ),
                      OutlinedDotIndicator(
                        borderWidth: 4.0,
                        color: color,
                      ),
                    ],
                  );
                }
              },
              connectorBuilder: (_, index, type) {
                int estado = _estado[index];
                if (index > 0) {
                  if (estado == 1 || estado == 2 || estado == 0) {
                    final prevColor = getColor(index - 1, _estado);
                    final color = getColor(index, _estado);
                    List<Color> gradientColors;
                    if (type == ConnectorType.start) {
                      gradientColors = [
                        Color.lerp(prevColor, color, 0.5),
                        color
                      ];
                    } else {
                      gradientColors = [
                        prevColor,
                        Color.lerp(prevColor, color, 0.5)
                      ];
                    }
                    return DecoratedLineConnector(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: gradientColors,
                        ),
                      ),
                    );
                  } else {
                    return SolidLineConnector(
                      color: getColor(index, _estado),
                    );
                  }
                } else {
                  return null;
                }
              },
              itemCount: _processes.length,
            ),
          ),
        ),
      ],
    );
  }

  Color getColor(int index, _estado) {
    int estado = _estado[index];
    if (estado == 0) {
      return inProgressColor;
    } else if (estado == 1) {
      return completeColor;
    } else if (estado == 2) {
      return rechazedColor;
    } else {
      return todoColor;
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

  Future<dynamic> _getListado(BuildContext context) async {
    send.clear();
    listaObras.clear();
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.cubeGrid
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

          data.forEach((e) {
            final parteSocial = json.encode(e['parte_social']);
            dynamic data1 = json.decode(parteSocial);

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
                avanceTecnico =
                    int.parse(i['avance_tecnico'].toStringAsFixed(0))
                        .toDouble();
                fechaActualizacion = i['fecha_actualizacion'];
              }
            });
            final parteAdmin = json.encode(e['obra_exp']);
            data1 = json.decode(parteAdmin);
            data1.forEach((i) {
              if (i != null) {
                contrato = i['contrato'];
                if (i['contrato_tipo'] == 1) {
                  tipoContrato = 'Precios unitarios';
                } else {
                  tipoContrato = 'Precios alzados';
                }
                modalidad = i['modalidad_asignacion'];
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
            final contratista = json.encode(e['contratista']);
            data1 = json.decode(contratista);
            data1.forEach((i) {
              if (i != null) {
                rfcContratista = i['rfc'];
                nombreContratista = i['razon_social'];
              }
            });

            final desglose = json.encode(e['desglose']);
            data1 = json.decode(desglose);
            data1.forEach((i) {
              if (i != null) {
                var _processes = [
                  'Recepción',
                  'Observaciones',
                  'Solventación',
                  'Validación',
                  'Pagado',
                ];
                var _estado = [];
                _nombreProceso.add(i['nombre']);
                String nombreProceso = i['nombre'];
                int estadoRecepcion = 3;
                int estadoValidacion = 3;
                String fechaRecepcion = "--";
                String fechaValidacion = "--";
                String fechaPago = "--";
                int estadoPago = 3;
                int estadoSolventacion = 3;
                int estadoObservaciones = 3;
                bool nombreArchivo;
                String fechasSolven = "";
                String fechasObse = "";
                final desgloseObs = json.encode(e['desglose_obs']);
                final data2 = json.decode(desgloseObs);
                data2.forEach((x) {
                  if (x['nombre'] == nombreProceso) {
                    if (x['fecha_observaciones'] != null)
                      fechasObse = x['fecha_observaciones'];
                    else
                      fechasObse = "--";
                    if (x['fecha_solventacion'] != null)
                      fechasSolven = x['fecha_solventacion'];
                    else
                      fechasSolven = '--';
                    estadoSolventacion = x['estado_solventacion'];
                    estadoObservaciones = x['estado_observaciones'];
                  }
                });
                if (i["fecha_recepcion"] != null) {
                  estadoRecepcion = 1;
                  fechaRecepcion = i['fecha_recepcion'];
                }
                nombreArchivo = i['archivo_nombre'] != null;

                if (i["fecha_validacion"] != null) {
                  estadoValidacion = 1;
                  estadoPago = 0;
                  fechaValidacion = i['fecha_validacion'];
                } else if (estadoSolventacion == 1) estadoValidacion = 0;
                if (i["fecha_pago"] != null) {
                  fechaPago = i['fecha_pago'];
                  estadoPago = 1;
                }

                if (estadoValidacion == 1) {
                  estadoObservaciones = 1;
                  estadoSolventacion = 1;
                }

                _estado.add(estadoRecepcion);
                _estado.add(estadoObservaciones);
                _estado.add(estadoSolventacion);
                _estado.add(estadoValidacion);
                _estado.add(estadoPago);

                /*for (int z = 0; z < _fechasObs.length; z++) {
                  if (z < _fechasObs.length - 1) {
                    fechasObse = fechasObse + _fechasObs[z] + '\n';
                  } else
                    fechasObse = fechasObse + _fechasObs[z];
                }*/

                /*for (int z = 0; z < _fechasSolv.length; z++) {
                  if (z < _fechasSolv.length - 1)
                    fechasSolven = fechasSolven + _fechasSolv[z] + '\n';
                  else
                    fechasSolven = fechasSolven + _fechasSolv[z];
                }*/

                if (nombreProceso.toLowerCase() == "anticipo") {
                  anticipoProceso = lineaTiempo(
                      _processes, _estado, nombreProceso, 20, 100.0);
                  anticipoFechas = fechas(fechaRecepcion, fechasObse,
                      fechasSolven, fechaValidacion, fechaPago, 80);

                  anticipoFin = nombreArchivo;
                }
                if (nombreProceso.toLowerCase().contains("estimación") &&
                    !nombreProceso.toLowerCase().contains("finiquito")) {
                  String numero = nombreProceso
                      .substring(nombreProceso.lastIndexOf(" ") + 1);
                  procesosEstimacion.add(
                    estimacionProceso(
                        lineaTiempo(
                            _processes, _estado, nombreProceso, 80, 90.0),
                        fechas(fechaRecepcion, fechasObse, fechasSolven,
                            fechaValidacion, fechaPago, 120),
                        nombreProceso,
                        nombreArchivo,
                        numero),
                  );
                  if (nombreArchivo) estimacionIndex++;
                }
                if (nombreProceso.toLowerCase().contains("finiquito")) {
                  finiquitoProceso = lineaTiempo(
                      _processes, _estado, nombreProceso, 20, 100.0);
                  finiquitoFechas = fechas(fechaRecepcion, fechasObse,
                      fechasSolven, fechaValidacion, fechaPago, 80);
                  finiquitoFin = nombreArchivo;
                }
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
      }
      else{
        progressDialog.dismiss();
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
          ..textStyle = TextStyle(color: Colors.grey[500], fontSize: 20, fontWeight: FontWeight.bold )
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

class _BezierPainter extends CustomPainter {
  const _BezierPainter({
    this.color,
    this.drawStart = true,
    this.drawEnd = true,
  });

  final Color color;
  final bool drawStart;
  final bool drawEnd;

  Offset _offset(double radius, double angle) {
    return Offset(
      radius * cos(angle) + radius,
      radius * sin(angle) + radius,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    final radius = size.width / 2;

    var angle;
    var offset1;
    var offset2;

    var path;

    if (drawStart) {
      angle = 3 * pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);
      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(0.0, size.height / 2, -radius, radius)
        ..quadraticBezierTo(0.0, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
    if (drawEnd) {
      angle = -pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);

      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(
            size.width, size.height / 2, size.width + radius, radius)
        ..quadraticBezierTo(size.width, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_BezierPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.drawStart != drawStart ||
        oldDelegate.drawEnd != drawEnd;
  }
}
