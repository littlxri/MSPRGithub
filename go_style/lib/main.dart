import 'dart:async';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'discount_display.dart';
import 'dart:convert';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    ));

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  String result;

  @override
  void initState() {
    super.initState();

    result = "Obtennez de nouvelles réductions en scannant les réductions Go_Style sur nos support publicitaires !";
  }
  
  Future _scanQR() async {
    try {
      //On récupère le code en le scannant
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = "Traitement ...";
        //La fonction récupère les données par l'API
        _getData(qrResult);
        
      });
      //On gère les erreurs du scan
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "La caméra n'a pas été autotrisée.";
        });
      } else {
        setState(() {
          result = "Erreur inconnue $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "Vous avez pressé le bouton retour, rien n'as été scanné";
      });
    } catch (ex) {
      setState(() {
        result = "Erreur inconnue $ex";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child:new Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: new Container(
                margin: EdgeInsets.only(top: 70.0),
                child: Text(
                  "Go Style",
                  textAlign: TextAlign.center, 
                  style: GoogleFonts.abel( 
                    textStyle: TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold, color: Colors.white))
            ),
            )
          ),
        //Bouton pour scanner
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended( 
              heroTag: null,
              icon: Icon(Icons.camera_alt),
              label: Text("Scanner"),
                onPressed: _scanQR,
            )
          ),
        //Bouton pour voir l'historique
          Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton.extended(
                heroTag: null,
                icon: Icon(Icons.stars),
                label: Text("Vos remises"),
                backgroundColor: Colors.pink,
                onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DiscountDisplay()),
                  );
              },
              ),
          ),
          //Texte du millieu
          Align(
            alignment: Alignment.center,
              child: new Container(
                height: 350,
                width: 350,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.all(const Radius.circular(20.0),
              )
                ),
                child: new Stack(
                  children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      result,
                      textAlign: TextAlign.center, 
                      style: new TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                    ),
                  )
                ])
            )
          ),
        ],
      ), 
      )
    );
    }

  void _getData(code) async{
    //Appel a l'api
    var request = "http://a147ecdcbf9d.ngrok.io/QrCode/" + code;
    var response = await http.get(Uri.encodeFull(request));
    switch (response.statusCode) {
      // L'api a fonctionnée correctement
      case 200:
        setState(() {
          result = "Vous avez une réduction de "+jsonDecode(response.body)[0]['discount'].toString();
        });
        //On enregistre les données en cache
        SharedPreferences prefs = await SharedPreferences.getInstance();
        List<String> list = (prefs.getStringList('mylist') ?? List<String>());
        var entry = code + "/" + jsonDecode(response.body)[0]['date'].toString().substring(0, 10)+"/"+jsonDecode(response.body)[0]['discount'].toString();
        list.add(entry);
        await prefs.setStringList('discount', list);
        break;
      
      // L'api n'as pas trouvé de code
      case 404:
      setState(() {
        result = response.body;
        });
        break;

      // La promotion est dépassée
      case 500:
      setState(() {
        result = response.body;
        });
        break;
    }
  }
}



