import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DosyaISlemleri extends StatefulWidget {
  @override
  _DosyaISlemleriState createState() => _DosyaISlemleriState();
}

class _DosyaISlemleriState extends State<DosyaISlemleri> {
  var myTextController = TextEditingController();

  //olusturulacak dosyanın klasör yolu
  Future<String> get getKlasorYolu async {
    Directory klasor = await getApplicationDocumentsDirectory();
    debugPrint("Klasör Yolu : " + klasor.path);
    return klasor.path;
  }

  // dosya oluştur
  Future<File> get dosyaOlustur async {
    var olusturulacakDosyaYolu = await getKlasorYolu;
    return File(olusturulacakDosyaYolu + "/myDosya.txt");
  }

  // Dosya okuma işlemi
  Future<String> dosyaOku() async {
    try {
      var myDosya = await dosyaOlustur;
      String dosyaIcerigi = await myDosya.readAsStringSync();
      return dosyaIcerigi;
    } catch (exception) {
      return "Hata Çıktı : $exception";
    }
  }

  // Dosyaya yaz işlemi
  Future<File> dosyayaYaz(String yazilacakString) async{
    var myDosya =await dosyaOlustur;
    return myDosya.writeAsString(yazilacakString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dosya İşlemleri"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: myTextController,
                maxLines: 2,
                decoration: InputDecoration(
                    hintText: "Buraya yazılacak değerler dosyaya kaydedilecek"),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  onPressed: _dosyaOku,
                  color: Colors.orange,
                  child: Text("Dosyadan Oku"),
                ),
                RaisedButton(
                  onPressed: _dosyaYaz,
                  color: Colors.blue,
                  child: Text("Dosyaya YAz"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _dosyaOku() {

    dosyayaYaz(myTextController.text.toString());

  }

  void _dosyaYaz() async{
  //  debugPrint(await dosyaOku());
    dosyaOku().then((value) => debugPrint(value));
  }
}
