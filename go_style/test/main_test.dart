import 'package:go_style/discounts.dart';
import 'package:go_style/main.dart';
import 'package:http/testing.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';

class MockClient extends Mock implements http.Client {}
main() {
  group('_getdata', () {
    test('Vérifications que l\' API renvoie la bonne répons en fonction du code', () async {

      var response = await http.get(Uri.encodeFull("http://2a5380c19e7d.ngrok.io/QrCode/ETE"));
      switch (response.statusCode) {
        case 200 :
          expect( jsonDecode(response.body)[0]['discount'].toString(), "5%");
          break;
        case 404:
          expect(response.body, 'Cette remise n\' existe pas dans notre boutique');
          break;
        case 500:
          expect(response.body, 'La remise est périmée');
          break;
      }
    });
  });
}