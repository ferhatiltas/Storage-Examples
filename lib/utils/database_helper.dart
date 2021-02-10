import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:storage_examples/model/ogrenci.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String _ogrenciTablo = "ogranci";
  String _columnId = "id";
  String _columnIsim = "isim";
  String _columnAktif = "aktif";

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._internal();
      print("DBHelper null çalıştı");
      return _databaseHelper;
    } else {
      print("DBHelper null değil var olan kullanıldı.");
      return _databaseHelper;
    }
  }

  DatabaseHelper._internal();

  Future<Database> _getDatabase() async {
    // metot çalışınca bakacak database null ise
    if (_database == null) {
      print("DB null çalıştı ");
      _database =
          await _initializeDatabase(); // null ise _initializeDatabase metoda gidip databseyi bulmaya çalışacak bulmazsa oluşturacak
      return _database;
    } else {
      print(
          "DB null değil var olan kullanıldı."); // zaten database varsa varol olan database döndürülecek

      return _database;
    }
  }

  _initializeDatabase() async {
    Directory klasor = await getApplicationDocumentsDirectory();
    String dbPath = join(klasor.path,
        "ogrenci.db"); // database yolu belirlenip database oluşturulacak
    print("DB Path : " + dbPath);

    var ogrenciDB = openDatabase(dbPath,
        version: 1,
        onCreate: _createDB); // _createDB ile database oluşturulacak
    return ogrenciDB;
  }

  Future<void> _createDB(Database db, int version) async {
    // verilen değerler ile tabloyu oluştur
    print("createDB çalıştı tablo oluşturulacak");
    await db.execute(
        "CREATE TABLE $_ogrenciTablo ($_columnId INTEGER PRIMARY KEY AUTOINCREMENT, $_columnIsim TEXT,$_columnAktif INTEGER)");
  }

  Future<int> ogrenciEkle(Ogrenci ogrenci) async {
    // başka sınıftan bu sınıfa erişip öğrenci  ekleyeceğiz

    var db =
        await _getDatabase(); // öğrenci eklerken databaseyi getirmeye çalışıyor _getDatabase metoduna git
    var sonuc = await db.insert(
        _ogrenciTablo, ogrenci.dbyeYazmakIcinMapeDonustur(),
        nullColumnHack: "$_columnId");
    print("Ogrenci db ye eklendi " + sonuc.toString());
    return sonuc;
  }

  Future<List<Map<String, dynamic>>> tumOgrenciler() async {
    // öğrenci bilgisi çek

    var db = await _getDatabase();
    var sonuc = await db.query(_ogrenciTablo,
        orderBy:
            '$_columnId DESC'); // columnID ye göre DESC sayesinde var olan öğrenciler azalan olarak sırala
    return sonuc;
  }

  Future<int> ogrenciGuncelle(Ogrenci ogrenci) async {
    //Tablodaki kişi bilgi guncelle id ye göre guncelle _columnId = ogrenci.id olanın bilgisini guncelle
    var db = await _getDatabase();
    var sonuc = await db.update(
        _ogrenciTablo, ogrenci.dbyeYazmakIcinMapeDonustur(),
        where: '$_columnId = ?', whereArgs: [ogrenci.id]);
    return sonuc;
  }

  Future<int> ogrenciSil(int id) async { // id ye göre silme işlemi de güncelleme gibi mantık aynı
    var db = await _getDatabase();
    var sonuc = await db
        .delete(_ogrenciTablo, where: '$_columnId = ?', whereArgs: [id]);
    return sonuc;
  }

  Future<int> tumOgrenciTablosunuSil() async {
    var db = await _getDatabase();
    var sonuc = await db
        .delete(_ogrenciTablo); // koşul vermezsen direk tüm tabloyu silecek
    return sonuc;
  }
}
