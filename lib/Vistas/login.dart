import 'package:flutter/material.dart';
import 'package:flutter_app/Vistas/counter.dart';
import 'package:flutter_app/Vistas/principal.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/*class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  bool visibilityObs = true;

  void _changed(bool visibility, String field) {
    setState(() {
      if (field == "obs") {
        visibilityObs = !visibilityObs;
        print(visibilityObs);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: new InkWell(
          onTap: () {
            print('hola');
            _changed(true, 'obs');
          },
          child: new Stack(fit: StackFit.expand, children: <Widget>[
            /// Paint the area where the inner widgets are loaded with the
            /// background to keep consistency with the screen background
            new Container(
              decoration: BoxDecoration(color: Colors.black),
            ),

            /// Render the background image
            new Container(
              child: Image.asset('images/fondo.jpg.png', fit: BoxFit.cover),
            ),

            /// Render the Title widget, loader and messages below each other
            visibilityObs
                ? new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Expanded(
                        flex: 3,
                        child: new Container(
                            child: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                            ),
                            Text('Application Title'),
                          ],
                        )),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            /// Loader Animation Widget
                            CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.green),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                            ),
                            Text('getMessage'),
                          ],
                        ),
                      ),
                    ],
                  )
                : new Container(),
          ]),
        ));
  }
}*/
void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.red
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool visibilityObs = false;
  bool _isHidden = true;
  String _usuario;
  String _password;
  int id_cliente = 0;
  String url;
  final formkey = GlobalKey<FormState>();
  String token_t;
  final counter = Counter();

  @override
  Widget build(BuildContext context) {
    _returnValue(context).toString();
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/fondo.jpg.png"),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.all(50.0),
        child: Form(
          key: formkey,
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
              TextFormField(
                autocorrect: false,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                    fontSize: 20),
                cursorColor: Colors.lightBlue,
                cursorRadius: Radius.circular(1.0),
                cursorWidth: 2.0,
                decoration: const InputDecoration(
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.black54,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintText: 'USUARIO',
                ),
                onSaved: (text) {
                  _usuario = text;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return "Este campo es necesario";
                  }
                },
              ),
              SizedBox(height: 25.0),
              TextFormField(
                keyboardType: TextInputType.text,
                autocorrect: false,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                    fontSize: 20),
                enableSuggestions: false,
                obscureText: !this._isHidden,
                cursorHeight: 20,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: Colors.black54,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: this._isHidden ? Colors.blue : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() => this._isHidden = !this._isHidden);
                    },
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintText: 'CONTRASEÑA',
                ),
                onSaved: (text) {
                  _password = text;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return "Este campo es necesario";
                  }
                },
              ),
              SizedBox(height: 25.0),
              ElevatedButton(
                onPressed: () {
                  //metodo para cambiar de pantalla
                  //Navigator.pushNamed(context, '/inicio');
                  id_cliente = 0;
                  counter.increment();
                  print('hola');
                  //_showSecondPage(context);
                },
                child: const Text(
                  'INICIAR SESIÓN',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  //Color de fondo del boton
                  primary: Colors.orange[800],
                  shape: RoundedRectangleBorder(
                    //borde del boton
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  elevation: 9.0,
                ),
              ),
              SizedBox(height: 10.0),
              TextButton(
                onPressed: () => _showAlertDialog(context),
                child: Text(
                  'OLVIDE MI CONTRASEÑA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    decoration: TextDecoration.underline,
                    decorationThickness: 2,
                    fontWeight: FontWeight.w300,
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

  //metodo para cambiar pantalla
  void _showSecondPage(BuildContext context) {
    /*Navigator.pushReplacementNamed(context, '/inicio',
        arguments: Welcome(
          id_cliente: 1,
        ));*/
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
      ..userInteractions = true
      ..dismissOnTap = false;

    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      url = "http://192.168.10.160/api/getUsuario/$_usuario,$_password";
      EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
      EasyLoading.show(
        status: 'CARGANDO',
        maskType: EasyLoadingMaskType.custom,
      );
      _getListado();
    }
  }

  void _showSecondToken(BuildContext context, token) {
    /*Navigator.pushReplacementNamed(context, '/inicio',
        arguments: Welcome(
          id_cliente: 1,
        ));*/
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
      ..dismissOnTap = true;
    url = "http://192.168.10.160/api/getUsuarioToken/$token";
    EasyLoading.instance.loadingStyle = EasyLoadingStyle.custom;
    EasyLoading.show(
      status: 'CARGANDO',
      maskType: EasyLoadingMaskType.custom,
    );
    _getListado();
  }

  List<Widget> listado(List<dynamic> info) {
    List<Widget> lista = [];
    info.forEach((elemento) {
      int elemento_cliente = elemento['id_cliente'];
      print("elemento $elemento_cliente");
      lista.add(Text("$elemento_cliente"));
    });
    return lista;
  }

  Future<dynamic> _getListado() async {
    try {
      print(url);
      final respuesta = await http.get(Uri.parse(url));
      if (respuesta.statusCode == 200) {
        bool resp = respuesta.body == "";
        if (respuesta.body != "") {
          final data = json.decode(respuesta.body);
          data.forEach((e) {
            id_cliente = e['id_cliente'];
            token_t = e['remember_token'];
          });
          _saveValue(token_t);
          _login(id_cliente);
          return jsonDecode(respuesta.body);
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
            'DATOS ERRONEOS',
            maskType: EasyLoadingMaskType.custom,
          );
          return null;
        }
      } else {
        print("Error con la respusta");
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

  void _login(
    id_cliente,
  ) {
    EasyLoading.dismiss();
    Navigator.pushReplacementNamed(context, '/inicio',
        arguments: Welcome(
          id_cliente: id_cliente,
        ));
  }

  Widget _menuInferior(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0, // this will be set when a new tab is tapped
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        if (index == 0) {
          Navigator.pushReplacementNamed(context, '/');
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.logout),
          label: 'Salir',
        ),
      ],
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Datos incorrectos'),
          titleTextStyle: TextStyle(
              color: Colors.red[800],
              fontWeight: FontWeight.w500,
              fontSize: 20),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('El nombre de usuario o contraseña son incorrectos.'),
              ],
            ),
          ),
          contentTextStyle: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w300, fontSize: 20),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Aceptar',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _saveValue(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(token);
    await prefs.setString('token', token);
  }

  Future<String> _returnValue(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = await prefs.getString("token");
    if (token != null) {
      _showSecondToken(context, token);
    }
    return token;
  }
}

/*class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _loadingInProgress;

  @override
  void initState() {
    super.initState();
    _loadingInProgress = true;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Custom Loading Animation example"),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loadingInProgress) {
      return new Center(
        child: new CircularProgressIndicator(),
      );
    } else {
      return new Center(
        child: new Text('Data loaded'),
      );
    }
  }
}*/
