import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:storage_examples/model/ogrenci.dart';
import 'package:storage_examples/utils/database_helper.dart';

class SqfliteIslemleri extends StatefulWidget {
  @override
  _SqfliteIslemleriState createState() => _SqfliteIslemleriState();
}

class _SqfliteIslemleriState extends State<SqfliteIslemleri> {
  DatabaseHelper _databaseHelper;
  List<Ogrenci> tumOgrencileriListesi;
  bool aktiflik = false;
  var _controller = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  int tiklanilanOgrenciIndex;
  int tiklanilanOgrenciID;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tumOgrencileriListesi = List<Ogrenci>();
    _databaseHelper = DatabaseHelper(); // async olduğu için .then denilecek
    _databaseHelper.tumOgrenciler().then((tumOgrencileriTutanMapListesi) {
      for (Map okunanOgrenciMapi in tumOgrencileriTutanMapListesi) {
        tumOgrencileriListesi
            .add(Ogrenci.dbdenOkudugunMapiObjeyeDonustur(okunanOgrenciMapi));
      }
      print("db den gelen öğrenci sayısı : " +
          tumOgrencileriListesi.length.toString());
    }).catchError((onError) => print("hata : " + onError));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Sqflite Kullanımı"),
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(

                        controller: _controller,
                        validator: (kontrolEdilecekIsimDegeri) {
                          if (kontrolEdilecekIsimDegeri.length < 3) {
                            return "En az 3 karakter giriniz.";
                          } else
                            return null;
                        },
                        autofocus: false,
                        decoration: InputDecoration(
                          labelText: "Ogrenci ismini giriniz",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SwitchListTile(
                      title: Text("Aktif"),
                      value: aktiflik,
                      onChanged: (aktifMi) {
                        setState(() {
                          aktiflik = aktifMi;
                        });
                      },
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text("Kaydet"),
                    color: Colors.green,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _ogrenciEKle(Ogrenci(
                            _controller.text, aktiflik == true ? 1 : 0));
                      }
                    },
                  ),
                  RaisedButton(
                    child: Text("Güncelle"),
                    color: Colors.yellow,
                    onPressed: tiklanilanOgrenciID == null ? null : () {
                      if (_formKey.currentState.validate()) {
                        _ogrenciGuncelle(Ogrenci.withID(tiklanilanOgrenciID,
                            _controller.text, aktiflik == true ? 1 : 0));
                      }
                    },
                  ),
                  RaisedButton(
                    child: Text("Tüm Tabloyu Sil"),
                    color: Colors.red,
                    onPressed: () {
                      _tumTabloyuTemizle();
                    },
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: tumOgrencileriListesi.length,
                    itemBuilder: (context, index) {
                      print("şu liteye atanacak" +
                          tumOgrencileriListesi[index].toString());
                      return Card(
                        color: tumOgrencileriListesi[index].aktif == 1
                            ? Colors.green.shade200
                            : Colors.red.shade200,
                        child: ListTile(
                          onTap: () {
                            setState(() {
                              // listede tıklanılan ismi edittext içine at ki güncelleme yapalım
                              _controller.text =
                                  tumOgrencileriListesi[index].isim;
                              aktiflik = tumOgrencileriListesi[index].aktif == 1
                                  ? true
                                  : false;
                              tiklanilanOgrenciIndex = index;
                              tiklanilanOgrenciID=tumOgrencileriListesi[index].id;
                            });
                          },
                          title: Text(tumOgrencileriListesi[index].isim),
                          subtitle:
                              Text(tumOgrencileriListesi[index].id.toString()),
                          trailing: GestureDetector(
                            child: Icon(Icons.delete_rounded),
                            onTap: () {
                              _ogrenciSil(
                                  tumOgrencileriListesi[index].id, index);
                            },
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ));
  }

  void _ogrenciEKle(Ogrenci ogrenci) async {
    var eklenenYeniOgrenciID = await _databaseHelper.ogrenciEkle(ogrenci);
    ogrenci.id = eklenenYeniOgrenciID;
    if (eklenenYeniOgrenciID > 0) {
      setState(() {
        tumOgrencileriListesi.insert(0, ogrenci);
      });
    }
    _controller.text="";

  }

  void _tumTabloyuTemizle() async {
    var silinenElemanSayisi = await _databaseHelper.tumOgrenciTablosunuSil();
    if (silinenElemanSayisi > 0) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text(silinenElemanSayisi.toString() + " kayıt silindi."),
      ));
      setState(() {
        tumOgrencileriListesi.clear();
      });
    }
    tiklanilanOgrenciID=null;
  _controller.text="";
  }

  void _ogrenciSil(int dbdenSilinecekID, int listedenSilinecekID) async {
    var sonuc = await _databaseHelper.ogrenciSil(dbdenSilinecekID);
    if (sonuc == 1) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text("Kayıt silindi."),
      ));
      setState(() {
        tumOgrencileriListesi.removeAt(listedenSilinecekID);
      });
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text("Silerken Hata Oluştu."),
      ));
    }
    tiklanilanOgrenciID=null;
    _controller.text="";

  }

  void _ogrenciGuncelle(Ogrenci ogrenci) async {
    var sonuc = await _databaseHelper.ogrenciGuncelle(ogrenci);
    if (sonuc == 1) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        content: Text("Kayıt Güncellendi."),
      ));
      setState(() {
        tumOgrencileriListesi[tiklanilanOgrenciIndex] = ogrenci;
      });
    }
    _controller.text="";

  }
}
