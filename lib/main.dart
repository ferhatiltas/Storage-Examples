import 'package:flutter/material.dart';
import 'package:storage_examples/model/ogrenci.dart';
import 'package:storage_examples/shared_preferences.dart';
import 'package:storage_examples/sqflite_islemleri.dart';
import 'package:storage_examples/utils/database_helper.dart';

import 'dosya_islemleri.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: "Storage Examples",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SqfliteIslemleri(),
    );
  }


}
