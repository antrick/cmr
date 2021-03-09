import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
        ),
        drawer: _getDrawer(context),
        body: _options(context),
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
            onTap: () => {},
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

  Widget _options(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(20.0),
        ),
        Text("ADMINISTRACION 2020-2022",
          style: TextStyle(
            color: Colors.blue[900],
            fontSize: 20,
          ),
        ),
        SizedBox(
          height: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: SizedBox(
                height: 80,
                width: 260,
                child: ElevatedButton(
                  child: Row(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.monetization_on_rounded,
                            color: Colors.white,
                          )),
                      Container(
                          margin: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            "Fondo de Financiamiento",
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/fondos');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue[900],
                    shape: RoundedRectangleBorder(
                      //borde del boton
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 8.0,
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: SizedBox(
                height: 80,
                width: 260,
                child: ElevatedButton(
                  child: Row(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.construction,
                            color: Colors.white,
                          )),
                      Container(
                          margin: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            "Obra Pública",
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/obras');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue[900],
                    shape: RoundedRectangleBorder(
                      //borde del boton
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 8.0,
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: SizedBox(
                height: 80,
                width: 260,
                child: ElevatedButton(
                  child: Row(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.white,
                          )),
                      Container(
                          margin: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            "Obligaciones \nGubernamentales",
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  ),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue[900],
                    shape: RoundedRectangleBorder(
                      //borde del boton
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 8.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
