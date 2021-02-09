import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefKullanimi extends StatefulWidget {
  @override
  _SharedPrefKullanimiState createState() => _SharedPrefKullanimiState();
}

class _SharedPrefKullanimiState extends State<SharedPrefKullanimi> {
  String isim;
  int id;
  bool cinsiyet;
  var formKey = GlobalKey<FormState>();
  var mySharedPref;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((sp) {
      mySharedPref = sp;
    });
  }

  @override
  void dispose() {
    mySharedPref.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shared Pref"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onSaved: (deger) {
                    // girilen değeri isme ata
                    isim = deger;
                  },
                  decoration: InputDecoration(
                      labelText: "İsminizi Giriniz",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onSaved: (deger) {
                    // girilen değeri isme ata
                    id = int.parse(deger);
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "ID Giriniz",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadioListTile(
                  value: true,
                  groupValue: cinsiyet,
                  onChanged: (secildi) {
                    setState(() {
                      cinsiyet = secildi;
                    });
                  },
                  title: Text("Erkek"),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RadioListTile(
                  value: false,
                  groupValue: cinsiyet,
                  onChanged: (secildi) {
                    setState(() {
                      cinsiyet = secildi;
                    });
                  },
                  title: Text("Kadın"),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    onPressed: _ekle,
                    child: Text("Kaydet"),
                    color: Colors.green,
                  ),
                  RaisedButton(
                    onPressed: _goster,
                    child: Text("Göster"),
                    color: Colors.red,
                  ),
                  RaisedButton(
                    onPressed: _sil,
                    child: Text("Sil"),
                    color: Colors.yellowAccent,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _ekle() async {
    formKey.currentState.save();
    await (mySharedPref as SharedPreferences).setString("isim", isim);
    await (mySharedPref as SharedPreferences).setInt("id", id);
    await (mySharedPref as SharedPreferences).setBool("cinsiyet", cinsiyet);
  }

  void _goster() {
    print("Okunan İsim : "+(mySharedPref as SharedPreferences).getString("isim")??"NULLL");
    print("Okunan Id : "+(mySharedPref as SharedPreferences).getInt("id").toString()??"NULLL");
    print("Erkek mi : "+(mySharedPref as SharedPreferences).getBool("cinsiyet").toString()??"NULLL");
  }

  void _sil() {
    (mySharedPref as SharedPreferences).remove("isim");
    (mySharedPref as SharedPreferences).remove("id");
    (mySharedPref as SharedPreferences).remove("cinsiyet");

  }
}
