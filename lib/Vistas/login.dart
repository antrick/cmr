import 'package:flutter/material.dart';

class MainHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/fondo.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.all(50.0),
          child: Column(
            children: [
              SizedBox(height: 20.0),
              Flexible(
                child: ClipOval(
                  child: Image.asset(
                    'images/cmr.png',
                    width: 130,
                    height: 130,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 40.0),
              TextField(
                decoration: const InputDecoration(
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintText: 'Usuario',
                ),
              ),
              SizedBox(height: 25.0),
              TextField(
                decoration: const InputDecoration(
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: Colors.black,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintText: 'Contraseña',
                ),
              ),
              SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () { //metodo para cambiar de pantalla
                  Navigator.pushNamed(context, '/inicio');
                },
                child: const Text(
                  'Iniciar sesion',
                  style: TextStyle(fontSize: 22),
                ),
                style: ElevatedButton.styleFrom(
                  //Color de fondo del boton
                  primary: Colors.orange[800],
                  shape: RoundedRectangleBorder( //borde del boton
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 9.0,
                ),
              ),
              SizedBox(height: 10.0),
              TextButton(
                onPressed: () => _showAlertDialog(context),
                child: Text(
                  'Recuperar Contraseña',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    decoration: TextDecoration.underline,
                    decorationThickness: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//metodo de prueba
  void _showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (buildcontext) {
          return AlertDialog(
            title: Text("Titulo del alert"),
            content: Text("contenido del alert"),
            actions: <Widget>[
              /* RaisedButton(
                child: Text(
                  "CERRAR",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )*/
            ],
          );
        });
  }
}
