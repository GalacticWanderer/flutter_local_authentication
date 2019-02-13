import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart'; //for bioMetric authentication

/*
  ***IMPORTANT NOTE***
  * This plugin requires you to move your project to AndroidX
  * But for this app I went to build.gradle on the app folder
  * and added at the bottom-> api "androidx.core:core:1.1.0-alpha03"
  * and then updated compileSdkVersion to 28
  * Additionally, need to use permissions for Android and iOS
  * more info about that is at https://pub.dartlang.org/packages/local_auth#-readme-tab-
 */

class LocalAuth extends StatefulWidget {
  @override
  _LocalAuthState createState() => _LocalAuthState();
}

class _LocalAuthState extends State<LocalAuth> {
  //creating an instance of LocalAuthentication
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  //vars to hold some default values
  bool _canCheckBiometric = false;
  String _authorizedOrNot = "Not Authorized";

  //holds a list of bioMetric options
  List<BiometricType> _availableBiometricTypes = List<BiometricType>();

  //returns true if bioMetric options are available
  Future<void> _checkBiometric() async {
    bool bioMetricFlag = false;

    try {
      bioMetricFlag = await _localAuthentication.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }

    //making sure it's mounted before calling setState
    if (!mounted) return;

    setState(() {
      _canCheckBiometric = bioMetricFlag;
    });
  }

  //returns a list of available BioMetric options
  Future<void> _getListOfBioMetrics() async {
    List<BiometricType> listOfBiometrics;

    try {
      listOfBiometrics = await _localAuthentication.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }

    //making sure it's mounted before calling setState
    if (!mounted) return;

    setState(() {
      _availableBiometricTypes = listOfBiometrics;
    });
  }

  //does the bioMetric Authorization operation
  Future<void> _authorizeNow() async {
    bool isAuthorized = false;

    try {
      isAuthorized = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Please authenticate",
        useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print(e);
    }

    //making sure it's mounted before calling setState
    if (!mounted) return;

    setState(() {
      isAuthorized == true
          ? _authorizedOrNot = "Authorized"
          : debugPrint("not authgorized");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter local auth"),
      ),
      //UI elements and function calls
      body: ListView(
        children: <Widget>[
          Text("Can we check Biometric: $_canCheckBiometric"),
          RaisedButton(
              child: Text("Check Biometric"), onPressed: _checkBiometric),
          Text("List of Biometric: ${_availableBiometricTypes.toString()}"),
          RaisedButton(
              child: Text("Get list of biometric types"),
              onPressed: _getListOfBioMetrics),
          Text("Authorized: $_authorizedOrNot"),
          RaisedButton(child: Text("Authorize now"), onPressed: _authorizeNow),
        ],
      ),
    );
  }
}
