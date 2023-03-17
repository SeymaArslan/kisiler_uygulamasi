import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kisiler_uygulamasi/KisiDetaySayfa.dart';
import 'package:kisiler_uygulamasi/KisiKayitSayfa.dart';
import 'package:kisiler_uygulamasi/Kisiler.dart';
import 'package:kisiler_uygulamasi/Kisilerdao.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: Anasayfa(),
    );
  }
}

class Anasayfa extends StatefulWidget {

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {

  // arama işlemleri için değişkenler
  bool aramaYapiliyorMu = false;
  String aramaKelimesi = "";

  Future<List<Kisiler>> aramaYap(String aramaKelimesi) async{
    var kisilerListesi = await Kisilerdao().kisiArama(aramaKelimesi);
    return kisilerListesi;
  }

/*
  Future<List<Kisiler>> tumKisiler() async{
    var kisilerListesi = <Kisiler>[];

    var k1 = Kisiler(1, "Ece", "05379993322");
    var k2 = Kisiler(2, "Leyla", "05379993322");
    var k3 = Kisiler(3, "Sema", "05379993322");

    kisilerListesi.add(k1);
    kisilerListesi.add(k2);
    kisilerListesi.add(k3);

    return kisilerListesi;
  }
*/

  Future<List<Kisiler>> tumKisiler() async{
    var kisilerListesi = await Kisilerdao().tumKisiler();
    return kisilerListesi;
  }
  
  /*
  Future<void> sil(int kisi_id) async{
    print("$kisi_id silindi.");
    setState(() {
    });
  } */

  Future<void> sil(int kisi_id) async{
    await Kisilerdao().kisiSil(kisi_id);
    setState(() {
    });
  }
  
  Future<bool> uygulamayiKapat() async{
    await exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            uygulamayiKapat();
          },
        ),
        title: aramaYapiliyorMu ?
            TextField(
              decoration: InputDecoration(hintText: "Arama için bir şey yazın"),
              onChanged: (aramaSonucu){
                print("Arama sonucu : $aramaSonucu");
                setState(() {
                  aramaKelimesi = aramaSonucu;
                });
              },
            )
            : Text("Kişiler Uygulaması"),
        actions: [
          aramaYapiliyorMu ?
            IconButton(
              onPressed: (){
                setState(() {
                  aramaYapiliyorMu = false;
                  aramaKelimesi = "";
                });
              },
                icon: Icon(Icons.cancel_outlined, color: Colors.deepOrangeAccent,)
            )
            :IconButton(
              onPressed: (){
                setState(() {
                  aramaYapiliyorMu = true;
                });
              },
              icon: Icon(Icons.search, color: Colors.black,),
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: uygulamayiKapat,
        child: FutureBuilder<List<Kisiler>>(
          future: aramaYapiliyorMu ? aramaYap(aramaKelimesi): tumKisiler(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              var kisilerListesi = snapshot.data;
              return ListView.builder(
                itemCount: kisilerListesi!.length,
                itemBuilder: (context, index){  // döngü gibi olan
                  var kisi = kisilerListesi[index];
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => KisiDetaySayfa(kisi: kisi,)));
                    },
                    child: Card(
                      child: SizedBox( height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(kisi.kisi_ad, style: TextStyle(fontWeight: FontWeight.bold),),
                            Text(kisi.kisi_tel,),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.grey,),
                              onPressed: (){
                                 sil(kisi.kisi_id);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else  {
              return Center();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => KisiKayitSayfa()));
        },
        tooltip: "Kişi Ekle",
        child: const Icon(Icons.add),
      ),
    );
  }
}
