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

class Obras_admin extends StatefulWidget {
  @override
  _ObrasView createState() => _ObrasView();
  int id_obra;
  int id_cliente;
  int anio;
  Obras_admin({
    this.id_obra,
    this.id_cliente,
    this.anio,
  });
}

class _ObrasView extends State<Obras_admin> {
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
  List<Widget> listas = [];
  List<Widget> arrendamientos = [];
  String observaciones = '';

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
    final Obras_admin args = ModalRoute.of(context).settings.arguments;
    id_obra = args.id_obra;
    id_cliente = args.id_cliente;
    anio = args.anio;
    /*_getListado(context);*/
    if (!exp.isEmpty && inicio) {
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
          'Modalidad de ejecucion: Administración Directa',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w300,
            fontSize: 18,
          ),
        ),
      ),
    );

    /*if (modalidad == 2) {
      send.add(
        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Text(
            'Modalidad de asignación: Licitación publica',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
              fontSize: 18,
            ),
          ),
        ),
      );
    }
    if (modalidad == 3) {
      send.add(
        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Text(
            'Modalidad de asignación: Invitación a tres',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
              fontSize: 18,
            ),
          ),
        ),
      );
    }
    if (modalidad == 4) {
      send.add(
        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Text(
            'Modalidad de asignación: Adjudicación directa',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
              fontSize: 18,
            ),
          ),
        ),
      );
    }*/

    send.add(SizedBox(
      height: 10,
    ));
    send.add(
      Container(
        margin: EdgeInsets.only(left: 15, right: 15, bottom: 20),
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
          margin: EdgeInsets.only(left: 15, right: 15, bottom: 20),
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
                percent: avance_fisico * 0.01,
                linearStrokeCap: LinearStrokeCap.roundAll,
                center: Text("$avance_fisico%"),
                progressColor: const Color.fromRGBO(0, 153, 51, 1.0),
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
                center: Text("$avance_economico%"),
                progressColor: const Color.fromRGBO(0, 153, 51, 1.0),
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
                child: Text('Avance Técnico',
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
                percent: avance_tecnico * 0.01,
                linearStrokeCap: LinearStrokeCap.roundAll,
                center: Text("$avance_tecnico%"),
                progressColor: const Color.fromRGBO(0, 153, 51, 1.0),
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
                    "Acta de acuerdo de cabildo para administración directa",
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
            color: Colors.white,
          ),
          expandedIcon: Icon(
            Icons.arrow_drop_up,
            color: Colors.white,
          ),
        ),
      ),
    );
    if (listas.length > 1) {
      send.add(
        Container(
          child: GFAccordion(
            titleBorderRadius: BorderRadius.only(
              topLeft: Radius.circular(6),
            ),
            titlePadding:
                EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            margin: EdgeInsets.only(left: 20, top: 10),
            titleChild: Text(
              'LISTAS DE RAYA',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 17,
              ),
            ),
            expandedTitleBackgroundColor: const Color.fromRGBO(9, 46, 116, 1.0),
            collapsedTitleBackgroundColor:
                const Color.fromRGBO(9, 46, 116, 1.0),
            contentBackgroundColor: const Color.fromRGBO(4, 124, 188, 1.0),
            contentChild: Container(
              child: Column(
                children: listas,
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
    }
    if (arrendamientos.length > 1) {
      send.add(
        Container(
          child: GFAccordion(
            titleBorderRadius: BorderRadius.only(
              topLeft: Radius.circular(6),
            ),
            titlePadding:
                EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            margin: EdgeInsets.only(left: 20, top: 10),
            titleChild: Text(
              'CONTRATOS ARRENDAMIENTO',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 17,
              ),
            ),
            expandedTitleBackgroundColor: const Color.fromRGBO(9, 46, 116, 1.0),
            collapsedTitleBackgroundColor:
                const Color.fromRGBO(9, 46, 116, 1.0),
            contentBackgroundColor: const Color.fromRGBO(4, 124, 188, 1.0),
            contentChild: Container(
              child: Column(
                children: arrendamientos,
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
    }
    if (facturas.length > 1) {
      send.add(
        Container(
          child: GFAccordion(
            titleBorderRadius: BorderRadius.only(
              topLeft: Radius.circular(6),
            ),
            titlePadding:
                EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            margin: EdgeInsets.only(left: 20, top: 10),
            onToggleCollapsed: (y) {
              return false;
            },
            titleChild: Text(
              'FACTURAS',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 17,
              ),
            ),
            expandedTitleBackgroundColor: const Color.fromRGBO(9, 46, 116, 1.0),
            collapsedTitleBackgroundColor:
                const Color.fromRGBO(9, 46, 116, 1.0),
            contentBackgroundColor: const Color.fromRGBO(4, 124, 188, 1.0),
            contentChild: Container(
              child: Column(
                children: facturas,
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
    }
    if (observaciones != '') {
      observaciones = observaciones.substring(0, observaciones.length - 3);
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
    url = "http://192.168.10.160/api/getObraExpediente/$id_obra";
    try {
      final respuesta = await http.get(Uri.parse(url));
      if (respuesta.statusCode == 200) {
        bool resp = respuesta.body == "";
        if (respuesta.body != "") {
          final data = json.decode(respuesta.body);
          /*final parte_social = json.encode(data['parte_social']);
          final data1 = json.decode(parte_social);*/
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
                exp.add(i['croquis_macro']);
                exp.add(i['croquis_micro']);
              }
            });
            final parte_admin = json.encode(e['obra_exp']);
            data1 = json.decode(parte_admin);
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
            final parte_obra = json.encode(e['obra']);
            data1 = json.decode('[' + parte_obra + ']');
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
            final parte_lista = json.encode(e['obra_lista']);
            data1 = json.decode(parte_lista);
            data1.forEach((i) {
              if (i != null) {
                String monto = numberFormat(i['total'].toDouble());
                listas.add(
                  cards_lista(context, i['fecha_inicio'], i['fecha_fin'],
                      '\u0024 $monto'),
                );
              }
            });
            final parte_facturas = json.encode(e['obra_facturas']);
            data1 = json.decode(parte_facturas);
            data1.forEach((i) {
              if (i != null) {
                String monto = numberFormat(i['total'].toDouble());
                facturas.add(
                  cards_facturas(context, i['folio_fiscal'], '\u0024 $monto'),
                );
              }
            });
            final parte_arre = json.encode(e['arrendamientos']);
            data1 = json.decode(parte_arre);
            data1.forEach((i) {
              if (i != null) {
                String monto = numberFormat(i['monto_contratado'].toDouble());
                arrendamientos.add(
                  cards_lista(context, i['fecha_inicio'], i['fecha_fin'],
                      '\u0024 $monto'),
                );
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
