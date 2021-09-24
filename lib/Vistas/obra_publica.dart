import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:dio/dio.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Vistas/anio.dart';
import 'package:flutter_app/Vistas/login.dart';
import 'package:flutter_app/Vistas/obra_admin.dart';
import 'package:flutter_app/Vistas/obra_contrato.dart';
import 'package:flutter_app/Vistas/principal.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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

const debug = true;

class Obras extends StatefulWidget with WidgetsBindingObserver {
  final TargetPlatform platform;

  final int idCliente;
  final int anio;
  final int clave;
  final String path;
  Obras({
    Key key,
    this.idCliente,
    this.anio,
    this.platform,
    this.clave,
    this.path,
  }) : super(key: key);
  _ObrasView createState() => _ObrasView(
        idCliente: idCliente,
        anio: anio,
        claveMunicipio: clave,
      );
}

class _ObrasView extends State<Obras> {
  String fechaIntegracion = '';
  String fechaPriorizacion = '';
  String fechaAdendum = '';
  String url;
  bool inicio = false;
  int idCliente;
  int anio;
  List<Widget> listaObras = [];
  List<Widget> send = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<String> fechas = [];
  List<String> link = [];
  int claveMunicipio = 0;

  //Variables descargar archivos
  bool isLoading;
  bool _allowWriteFile = false;

  String _localPath;
  String ruta;

  String progress = "";
  Dio dio;
  Course s;

  _ObrasView({
    this.idCliente,
    this.anio,
    this.claveMunicipio,
  });

  @override
  void initState() {
    super.initState();
    getDirectoryPath();
    dio = Dio();
  }

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
    idCliente = args.idCliente;
    anio = args.anio;
    claveMunicipio = args.clave;
    _localPath = args.path;

    if (listaObras.isNotEmpty && inicio) {
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
    send.add(Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "ACTAS PRELIMINARES",
          style: TextStyle(
            color: Color.fromRGBO(9, 46, 116, 1.0),
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ),
    ));
    send.add(SizedBox(
      height: 10,
    ));
    send.add(
      cards(
          context,
          'Acta de Integración del Consejo de Desarrollo Municipal',
          fechaIntegracion,
          0,
          Course(
              title: "ACTA INTEGRACIÓN",
              path:
                  'http://sistema.mrcorporativo.com/archivos/$claveMunicipio/$anio/acta_consejo.pdf')),
    );
    send.add(
      cards(
          context,
          'Acta de Priorización de Obras',
          fechaPriorizacion,
          1,
          Course(
              title: "ACTA PRIORIZACIÓN",
              path:
                  'http://sistema.mrcorporativo.com/archivos/$claveMunicipio/$anio/acta_priorizacion.pdf')),
    );

    send.add(
      cards(
          context,
          'Acta de Adendum a la Priorización de Obras',
          fechaAdendum,
          2,
          Course(
              title: "ACTA ADENDUM",
              path:
                  'http://sistema.mrcorporativo.com/archivos/$claveMunicipio/$anio/acta_adendum.pdf')),
    );

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
                color: Color.fromRGBO(9, 46, 116, 1.0),
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
                "Proyecto",
                style: TextStyle(
                  color: Color.fromRGBO(9, 46, 116, 1.0),
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                "Inversión",
                style: TextStyle(
                  color: Color.fromRGBO(9, 46, 116, 1.0),
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                "Avance",
                style: TextStyle(
                  color: Color.fromRGBO(9, 46, 116, 1.0),
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
        children: listaObras,
      ),
    ));
    send.add(SizedBox(
      height: 30,
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
          CupertinoIcons.hammer,
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

//-----------Cards de Actas preliminares------------
  Widget cards(BuildContext context, nombre, fecha, posicion, object) {
    String url = object.path;
    String title = object.title;
    String extension = url.substring(url.lastIndexOf("/"));
    File f = File(_localPath + "$extension");
    return Container(
      height: 70,
      child: Card(
        // RoundedRectangleBorder para proporcionarle esquinas circulares al Card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(color: Color.fromRGBO(9, 46, 116, 1.0)),
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
              //columna fecha
              flex: 2,
              child: Text(
                fecha.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromRGBO(9, 46, 116, 1.0),
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
            ),
            Expanded(
              flex: f.existsSync() ? 1 : 2,
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
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: new Icon(
                            Icons.remove_red_eye,
                            color: Colors.green,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.file_download,
                        color: Colors.blue,
                      ),
              ),
            ),
            Expanded(
              flex: f.existsSync() ? 1 : 0,
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
    );
  }
// ------------- Cards Listado de obras -------------------

  Widget cardsListado(BuildContext context, nombre, monto, avance, idObra,
      modalidad, nombreArchivo, archivos, fechaActualizacion) {
    int avance_1 = avance.toInt();
    return Container(
      height: 70,
      child: InkWell(
        onTap: () {
          if (modalidad == 1) {
            Navigator.pushNamed(context, '/admin',
                arguments: ObrasAdmin(
                  idObra: idObra,
                  idCliente: idCliente,
                  anio: anio,
                  clave: claveMunicipio,
                  nombre: nombre,
                  nombreArchivo: nombreArchivo,
                  path: _localPath,
                ));
          }
          if (modalidad > 1) {
            Navigator.pushNamed(
              context,
              '/contrato',
              arguments: ObrasContrato(
                idObra: idObra,
                idCliente: idCliente,
                anio: anio,
                clave: claveMunicipio,
                nombre: nombre,
                nombreArchivo: nombreArchivo,
                archivos: archivos,
                path: _localPath,
              ),
            );
          }
        },
        child: Card(
          // RoundedRectangleBorder para proporcionarle esquinas circulares al Card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(color: Color.fromRGBO(9, 46, 116, 1.0)),
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
                //columna fecha
                flex: 2,
                child: Text(
                  "\u0024 $monto",
                  style: TextStyle(
                    color: Color.fromRGBO(9, 46, 116, 1.0),
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: CircularPercentIndicator(
                  radius: 40.0,
                  animation: true,
                  animationDuration: 1000,
                  percent: avance * 0.01,
                  circularStrokeCap: CircularStrokeCap.round,
                  center: Text(
                    "$avance_1%",
                    style: TextStyle(
                      color: Color.fromRGBO(9, 46, 116, 1.0),
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                    ),
                  ),
                  progressColor: Colors.blue,
                  backgroundColor: Colors.grey[350],
                  lineWidth: 4.5,
                ),
              )
            ],
          ),
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
    url =
        "http://sistema.mrcorporativo.com/api/getObrasCliente/$idCliente,$anio";

    try {
      final respuesta = await http.get(Uri.parse(url));
      if (respuesta.statusCode == 200) {
        if (respuesta.body != "") {
          final data = json.decode(respuesta.body);
          data.forEach((e) {
            final desglose = json.encode(e['obras']);
            final data1 = json.decode(desglose);
            data1.forEach((i) {
              if (i != null) {
                fechaIntegracion = i['acta_integracion_consejo'];
                fechaPriorizacion = i['acta_priorizacion'];
                fechaAdendum = i['adendum_priorizacion'];
                double avance = int.parse(i['avance_tecnico']).toDouble();
                double montoContratado = i['monto_contratado'].toDouble();
                String nombre = i['nombre_obra'];
                int pagos = 0;
                var des = json.encode(e['desglose']);
                var data2 = json.decode(des);
                data2.forEach((x) {
                  if (i['id_obra'] == x['id_obra']) pagos = x['pagos_count'];
                });

                listaObras.add(
                  cardsListado(
                    context,
                    nombre,
                    numberFormat(montoContratado),
                    avance,
                    i['id_obra'],
                    i['modalidad_ejecucion'],
                    i['nombre_archivo'],
                    pagos,
                    i['fecha_actualziacion'],
                  ),
                );
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

  //Metodos para descargar archivos

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
