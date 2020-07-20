import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_style/discounts.dart';


import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';


class DiscountDisplayState extends State<DiscountDisplay> {
  var _discounts = <Discount>[];
  var now = new DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadDiscounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        padding: EdgeInsets.only(top: 70.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
        Flexible(
          child: new Container(
            margin: const EdgeInsets.only(bottom: 50.0),
            child: Text("Vos remises :",
                  textAlign: TextAlign.center, 
                  style: GoogleFonts.abel( 
                    textStyle: TextStyle(fontSize: 65.0, fontWeight: FontWeight.bold, color: Colors.white))
            ),
          )
        ),
        Flexible(child: ListView.builder(
          itemCount: _discounts.length * 2,
          itemBuilder: (BuildContext context, int position) {
            if (position.isOdd) return Divider();

            final index = position ~/ 2;

            return _buildRow(index);
          }))
          ],
          ),
      ),
    );
  }
//On construit les lignes de l'application
  Widget _buildRow(int i) {
    return Container(
        padding: const EdgeInsets.all(16.0),
        decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.all(const Radius.circular(20.0),
              )
                ),
          child: _getListTile(i)
    );
  }
  //On récupére les valeurs en cache
  _loadDiscounts() async {
    final prefs = await SharedPreferences.getInstance();

    // Try reading data from the counter key. If it doesn't exist, return 0.
    List<String> discounts = prefs.getStringList(('discount'));
    if (discounts == null) {
      setState(() {
        _showDialog();
      });
    } else {
      setState(() {
      for (String i in discounts) {
        var details = i.split('/');
        var date = DateTime.parse(details[1]);
        final discount = Discount(details[0], date, details[2]);
        _discounts.add(discount);
      }
    });
    }
  }

  Widget _getListTile(i){
    if (_discounts[i].date.isAfter(now)) {
      return ListTile(
          //On récupére les 3 valeurss
            title: Text("${_discounts[i].code}", style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
            subtitle: Text("${_discounts[i].value}", style: const TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold)),
            trailing: Text("${_discounts[i].date.toString().substring(0,10)}", style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            leading: Icon(Icons.attach_money, color: Colors.green ,size: 40.0,
            )
          );
    } else {
      return ListTile(
          //On récupére les 3 valeurss
            title: Text("${_discounts[i].code}", style: const TextStyle(fontSize: 28.0, color: Colors.red, fontWeight: FontWeight.bold)),
            subtitle: Text("${_discounts[i].value}", style: const TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold)),
            leading: Icon(Icons.attach_money, color: Colors.red ,size: 40.0),
            trailing: new Container(
              width: 50,
              child: new Stack(
              children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.cancel, 
                  color: Colors.red,
                  size: 40.0,),
                onPressed: () => _deleteDiscount(_discounts[i].code),
            ))
          ]
        )
      )
      );
    }
  }

  void _deleteDiscount(String code) async{
    log("Ca marche");
  }

  // On affiche une pop up si aucune remise n'est en cache
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Attention"),
          content: new Text("Vous n'avez pas encore de promotions enregistrées."),
          actions: <Widget>[
            //On incrémentes le bouton de fermeture
            new FlatButton(
              child: new Text("Retour"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                  );
              },
            ),
          ],
        );
      },
    );
  }
}

class DiscountDisplay extends StatefulWidget {
  @override
  createState() => DiscountDisplayState();
}




