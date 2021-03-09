import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Fondos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text("Fondos de Financiamiento"),
        ),
        drawer: _getDrawer(context),
        body: _contenedor(context),
        bottomNavigationBar: _menuInferior(context),
      ),
    );
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

  void showHome(BuildContext context) {
    Navigator.pop(context);
  }

  Widget _contenedor(BuildContext context) {
    return Container(
      child: Scrollbar(
        child: ListView(
          children: [
            cards(context),
            cards(context),
            cards(context),
            cards(context),
          ],
        ),
      ),
    );
  }

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

  Widget cards(BuildContext context) {
    return Container(
      height: 300,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)), //bordes redondeados
        margin: EdgeInsets.all(20),
        color: Colors.blue[900],
        elevation: 12,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ramo 28",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Recibido:\n \u0024 10,854,654.99",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0)),
                ],
              ), //titulo y barra contratado
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Contratado \n \u0024 8,786,489.01",
                        style: TextStyle(
                          color: Colors.white,
                        ))
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
                    percent: 0.7,
                    center: Text("70.0%"),
                    progressColor: Colors.green,
                  ),
                ],
              ), //titulo y barra pendiente
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Pendiente \n \u0024 1,856,890.98",
                        style: TextStyle(
                          color: Colors.white,
                        ))
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
                    percent: 0.3,
                    center: Text("30.0%"),
                    progressColor: Colors.blueAccent,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
