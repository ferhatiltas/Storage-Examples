import 'package:flutter/material.dart';
import 'package:storage_examples/shared_preferences.dart';

import 'dosya_islemleri.dart';

void main() {
  runApp(MyApp ());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
     return MaterialApp(
       title: "Storage Examples",
       theme: ThemeData(primarySwatch: Colors.blue),
       home: DosyaISlemleri(),
     );
  }
}
