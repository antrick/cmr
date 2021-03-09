import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Obras extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Obra Publica"),
          backgroundColor: Colors.transparent,
        ),
        drawer: _getDrawer(context),
        body: menu(context),
        bottomNavigationBar: _menuInferior(context),
      ),
    );
  }
}

void showHome(BuildContext context) {
  Navigator.pop(context);
}

Widget _getDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      children: [
        UserAccountsDrawerHeader(
          currentAccountPicture: FlutterLogo(),
          accountEmail: Text("contacto@elrosario.gob.mx"),
          accountName: Text("Municipio de el Rosario"),
        ),
        ListTile(
          title: Text("Inicio"),
          leading: Icon(Icons.home),
          onTap: () => Navigator.pushReplacementNamed(context, '/inicio'),
        ),
        ListTile(
          title: Text("Fondos de Financiamiento"),
          leading: Icon(Icons.monetization_on_rounded),
          onTap: () => Navigator.pushReplacementNamed(context, '/fondos'),
        ),
        ListTile(
          title: Text("Obra Publica"),
          leading: Icon(Icons.construction),
          onTap: () => Navigator.pushReplacementNamed(context, '/obras'),
        ),
        ListTile(
          title: Text("Obligaciones Gubernamentales"),
          leading: Icon(Icons.check_circle),
          onTap: () => showHome(context),
        ),
        ListTile(
          title: Text("Plan Municipal"),
          leading: Icon(Icons.menu_book),
          onTap: () => showHome(context),
        ),
        ListTile(
          title: Text("Constancia Fiscal"),
          leading: Icon(Icons.note),
          onTap: () => showHome(context),
        ),
        const Divider(
          height: 20,
          thickness: 1,
        ),
        ListTile(
          title: Text("Cerrar Sesion"),
          leading: Icon(Icons.logout),
          onTap: () => Navigator.pushReplacementNamed(context, '/'),
        ),
      ],
    ),
  );
}

Widget menu(BuildContext context) {
  return ListView(
    children: [
      Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Actas Preliminares"),
        ),
      ),
      Container(
        height: 360,
        child: Column(
          children: [
            cards(context),
            cards(context),
            cards(context),
            cards(context),
          ],
        ),
      ),
      Container(
        height: MediaQuery.of(context).size.height - 140,
        child: Column(
          children: [
            SizedBox(
              height: 80.0,
              child: Center(
                  child: Text(
                "Listado de Obras",
                textAlign: TextAlign.center,
              )),
            ),
            Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text("Proyecto"),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text("Inversion"),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text("Avance"),
                    )
                  ],
                )),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              height: 600.0,
              child: Scrollbar(
                child: ListView(children: <Widget>[
                  cards_listado(context),
                  cards_listado(context),
                  cards_listado(context),
                  cards_listado(context),
                  cards_listado(context),
                  cards_listado(context),
                  cards_listado(context),
                  cards_listado(context),
                  cards_listado(context),
                ]),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
//menu inferior
Widget _menuInferior(BuildContext context) {
  return BottomNavigationBar(
    currentIndex: 0, // this will be set when a new tab is tapped
    type: BottomNavigationBarType.fixed,

    items: [
      BottomNavigationBarItem(
        icon: new Icon(Icons.home),
        label: 'Inicio',
      ),
      BottomNavigationBarItem(
        icon: new Icon(Icons.monetization_on_rounded),
        label: 'Fondos',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.construction),
        label: 'Obra Publica',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.check_circle),
        label: 'Obligaciones',
      ),
    ],
  );
}

//-----------Cards de Actas preliminares------------
Widget cards(BuildContext context) {
  return Container(
    height: 90,
    child: Card(
      // RoundedRectangleBorder para proporcionarle esquinas circulares al Card
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      // margen para el Card
      margin: EdgeInsets.all(10),
      // La sombra que tiene el Card aumentará
      elevation: 10,
      //Colocamos una fila en dentro del card
      color: Colors.blue[900],
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              flex: 3,
              child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                      "Acta de integracion del consejo de desarrollo municipal",
                      style: TextStyle(color: Colors.white)))),
          Expanded(
            //columna fecha
            flex: 2,
            child: Text("20/01/2021", style: TextStyle(color: Colors.white)),
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

Widget cards_listado(BuildContext context) {
  return Container(
    height: 90,
    child: Card(
      // RoundedRectangleBorder para proporcionarle esquinas circulares al Card
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      // margen para el Card
      margin: EdgeInsets.all(10),
      // La sombra que tiene el Card aumentará
      elevation: 10,
      //Colocamos una fila en dentro del card
      color: Colors.blue[900],
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              flex: 3,
              child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                      "Pavimentacion con concreto en diferentes calles del municipio",
                      style: TextStyle(color: Colors.white)))),
          Expanded(
            //columna fecha
            flex: 2,
            child: Text("\u0024 2,565,145.98",
                style: TextStyle(color: Colors.white)),
          ),
          Expanded(
            flex: 1,
            child: LinearPercentIndicator(
              width: 60.0,
              animation: true,
              animationDuration: 1000,
              lineHeight: 20.0,
              percent: 0.06,
              linearStrokeCap: LinearStrokeCap.butt,
              center: Text("30.0%"),
              progressColor: Colors.green,
            ),
          )
        ],
      ),
    ),
  );
}
