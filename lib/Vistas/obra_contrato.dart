import 'package:flutter/material.dart';
import 'package:flutter_app/Vistas/anio.dart';
import 'package:flutter_app/Vistas/obra_publica.dart';
import 'package:flutter_app/Vistas/principal.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:getwidget/components/accordian/gf_accordian.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Obras_contrato extends StatefulWidget {
  @override
  _ObrasContrato createState() => _ObrasContrato();
  int id_obra;
  int id_cliente;
  int anio;
  Obras_contrato({
    this.id_obra,
    this.id_cliente,
    this.anio,
  });
}

class Vehicle {
  final String title;
  List<String> contents = [];
  List<int> icons;

  Vehicle(this.title, this.contents, this.icons);
}

class _ObrasContrato extends State<Obras_contrato> {
  String nombre_obra = 'Ejemplo de nombre de obra';
  String monto = '10,000';
  double avance_fisico = 20.0;
  double avance_tecnico = 20.0;
  double avance_economico = 20.0;
  String url;
  bool inicio = false;
  int id_cliente;
  int anio;
  int modalidad = 2;
  int id_obra;
  List<Widget> lista_obras = [];
  List<Widget> send = [];
  List<int> exp = [];
  List<String> fondo = [];
  List<Widget> facturas = [];
  List<Widget> estimacion = [];
  List<Widget> arrendamientos = [];
  List<Widget> licitacion = [];
  String observaciones = '';
  String contrato;
  int fact_anticipo;
  int f_ant;
  int f_cumplimiento;
  int f_v_o;
  String tipo_contrato;

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
    final Obras_contrato args = ModalRoute.of(context).settings.arguments;
    id_obra = args.id_obra;
    id_cliente = args.id_cliente;
    anio = args.anio;
    /*_getListado(context);*/
    if (!exp.isEmpty && inicio) {
      _options();
    }
    if (send.isEmpty && !inicio) {
      _getListado(context);
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
            color: const Color.fromRGBO(4, 124, 188, 1.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    flex: 3,
                    child: Text('FECHA DE INICIO',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ))),
                Expanded(
                    flex: 3,
                    child: Text('FECHA DE FIN',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ))),
                Expanded(
                    flex: 3,
                    child: Text('MONTO',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
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
            color: const Color.fromRGBO(4, 124, 188, 1.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    flex: 3,
                    child: Text('FOLIO FISCAL',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ))),
                Expanded(
                    flex: 1,
                    child: Text('MONTO',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ))),
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
                image: AssetImage("images/Fondo05.png"),
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
    String n_moda = 'Licitación pública';
    int avance_fisico_1 = avance_fisico.toInt();
    int avance_economico_1 = avance_economico.toInt();
    int avance_tecnico_1 = avance_tecnico.toInt();
    print(modalidad);
    if (modalidad == 3) {
      print('hola');
      n_moda = 'Invitación a cuando menos tres contratistas';
    }
    if (modalidad == 4) {
      n_moda = 'Adjudicación directa';
    }
    send.clear();
    send.add(SizedBox(
      height: 30,
    ));
    send.add(
      Container(
        margin: EdgeInsets.only(left: 15, right: 15, bottom: 20),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                flex: 3,
                child: Text(nombre_obra.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ))),
            Expanded(
              flex: 1,
              child: Icon(
                Icons.get_app_rounded,
                color: Colors.green,
                size: 25,
              ),
            )
          ],
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
          'Modalidad de ejecucion: Contrato',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w300,
            fontSize: 18,
          ),
        ),
      ),
    );
    send.add(
      Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Text(
          'Modalidad de asignación: $n_moda',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w300,
            fontSize: 18,
          ),
        ),
      ),
    );

    send.add(
      Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 20),
        child: Text(
          'NÚMERO DE CONTRATO: $contrato',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 18,
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
          '$tipo_contrato',
          style: TextStyle(
            color: Colors.white,
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
                child: Text('INVERSIÓN',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ))),
            Expanded(
              //columna fecha
              flex: 5,
              child: Text(
                '\u0024 $monto',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
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
          margin: EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                  flex: 3,
                  child: Text(fondoT,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                      ))),
              Expanded(
                //columna fecha
                flex: 5,
                child: Text(
                  '\u0024 $montoT',
                  style: TextStyle(
                    color: Colors.white,
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
    send.add(SizedBox(
      height: 10,
    ));

    send.add(
      Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                flex: 3,
                child: Text('Avance Fisico',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 18,
                    ))),
            Expanded(
              //columna fecha
              flex: 5,
              child: LinearPercentIndicator(
                animation: true,
                animationDuration: 1000,
                lineHeight: 20.0,
                percent: 0,
                center: Text(
                  "$avance_fisico_1%",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: const Color.fromRGBO(0, 153, 51, 1.0),
                backgroundColor: const Color.fromRGBO(133, 138, 141, 1.0),
              ),
            ),
          ],
        ),
      ),
    );
    send.add(
      Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 5),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                flex: 3,
                child: Text('Avance Económico',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 18,
                    ))),
            Expanded(
              //columna fecha
              flex: 5,
              child: LinearPercentIndicator(
                animation: true,
                animationDuration: 1000,
                lineHeight: 20.0,
                percent: avance_economico * 0.01,
                linearStrokeCap: LinearStrokeCap.roundAll,
                center: Text(
                  "$avance_economico_1%",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                progressColor: const Color.fromRGBO(0, 153, 51, 1.0),
                backgroundColor: const Color.fromRGBO(133, 138, 141, 1.0),
              ),
            ),
          ],
        ),
      ),
    );
    send.add(
      Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 5),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                'Avance Técnico',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 18,
                ),
              ),
            ),
            Expanded(
              //columna fecha
              flex: 5,
              child: LinearPercentIndicator(
                animation: true,
                animationDuration: 1000,
                lineHeight: 20.0,
                percent: .8,
                linearStrokeCap: LinearStrokeCap.roundAll,
                center: Text(
                  '$avance_tecnico_1%',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                progressColor: const Color.fromRGBO(0, 153, 51, 1.0),
                backgroundColor: const Color.fromRGBO(133, 138, 141, 1.0),
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
          titleBorderRadius: BorderRadius.only(),
          margin: EdgeInsets.only(top: 10),
          titlePadding:
              EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          titleChild: Text(
            'PARTE SOCIAL',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          expandedTitleBackgroundColor: const Color.fromRGBO(9, 46, 116, 1.0),
          collapsedTitleBackgroundColor: const Color.fromRGBO(9, 46, 116, 1.0),
          contentBackgroundColor: const Color.fromRGBO(4, 124, 188, 1.0),
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
                    "Acta de acuerdo excepción a la licitación pública",
                    exp[7]),
              ],
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
      ),
    );
    send.add(
      Container(
        child: GFAccordion(
          titleBorderRadius: BorderRadius.only(),
          margin: EdgeInsets.only(top: 10),
          titlePadding:
              EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          titleChild: Text(
            'PROYECTO EJECUTIVO',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          expandedTitleBackgroundColor: const Color.fromRGBO(9, 46, 116, 1.0),
          collapsedTitleBackgroundColor: const Color.fromRGBO(9, 46, 116, 1.0),
          contentBackgroundColor: const Color.fromRGBO(4, 124, 188, 1.0),
          contentChild: Container(
            child: Column(
              children: [
                cards(
                    context,
                    "Estudio de factibilidad técnica exonómica y exológica",
                    exp[8]),
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
                cards(context, "Programa de obra e inversión", exp[22]),
                cards(context, "Croquis de macrolocalización", exp[23]),
                cards(context, "Croquis de microlocalización", exp[24]),
              ],
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
      ),
    );
    send.add(
      Container(
        child: GFAccordion(
          titleBorderRadius: BorderRadius.only(),
          margin: EdgeInsets.only(top: 10),
          titlePadding:
              EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          titleChild: Text(
            'PROCESO DE CONTRATACIÓN',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          expandedTitleBackgroundColor: const Color.fromRGBO(9, 46, 116, 1.0),
          collapsedTitleBackgroundColor: const Color.fromRGBO(9, 46, 116, 1.0),
          contentBackgroundColor: const Color.fromRGBO(4, 124, 188, 1.0),
          contentChild: Container(
            child: Column(
              children: licitacion,
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
      ),
    );

    send.add(
      Container(
        child: GFAccordion(
          titleBorderRadius: BorderRadius.only(),
          margin: EdgeInsets.only(top: 10),
          titlePadding:
              EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          titleChild: Text(
            'EJECUCIÓN DE OBRA',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          expandedTitleBackgroundColor: const Color.fromRGBO(9, 46, 116, 1.0),
          collapsedTitleBackgroundColor: const Color.fromRGBO(9, 46, 116, 1.0),
          contentBackgroundColor: const Color.fromRGBO(4, 124, 188, 1.0),
          contentChild: Container(
            child: Column(
              children: [
                cards(context, "Asignación del superintendente (Contratista)",
                    exp[25]),
                cards(context, "Asignación del residente de obra (Municipio)",
                    exp[26]),
                cards(context, "Oficio para la disposición del inmueble",
                    exp[27]),
                cards(context, "Notificación de incio de obra", exp[28]),
              ],
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
      ),
    );
    send.add(
      Container(
        child: GFAccordion(
          titleBorderRadius: BorderRadius.only(),
          margin: EdgeInsets.only(top: 10),
          titlePadding:
              EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          titleChild: Text(
            'DOCUMENTACIÓN COMPROBATORIA',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          expandedTitleBackgroundColor: const Color.fromRGBO(9, 46, 116, 1.0),
          collapsedTitleBackgroundColor: const Color.fromRGBO(9, 46, 116, 1.0),
          contentBackgroundColor: const Color.fromRGBO(4, 124, 188, 1.0),
          contentChild: Container(
            child: Column(
              children: [
                cards(context, "Factura de anticipo", fact_anticipo),
                cards(context, "Fianza de anticipo", f_ant),
                cards(context, "Fianza de cumplimiento", f_cumplimiento),
                cards(context, "Fianza de vicios ocultos", f_v_o),
              ],
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
      ),
    );
    for (var i = 0; i < estimacion.length; i++) {
      send.add(estimacion[i]);
    }

    send.add(
      Container(
        child: GFAccordion(
          titleBorderRadius: BorderRadius.only(),
          margin: EdgeInsets.only(top: 10),
          titlePadding:
              EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          titleChild: Text(
            'TERMINACIÓN DE LOS TRABAJOS',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          expandedTitleBackgroundColor: const Color.fromRGBO(9, 46, 116, 1.0),
          collapsedTitleBackgroundColor: const Color.fromRGBO(9, 46, 116, 1.0),
          contentBackgroundColor: const Color.fromRGBO(4, 124, 188, 1.0),
          contentChild: Container(
            child: Column(
              children: [
                cards(context, "Aviso de terminación de obra", exp[29]),
                cards(
                    context,
                    "Acta de entrega-recepción contratista a municipio",
                    exp[30]),
                cards(
                    context,
                    "Acta de entrega-recepción municipio a beneficiarios",
                    exp[31]),
                cards(context, "Sabana de finiquito de obra", exp[32]),
              ],
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
      ),
    );

    if (observaciones != '') {
      observaciones = observaciones.substring(0, observaciones.length - 2);
      send.add(
        Container(
          child: GFAccordion(
            titleBorderRadius: BorderRadius.only(
              topLeft: Radius.circular(6),
            ),
            titlePadding:
                EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            margin: EdgeInsets.only(top: 10),
            titleChild: Text(
              'OBSERVACIONES',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            expandedTitleBackgroundColor:
                const Color.fromRGBO(207, 86, 41, 1.0),
            collapsedTitleBackgroundColor:
                const Color.fromRGBO(207, 86, 41, 1.0),
            contentBackgroundColor: const Color.fromRGBO(4, 124, 188, 1.0),
            contentChild: Container(
              child: Column(children: [
                Container(
                  width: MediaQuery.of(context).size.height,
                  child: Card(
                    // RoundedRectangleBorder para proporcionarle esquinas circulares al Card
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    // margen para el Card
                    // La sombra que tiene el Card aumentará
                    elevation: 0,
                    //Colocamos una fila en dentro del card
                    color: const Color.fromRGBO(9, 46, 116, 1.0),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        observaciones,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
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
              color: Colors.white,
            ),
            expandedIcon: Icon(
              Icons.arrow_drop_up,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
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
                          fontWeight: FontWeight.w300,
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

  Widget cards_facturas(BuildContext context, folio, monto) {
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

  Widget cards_lista(BuildContext context, fecha_inicio, fecha_fin, monto) {
    IconData estado_icon;
    Color color;
    Color color_barra;

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
                    child: Text(fecha_inicio,
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
                    child: Text(fecha_fin,
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

  Widget cards_listado(
      BuildContext context, nombre, monto, avance, id_obra, modalidad) {
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
    url = "http://192.168.10.141:8000/api/getObraExpediente/$id_obra";
    try {
      final respuesta = await http.get(Uri.parse(url));
      if (respuesta.statusCode == 200) {
        bool resp = respuesta.body == "";
        if (respuesta.body != "") {
          final data = json.decode(respuesta.body);
          /*final parte_social = json.encode(data['parte_social']);
          print(respuesta.body);
          final data1 = json.decode(parte_social);
          print(data);*/
          data.forEach((e) {
            final parte_social = json.encode(e['parte_social']);
            dynamic data1 = json.decode(parte_social);
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
                exp.add(i['programa_obra_inversion']);
                exp.add(i['croquis_macro']);
                exp.add(i['croquis_micro']);
              }
            });
            final parte_licitacion = json.encode(e['obra_licitacion']);
            data1 = json.decode(parte_licitacion);
            data1.forEach((i) {
              if (i != null) {
                licitacion.add(cards(
                    context,
                    "Padrón de contratistas de obra pública del municipio",
                    i['padron_contratistas']));
                licitacion.add(cards(
                    context, "Bases de licitación", i['bases_licitacion']));
                licitacion.add(cards(
                    context,
                    "Constancia de visita donde se ejecutará la obra",
                    i['constancia_visita']));
                licitacion.add(
                  cards(context, "Acta de la junta de aclaraciones",
                      i['acta_junta_aclaraciones']),
                );
                licitacion.add(
                  cards(context, "Acta de apertura técnica",
                      i['acta_apertura_tecnica']),
                );
                licitacion.add(
                  cards(context, "Dictamen técnico y análisis detallado",
                      i['dictamen_tecnico']),
                );
                licitacion.add(
                  cards(context, "Acta de apertura económica",
                      i['acta_apertura_economica']),
                );
                licitacion.add(
                  cards(context, "Dictamen económico y análisis detallado",
                      i['dictamen_economico']),
                );
                licitacion.add(
                  cards(context, "Dictamen", i['dictamen']),
                );
                licitacion.add(
                  cards(context, "Acta de fallo", i['acta_fallo']),
                );
                licitacion.add(
                  cards(context, "Propuesta de licitantes técnica",
                      i['propuesta_licitantes_tecnica']),
                );
                licitacion.add(
                  cards(context, "Propuesta de licitantes económica",
                      i['propuesta_licitantes_economica']),
                );
              }
            });
            final parte_obra = json.encode(e['obra']);
            data1 = json.decode('[' + parte_obra + ']');
            int anticipo = 3;
            data1.forEach((i) {
              if (i != null) {
                nombre_obra = i['nombre_obra'];
                monto = numberFormat(i['monto_contratado'].toDouble());
                avance_fisico =
                    int.parse(i['avance_fisico'].toStringAsFixed(0)).toDouble();
                avance_economico =
                    int.parse(i['avance_economico'].toStringAsFixed(0))
                        .toDouble();
                avance_tecnico =
                    int.parse(i['avance_tecnico'].toStringAsFixed(0))
                        .toDouble();
                if (i['anticipo_porcentaje'] != 0) {
                  anticipo = 1;
                } else {
                  anticipo = 3;
                }
              }
            });
            final parte_admin = json.encode(e['obra_exp']);
            data1 = json.decode(parte_admin);
            data1.forEach((i) {
              if (i != null) {
                licitacion.add(
                  cards(
                      context,
                      "Oficio justificatorio para convenio modificatorio",
                      i['oficio_justificativo_convenio_modificatorio']),
                );
                licitacion.add(
                  cards(context, "Analísis de precios unitarios",
                      i['analisis_p_u']),
                );
                licitacion.add(
                  cards(context, "Catalogo de conceptos",
                      i['catalogo_conceptos']),
                );
                licitacion.add(
                  cards(context, "Montos mensuales ejecutados",
                      i['montos_mensuales_ejecutados']),
                );
                licitacion.add(
                  cards(context, "Calendario de los trabajos ejecutados",
                      i['calendario_trabajos_ejecutados']),
                );
                exp.add(i['oficio_superintendente']);
                exp.add(i['oficio_residente_obra']);
                exp.add(i['oficio_disposicion_inmueble']);
                exp.add(i['oficio_inicio_obra']);
                exp.add(i['aviso_terminacion_obra']);
                exp.add(i['acta_entrega_contratista']);
                exp.add(i['acta_entrega_municipio']);
                exp.add(i['saba_finiquito']);
                exp.add(i['notas_botacoras']);
                modalidad = i['modalidad_asignacion'];
                fact_anticipo = anticipo;
                f_ant = anticipo;
                if (anticipo == 1 && i['factura_anticipo'] == '') {
                  fact_anticipo = 2;
                  f_ant = 2;
                }
                /*fact_anticipo = i['factura_anticipo'];*/
                f_cumplimiento = 1;
                if (i['fianza_cumplimiento'] == "") {
                  f_cumplimiento = 2;
                }
                f_v_o = 1;
                if (i['fianza_v_o'] == "") {
                  f_v_o = 2;
                }
                contrato = i['contrato'];
                if (i['contrato_tipo'] == 1) {
                  tipo_contrato = 'PRECIOS UNITARIOS';
                } else {
                  tipo_contrato = 'PRECIOS ALZADOS';
                }
              }
            });

            final parte_fondo = json.encode(e['fondo']);
            data1 = json.decode(parte_fondo);
            data1.forEach((i) {
              if (i != null) {
                fondo.add(i['nombre_corto']);
                fondo.add(numberFormat(i['monto'].toDouble()));
              }
            });
            final parte_estimacion = json.encode(e['obra_estimacion']);
            data1 = json.decode(parte_estimacion);
            int p = 1;
            data1.forEach((i) {
              if (i != null) {
                estimacion.add(
                  Container(
                    child: GFAccordion(
                      titleBorderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                      ),
                      titlePadding: EdgeInsets.only(
                          left: 15, right: 15, top: 10, bottom: 10),
                      margin: EdgeInsets.only(left: 20, top: 10),
                      titleChild: Text(
                        'ESTIMACION $p',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                        ),
                      ),
                      expandedTitleBackgroundColor:
                          const Color.fromRGBO(9, 46, 116, 1.0),
                      collapsedTitleBackgroundColor:
                          const Color.fromRGBO(9, 46, 116, 1.0),
                      contentBackgroundColor:
                          const Color.fromRGBO(4, 124, 188, 1.0),
                      contentChild: Container(
                        child: Column(
                          children: [
                            cards_lista(
                                context,
                                i['fecha_inicio'],
                                i['fecha_final'],
                                numberFormat(i['total_estimacion'].toDouble())),
                            cards(context, "Caratula de la estimación",
                                i['caratula_estimacion']),
                            cards(context, "Presupuesto de la estimación",
                                i['presupuesto_estimacion']),
                            cards(context, "Cuerpo de la estimación",
                                i['cuerpo_estimacion']),
                            cards(context, "Número generados de la estimación",
                                i['numero_generadores_estimacion']),
                            cards(context, "Resumen de la estimación",
                                i['resumen_estimacion']),
                            cards(context, "Estado de cuenta de la estimación",
                                i['estado_cuenta_estimacion']),
                            cards(
                                context,
                                "Croquis ilustrativo de la estimación",
                                i['croquis_ilustrativo_estimacion']),
                            cards(
                                context,
                                "Reporte fotografico de la estimación",
                                i['reporte_fotografico_estimacion']),
                          ],
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
                  ),
                );
                p++;
              }
            });

            final parte_obs = json.encode(e['observaciones']);
            data1 = json.decode(parte_obs);
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
          ..backgroundColor = Colors.red[900]
          ..indicatorColor = Colors.white
          ..textColor = Colors.white
          ..maskColor = Colors.black.withOpacity(0.88)
          ..userInteractions = false
          ..dismissOnTap = true;
        EasyLoading.dismiss();
        EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
        EasyLoading.showError(
          'ERROR DE CONEXIÓN',
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
    await prefs.setString('token', token);
  }
}
