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

class Plataformas extends StatefulWidget with WidgetsBindingObserver {
  final TargetPlatform platform;
  @override
  _PlataformasView createState() => _PlataformasView();
  final int cliente;
  final int anio;
  final int clave;
  final bool prodimb;
  final bool gib;
  final List<int> idObrasList;
  final List<String> nombreObrasList;
  final String path;
  Plataformas({
    Key key,
    this.cliente,
    this.platform,
    this.anio,
    this.clave,
    this.gib,
    this.prodimb,
    this.idObrasList,
    this.nombreObrasList,
    this.path,
  }) : super(key: key);
}

class _PlataformasView extends State<Plataformas> {
  String fechaIntegracion = '';
  String fechaPriorizacion = '';
  String fechaAdendum = '';
  String url;
  bool inicio = false;
  int idCliente;
  int anio;
  List<Widget> listaObras = [];
  List<Widget> send = [];
  int firmaElectronica;
  int convenio;
  int validado;
  int revisado;
  bool prodim;
  bool gi;
  int claveMunicipio;
  List<Widget> gastos = [];
  List<Widget> mids = [];
  List<Widget> sisplade = [];
  List<Widget> rft = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<int> listIdObras = [];
  List<String> listNombreObras = [];

  //DOWNLOAD ARCHIVOS
  
  var listObras = [];

  //Variables descargar archivos
  bool isLoading;
  bool _allowWriteFile = false;
  String ruta;

  String progress = "";
  Dio dio;
  String _localPath;

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
    idCliente = args.cliente;
    anio = args.anio;
    prodim = args.prodimb;
    gi = args.gib;
    claveMunicipio = args.clave;
    listIdObras = args.idObrasList;
    listNombreObras = args.nombreObrasList;
    _localPath = args.path;
    if (listObras.isNotEmpty && inicio) {
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
    send.add(SizedBox(
      height: 20,
    ));

    send.add(
      Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
          child: Text(
            "SISPLADE",
            style: TextStyle(
              color: Color.fromRGBO(9, 46, 116, 1.0),
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
    send.add(
      Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
          child: Text(
            "Sistema de Información para la Planeación del Desarrollo de Oaxaca",
            style: TextStyle(
              color: Color.fromRGBO(9, 46, 116, 1.0),
              fontWeight: FontWeight.w400,
              fontSize: 17,
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
    send.add(
      SizedBox(
        height: 30,
      ),
    );
    send.add(
      Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
          child: Text(
            "MIDS / RFT",
            style: TextStyle(
              color: Color.fromRGBO(9, 46, 116, 1.0),
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );

    send.add(
      Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
          child: Text(
            "Matriz de Inversión para el Desarrollo Social / Informe de Recursos Federales Transferidos",
            style: TextStyle(
              color: Color.fromRGBO(9, 46, 116, 1.0),
              fontWeight: FontWeight.w300,
              fontSize: 17,
            ),
            textAlign: TextAlign.center,
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
      GFAccordion(
        titleBorder: Border.all(
          width: 1.0,
          color: Color.fromRGBO(9, 46, 116, 1.0),
        ),
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        titlePadding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
        titleChild: Text(
          'Obras Públicas',
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
              SizedBox(
                height: 10,
              ),
              Card(
                // RoundedRectangleBorder para proporcionarle esquinas circulares al Card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                // margen para el Card
                margin: EdgeInsets.only(
                  left: 10,
                  right: 30,
                  bottom: 0,
                ),
                // La sombra que tiene el Card aumentará
                elevation: 0,
                //Colocamos una fila en dentro del card
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: EdgeInsets.all(0.0),
                            child: Text(
                              "Obra",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color.fromRGBO(9, 46, 116, 1.0),
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            "MIDS",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color.fromRGBO(9, 46, 116, 1.0),
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          //columna fecha
                          flex: 3,
                          child: Text(
                            "RFT",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color.fromRGBO(9, 46, 116, 1.0),
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                  children: listObras
                      .map<Widget>(
                        (i) =>
                            //Mostar items
                            Column(
                          children: [
                            /*Text((category['nombre_obra'] != null)
                                ? category['nombre_obra']
                                : ''),*/
                            cardsListado(
                                context,
                                i['nombre'],
                                i['primero'],
                                i['segundo'],
                                i['tercero'],
                                i['cuarto'],
                                i['planeado'],
                                i['fecha_planeado'],
                                i['validado'],
                                i['fecha_validado'],
                                i['firmado'],
                                i['fecha_firmado'],
                                i['id_obra'],
                                i['index']),
                          ],
                        ),
                      )
                      .toList()),
              Column(
                children: rft,
              ),
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

    if (gi) {
      send.add(
        GFAccordion(
          titleBorder: Border.all(
            width: 1.0,
            color: Color.fromRGBO(9, 46, 116, 1.0),
          ),
          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
          titlePadding:
              EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          titleChild: Text(
            'Gastos Indirectos',
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
              children: gastos,
            ),
          ),
          collapsedIcon: Icon(
            Icons.arrow_drop_down_outlined,
            color: Colors.white,
          ),
          expandedIcon: Icon(
            Icons.arrow_drop_up,
            color: Colors.white,
          ),
        ),
      );
    }

    if (prodim) {
      Course objectProdim = Course(
        title: "ACUSE PRODIM",
        path:
            'http://sistema.mrcorporativo.com/archivos/$claveMunicipio/$anio/acta_adendum.pdf');
      String urlProdim = objectProdim.path;
      String titleProdim = objectProdim.title;
      String extensionProdim = urlProdim.substring(urlProdim.lastIndexOf("/"));
      File fProdim = File(_localPath + "$extensionProdim");
      send.add(
        GFAccordion(
          titleBorder: Border.all(
            width: 1.0,
            color: Color.fromRGBO(9, 46, 116, 1.0),
          ),
          margin: EdgeInsets.only(top: 10, left: 10, right: 10),
          titlePadding:
              EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          titleChild: Text(
            'PRODIM',
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
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, bottom: 8.0),
                    child: Text(
                      "Programa de Desarrollo Institucional Municipal y de las demarcaciones territoriales del Distrito Federal",
                      style: TextStyle(
                        color: Color.fromRGBO(9, 46, 116, 1.0),
                        fontWeight: FontWeight.w300,
                        fontSize: 17,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: RawMaterialButton(
                          onPressed: () {
                            if (fProdim.existsSync()) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return PDFScreen(
                                  pathPDF: fProdim.path,
                                  nombre: titleProdim,
                                );
                              }));
                              return;
                            }
                            downloadFile(urlProdim, "$_localPath/$extensionProdim");
                          },
                          child: fProdim.existsSync()
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
                                  'Descargar acuse',
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
                        flex: fProdim.existsSync() ? 2 : 0,
                        child: fProdim.existsSync()
                            ? RawMaterialButton(
                                onPressed: () {
                                  delete("$_localPath/$extensionProdim");
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
                Container(
                  child: GFAccordion(
                    titleBorder: Border.all(
                      width: 1.0,
                      color: Color.fromRGBO(9, 46, 116, 1.0),
                    ),
                    margin: EdgeInsets.only(
                        top: 10, left: 10, right: 10, bottom: 8),
                    titlePadding:
                        EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
                    titleChild: cardsComprometidoProdim(
                        context, 'Comprometido', firmaElectronica),
                    expandedTitleBackgroundColor: Colors.transparent,
                    collapsedTitleBackgroundColor: Colors.transparent,
                    contentBackgroundColor: Color.fromRGBO(204, 204, 204, 0.3),
                    titleBorderRadius: BorderRadius.circular(6),
                    contentChild: Container(
                      child: Column(
                        children: listaObras,
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
                cardProdim(context, 'Presentado', firmaElectronica),
                cardProdim(context, 'Revisado', revisado),
                cardProdim(context, 'Aprobado', validado),
                cardProdim(context, 'Firma de convenio', convenio),
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
    send.add(SizedBox(
      height: 20,
    ));

    /*send.add(
      Container(
        child: Column(
          children: rft,
        ),
      ),
    );*/
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
          CupertinoIcons.device_laptop,
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

  Widget cardProdim(BuildContext context, nombre, estado) {
    IconData estadoIcon;
    Color color;
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
                  nombre,
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
  }

  Widget cardsListado(
      BuildContext context,
      nombre,
      primero,
      segundo,
      tercero,
      cuarto,
      planeado,
      fechaPlaneado,
      validado,
      fechaValidado,
      firmado,
      fechaFirmado,
      idObra,
      index) {
    String estadoMid;
    String estadoRft;
    if (planeado == 0) estadoMid = "Sin información";
    if (planeado == 1 || validado == 1) estadoMid = "En proceso";
    if (firmado == 1) estadoMid = "Presentado";
    if (primero == 0) estadoRft = "Sin información";
    if (primero > 0) estadoRft = "En proceso";
    if (primero == 100) estadoRft = "Presentado";
    if (segundo > 0) estadoRft = "En proceso";
    if (segundo == 100) estadoRft = "Presentadoo";
    if (tercero > 0) estadoRft = "En proceso";
    if (tercero == 100) estadoRft = "Presentadoo";
    if (cuarto > 0) estadoRft = "En proceso";
    if (cuarto == 100) estadoRft = "Presentado";
    
    bool midFinal = false;
    bool rftFinal = false;
    if (estadoMid == "Presentado") midFinal = true;
    if (estadoRft == "Presentado") rftFinal = true;

    Course objectMids = Course(
        title: "ACUSE MIDS",
        path:
            'http://sistema.mrcorporativo.com/archivos/$claveMunicipio/$anio/obras/$idObra/mids-$idObra.pdf');
      String urlMids = objectMids.path;
      String titleMids = objectMids.title;
      String extensionMids = urlMids.substring(urlMids.lastIndexOf("/"));
      File fMids = File(_localPath + "$extensionMids");

    Course objectRft = Course(
        title: "ACUSE MIDS",
        path:
            'http://sistema.mrcorporativo.com/archivos/$claveMunicipio/$anio/obras/$idObra/rft-$idObra.pdf');
      String urlRft = objectRft.path;
      String titleRft = objectRft.title;
      String extensionRft = urlRft.substring(urlRft.lastIndexOf("/"));
      File fRft = File(_localPath + "$extensionRft");

    return Container(
      child: GFAccordion(
        titleBorder: Border.all(
          width: 1.0,
          color: Color.fromRGBO(9, 46, 116, 1.0),
        ),
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        titlePadding: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
        titleChild: cardsComprometido(context, nombre, estadoMid, estadoRft),
        expandedTitleBackgroundColor: Colors.transparent,
        collapsedTitleBackgroundColor: Colors.transparent,
        contentBackgroundColor: Color.fromRGBO(204, 204, 204, 0.3),
        contentChild: Container(
          child: Column(children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 5.0, bottom: 5.0),
                child: Text(
                  "MIDS - Matriz de Inversión para el Desarrollo Social",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color.fromRGBO(9, 46, 116, 1.0),
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            midFinal
                ?Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: RawMaterialButton(
                          onPressed: () {
                            if (fMids.existsSync()) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return PDFScreen(
                                  pathPDF: fMids.path,
                                  nombre: titleMids,
                                );
                              }));
                              return;
                            }
                            downloadFile(urlMids, "$_localPath/$extensionMids");
                          },
                          child: fMids.existsSync()
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
                                  'Descargar acuse',
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
                        flex: fMids.existsSync() ? 2 : 0,
                        child: fMids.existsSync()
                            ? RawMaterialButton(
                                onPressed: () {
                                  delete("$_localPath/$extensionMids");
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
                  )
                : new Container(),
            cards(context, "Planeado", fechaPlaneado, planeado, 50.0),
            cards(context, "Validado", fechaValidado, validado, 50.0),
            cards(context, "Firmado", fechaFirmado, firmado, 50.0),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 5.0, bottom: 5.0),
                child: Text(
                  "RFT -Informe de Recursos Federales Transferidos",
                  style: TextStyle(
                    color: const Color.fromRGBO(9, 46, 116, 1.0),
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            rftFinal
                ? Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: RawMaterialButton(
                          onPressed: () {
                            if (fRft.existsSync()) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return PDFScreen(
                                  pathPDF: fRft.path,
                                  nombre: titleRft,
                                );
                              }));
                              return;
                            }
                            downloadFile(urlRft, "$_localPath/$extensionRft");
                          },
                          child: fRft.existsSync()
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
                                  'Descargar acuse',
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
                        flex: fRft.existsSync() ? 2 : 0,
                        child: fRft.existsSync()
                            ? RawMaterialButton(
                                onPressed: () {
                                  delete("$_localPath/$extensionRft");
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
                )
                : new Container(),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 5.0, bottom: 5.0),
                child: Text(
                  "Trimestre",
                  style: TextStyle(
                    color: const Color.fromRGBO(9, 46, 116, 1.0),
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            cardsRft(context, primero, segundo, tercero, cuarto),
          ]),
        ),
        collapsedIcon: Icon(
          Icons.arrow_drop_down_outlined,
          color: const Color.fromRGBO(9, 46, 116, 1.0),
        ),
        expandedIcon: Icon(
          Icons.arrow_drop_up,
          color: const Color.fromRGBO(9, 46, 116, 1.0),
        ),
      ),
    );
  }

  Widget cardsListadoProdim(BuildContext context, nombre, monto) {
    return Container(
      height: 60,
      child: InkWell(
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
                    style: TextStyle(
                      color: Color.fromRGBO(9, 46, 116, 1.0),
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Expanded(
                //columna fecha
                flex: 1,
                child: Text(
                  "\u0024 $monto",
                  style: TextStyle(
                    color: Color.fromRGBO(9, 46, 116, 1.0),
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cardsDesglose(BuildContext context, nombre, monto) {
    return Container(
      height: 65,
      child: Card(
        // RoundedRectangleBorder para proporcionarle esquinas circulares al Card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(
            color: Color.fromRGBO(9, 46, 116, 0.5),
          ),
        ),
        // margen para el Card
        margin: EdgeInsets.only(
          left: 30,
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
              flex: 1,
              child: Text("\u0024 $monto",
                  style: TextStyle(
                    color: Color.fromRGBO(9, 46, 116, 1.0),
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  dynamic ex(bool f) {
    return true;
  }

  Widget cardsComprometido(
      BuildContext context, nombre, estadoMids, estadoRft) {
    return Container(
      height: 65,
      child: Card(
        // RoundedRectangleBorder para proporcionarle esquinas circulares al Card
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        // margen para el Card
        margin: EdgeInsets.only(
          left: 0,
          right: 0,
          bottom: 0,
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
                  style: TextStyle(
                    color: const Color.fromRGBO(9, 46, 116, 1.0),
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
                  estadoMids,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color.fromRGBO(9, 46, 116, 1.0),
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  estadoRft,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color.fromRGBO(9, 46, 116, 1.0),
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardsComprometidoProdim(BuildContext context, nombre, estado) {
    IconData estadoIcon;
    Color color;
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
    return Container(
      height: 55,
      child: Card(
        // RoundedRectangleBorder para proporcionarle esquinas circulares al Card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        // margen para el Card
        margin: EdgeInsets.only(
          left: 0,
          right: 0,
          bottom: 0,
        ),
        // La sombra que tiene el Card aumentará
        elevation: 0,
        //Colocamos una fila en dentro del card
        color: Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  nombre,
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
  }

  Widget cards(BuildContext context, nombre, fecha, estado, tamanio) {
    IconData estadoIcon;
    Color color;

    int estado_1 = estado.toInt();

    if (estado_1 == 1) {
      estadoIcon = Icons.check_circle_rounded;
      color = Colors.blue;
    }
    if (estado_1 == 2) {
      estadoIcon = Icons.cancel /*check_circle_rounded*/;
      color = Colors.red;
    }

    if (estado_1 == 3) {
      estadoIcon = Icons.remove_circle;
      color = Colors.yellow;
    }

    return Container(
      height: tamanio,
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
              child: Text(
                fecha,
                style: TextStyle(
                  color: Color.fromRGBO(9, 46, 116, 1.0),
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
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
  }

  Widget cardsRft(BuildContext context, primero, segundo, tercero, cuarto) {
    return Container(
      height: 100,
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
        elevation: 0,
        //Colocamos una fila en dentro del card
        color: Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 1,
              child: CircularPercentIndicator(
                radius: 50.0,
                animation: true,
                animationDuration: 1000,
                percent: primero * 0.01,
                circularStrokeCap: CircularStrokeCap.round,
                center: Text(
                  "$primero%",
                  style: TextStyle(
                    color: Color.fromRGBO(9, 46, 116, 1.0),
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
                progressColor: Colors.blue,
                backgroundColor: Colors.grey[350],
                lineWidth: 6,
                footer: Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  height: 15,
                  child: Center(
                    child: Text(
                      "1ro",
                      style: new TextStyle(
                          color: Color.fromRGBO(9, 46, 116, 1.0),
                          fontWeight: FontWeight.w400,
                          fontSize: 15.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: CircularPercentIndicator(
                radius: 50.0,
                animation: true,
                animationDuration: 1000,
                percent: segundo * 0.01,
                circularStrokeCap: CircularStrokeCap.round,
                center: Text(
                  "$segundo%",
                  style: TextStyle(
                    color: Color.fromRGBO(9, 46, 116, 1.0),
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
                progressColor: Colors.blue,
                backgroundColor: Colors.grey[350],
                lineWidth: 6,
                footer: Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  height: 15,
                  child: Center(
                    child: Text(
                      "2do",
                      style: new TextStyle(
                          color: Color.fromRGBO(9, 46, 116, 1.0),
                          fontWeight: FontWeight.w400,
                          fontSize: 15.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: CircularPercentIndicator(
                radius: 50.0,
                animation: true,
                animationDuration: 1000,
                percent: tercero * 0.01,
                circularStrokeCap: CircularStrokeCap.round,
                center: Text(
                  "$tercero%",
                  style: TextStyle(
                    color: Color.fromRGBO(9, 46, 116, 1.0),
                    fontWeight: FontWeight.w400,
                    fontSize: 17,
                  ),
                ),
                progressColor: Colors.blue,
                backgroundColor: Colors.grey[350],
                lineWidth: 6,
                footer: Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  height: 15,
                  child: Center(
                    child: Text(
                      "3ro",
                      style: new TextStyle(
                          color: Color.fromRGBO(9, 46, 116, 1.0),
                          fontWeight: FontWeight.w400,
                          fontSize: 15.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: CircularPercentIndicator(
                radius: 50.0,
                animation: true,
                animationDuration: 1000,
                percent: cuarto * 0.01,
                circularStrokeCap: CircularStrokeCap.round,
                center: Text(
                  "$cuarto%",
                  style: TextStyle(
                    color: Color.fromRGBO(9, 46, 116, 1.0),
                    fontWeight: FontWeight.w400,
                    fontSize: 17,
                  ),
                ),
                progressColor: Colors.blue,
                backgroundColor: Colors.grey[350],
                lineWidth: 6,
                footer: Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  height: 15,
                  child: Center(
                    child: Text(
                      "4to",
                      style: new TextStyle(
                          color: Color.fromRGBO(9, 46, 116, 1.0),
                          fontWeight: FontWeight.w400,
                          fontSize: 15.0),
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
    url = "http://sistema.mrcorporativo.com/api/getRFT/$idCliente,$anio";
    try {
      final respuesta = await http.get(Uri.parse(url));
      if (respuesta.statusCode == 200) {
        if (respuesta.body != "") {
          final data = json.decode(respuesta.body);
          data.forEach(
            (e) {
              final sisplade_1 = json.encode(e['sisplade']);
              dynamic sisplade_2 = json.decode(sisplade_1);

              sisplade_2.forEach((i) {
                sisplade.add(
                  cards(context, 'Capturado', i['fecha_capturado'],
                      i['capturado'], 65.0),
                );
                sisplade.add(
                  cards(context, 'Validado', i['fecha_validado'], i['validado'],
                      65.0),
                );
              });

              final comprometido = json.encode(e['rft']);
              dynamic comprometido_1 = json.decode(comprometido);

              int cont = 1;

              comprometido_1.forEach(
                (i) {
                  listObras.add(
                    {
                      'nombre': i['nombre_obra'],
                      'primero': i['primer_trimestre'],
                      'segundo': i['segundo_trimestre'],
                      'tercero': i['tercer_trimestre'],
                      'cuarto': i['cuarto_trimestre'],
                      'planeado': i['planeado'],
                      'fecha_planeado': i['fecha_planeado'],
                      'validado': i['validado'],
                      'fecha_validado': i['fecha_validado'],
                      'firmado': i['firmado'],
                      'fecha_firmado': i['fecha_firmado'],
                      'id_obra': i['id_obra'],
                      'index': cont,
                    },
                  );
                  cont++;
                },
              );
              final prodim = json.encode(e['prodim']);
              dynamic prodim_1 = json.decode(prodim);

              prodim_1.forEach((i) {
                firmaElectronica = i['firma_electronica'];
                revisado = i['revisado'];
                validado = i['validado'];
                convenio = i['convenio'];
              });

              final comprometido_2 = json.encode(e['comprometido']);
              dynamic comprometido_3 = json.decode(comprometido_2);

              comprometido_3.forEach(
                (i) {
                  listaObras.add(cardsListadoProdim(context, i['nombre'],
                      numberFormat(i['monto'].toDouble())));
                  final desglose = json.encode(e['desglose']);
                  dynamic desglose_1 = json.decode(desglose);
                  desglose_1.forEach(
                    (a) {
                      if (i['nombre'] == a['nombre']) {
                        listaObras.add(cardsDesglose(context, a['concepto'],
                            numberFormat(a['monto'].toDouble())));
                      }
                    },
                  );
                },
              );

              final gastosIndirectos = json.encode(e['gastos']);
              dynamic indirectos_1 = json.decode(gastosIndirectos);

              indirectos_1.forEach((i) {
                gastos.add(
                  cardsListadoProdim(
                    context,
                    i['nombre'],
                    numberFormat(i['monto'].toDouble()),
                  ),
                );
              });
            },
          );

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
