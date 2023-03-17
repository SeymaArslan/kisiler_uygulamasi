import 'package:flutter/material.dart';
import 'package:kisiler_uygulamasi/Kisiler.dart';
import 'package:kisiler_uygulamasi/Kisilerdao.dart';
import 'package:kisiler_uygulamasi/main.dart';

class KisiDetaySayfa extends StatefulWidget {
  Kisiler kisi;
  KisiDetaySayfa({required this.kisi});

  @override
  State<KisiDetaySayfa> createState() => _KisiDetaySayfaState();
}

class _KisiDetaySayfaState extends State<KisiDetaySayfa> {

  var tfKisiAd = TextEditingController();
  var tfKisiTel = TextEditingController();

  /*
  Future<void> guncelle(int kisi_id, String kisi_ad, String kisi_tel) async{
    print("$kisi_ad - $kisi_tel güncellendi.");
    Navigator.push(context, MaterialPageRoute(builder: (context) => Anasayfa()));
  }*/


  Future<void> guncelle(int kisi_id, String kisi_ad, String kisi_tel) async{
   await Kisilerdao().kisiGuncelle(kisi_id, kisi_ad, kisi_tel);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Anasayfa()));
  }

  @override
  void initState() {
    super.initState();
    var kisi = widget.kisi;
    tfKisiAd.text = kisi.kisi_ad; // sayesinde sayfa açıldığı anda textfield içerisinde gelen verileri göreceğiz.
    tfKisiTel.text = kisi.kisi_tel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kişi Detay"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 50, right: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextField(
                controller: tfKisiAd,
                decoration: InputDecoration(hintText: "Kişi Ad"),
              ),
              TextField(
                controller: tfKisiTel,
                decoration: InputDecoration(hintText: "Kişi Tel"),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          guncelle(widget.kisi.kisi_id, tfKisiAd.text, tfKisiTel.text);
        },
        tooltip: "Kişi Güncelle",
        icon: Icon(Icons.update),
        label: Text("Güncelle"),
      ),
    );
  }
}
