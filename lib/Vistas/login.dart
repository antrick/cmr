import 'package:flutter/material.dart';
import 'package:flutter_app/Vistas/counter.dart';
import 'package:flutter_app/Vistas/principal.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';
import 'package:onesignal_flutter/onesignal_flutter.dart';

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
  final TargetPlatform platform;
  LoginForm({
    this.platform,
  });

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
  String _debugLabelString = "";
  String _emailAddress = 'tirado1294@gmail.com';
  String _externalUserId;
  bool _enableConsentButton = false;
  bool _requireConsent = true;
  String _idOneSignal = "";
  @override
  void initState() {
    _handleConsent();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    _returnValue(context).toString();
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/Fondo03.png"),
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
                  _showSecondPage(context);
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
    MediaQueryData _mediaQueryData;
    double screenWidth;
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    (MediaQuery.of(context).size.width / MediaQuery.of(context).size.height) *
        20;
    print(screenWidth);
    print((MediaQuery.of(context).size.width /
            MediaQuery.of(context).size.height) *
        20);
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
      url =
          "http://192.168.10.160:8000/api/getUsuario/$_usuario,$_password,$_idOneSignal";
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
    url = "http://192.168.10.141:8000/api/getUsuarioToken/$token";
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
            print("hola");
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
        'ERROR DE CONEXIÓN 1',
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

  Future<void> initPlatformState() async {
    if (!mounted) return;

    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.setRequiresUserPrivacyConsent(_requireConsent);

    var settings = {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.promptBeforeOpeningPushUrl: true
    };

    OneSignal.shared
        .setNotificationReceivedHandler((OSNotification notification) {
      this.setState(() {
        _debugLabelString =
            "Received notification: \n${notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      this.setState(() {
        _debugLabelString =
            "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.shared
        .setInAppMessageClickedHandler((OSInAppMessageAction action) {
      this.setState(() {
        _debugLabelString =
            "In App Message Clicked: \n${action.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      print("PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges changes) {
      print("EMAIL SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}");
    });

    // NOTE: Replace with your own app ID from https://www.onesignal.com
    await OneSignal.shared
        .init("c1bfe080-0e68-4974-97e2-914afc5b7501", iOSSettings: settings);

    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

    bool requiresConsent = await OneSignal.shared.requiresUserPrivacyConsent();

    this.setState(() {
      _enableConsentButton = requiresConsent;
    });

    // Some examples of how to use In App Messaging public methods with OneSignal SDK
    oneSignalInAppMessagingTriggerExamples();

    // Some examples of how to use Outcome Events public methods with OneSignal SDK
    oneSignalOutcomeEventsExamples();

    _handleSetEmail();
  }

  void _handleSetEmail() {
    if (_emailAddress == null) return;

    OneSignal.shared.setEmail(email: _emailAddress).whenComplete(() {
      print("Successfully set email");
      initPlatformState1();
    }).catchError((error) {
      print("Failed to set email with error: $error");
    });
  }

  Future<void> initPlatformState1() async {
    var status = await OneSignal.shared.getPermissionSubscriptionState();
    print("hola");
    _idOneSignal = status.subscriptionStatus.userId;
    if (status.permissionStatus.hasPrompted)
    // we know that the user was prompted for push permission

    if (status.permissionStatus.status ==
        OSNotificationPermission.notDetermined)
    // boolean telling you if the user enabled notifications

    if (status.subscriptionStatus.subscribed) {}

    // the user's APNS or FCM/GCM push token
    String token = status.subscriptionStatus.pushToken;

    String emailPlayerId = status.emailSubscriptionStatus.emailUserId;
    String emailAddress = status.emailSubscriptionStatus.emailAddress;
  }

  void _handleConsent() {
    print("Setting consent to true");
    OneSignal.shared.consentGranted(true);

    print("Setting state");
    this.setState(() {
      _enableConsentButton = false;
    });
  }

  oneSignalInAppMessagingTriggerExamples() async {
    /// Example addTrigger call for IAM
    /// This will add 1 trigger so if there are any IAM satisfying it, it
    /// will be shown to the user
    OneSignal.shared.addTrigger("trigger_1", "one");

    /// Example addTriggers call for IAM
    /// This will add 2 triggers so if there are any IAM satisfying these, they
    /// will be shown to the user
    Map<String, Object> triggers = new Map<String, Object>();
    triggers["trigger_2"] = "two";
    triggers["trigger_3"] = "three";
    OneSignal.shared.addTriggers(triggers);

    // Removes a trigger by its key so if any future IAM are pulled with
    // these triggers they will not be shown until the trigger is added back
    OneSignal.shared.removeTriggerForKey("trigger_2");

    // Get the value for a trigger by its key
    Object triggerValue =
        await OneSignal.shared.getTriggerValueForKey("trigger_3");
    print("'trigger_3' key trigger value: " + triggerValue.toString());

    // Create a list and bulk remove triggers based on keys supplied
    List<String> keys = ["trigger_1", "trigger_3"];
    OneSignal.shared.removeTriggersForKeys(keys);

    // Toggle pausing (displaying or not) of IAMs
    OneSignal.shared.pauseInAppMessages(false);
  }

  oneSignalOutcomeEventsExamples() async {
    // Await example for sending outcomes
    outcomeAwaitExample();

    // Send a normal outcome and get a reply with the name of the outcome
    OneSignal.shared.sendOutcome("normal_1");
    OneSignal.shared.sendOutcome("normal_2").then((outcomeEvent) {
      print(outcomeEvent.jsonRepresentation());
    });

    // Send a unique outcome and get a reply with the name of the outcome
    OneSignal.shared.sendUniqueOutcome("unique_1");
    OneSignal.shared.sendUniqueOutcome("unique_2").then((outcomeEvent) {
      print(outcomeEvent.jsonRepresentation());
    });

    // Send an outcome with a value and get a reply with the name of the outcome
    OneSignal.shared.sendOutcomeWithValue("value_1", 3.2);
    OneSignal.shared.sendOutcomeWithValue("value_2", 3.9).then((outcomeEvent) {
      print(outcomeEvent.jsonRepresentation());
    });
  }

  Future<void> outcomeAwaitExample() async {
    var outcomeEvent = await OneSignal.shared.sendOutcome("await_normal_1");
    print(outcomeEvent.jsonRepresentation());
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
