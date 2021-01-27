import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:alco_safe/ui/myclip.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';

///////////////////////////////////////////////////////////////////////////
///// MODELS //////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

class Assetmobil {
  String merk;
  String model;
  String tipe;
  String bahan_bakar;
  String transmisi;
  String deskripsi;
  String url_foto_mobil;

  Assetmobil(
      {this.merk,
      this.model,
      this.tipe,
      this.bahan_bakar,
      this.transmisi,
      this.deskripsi,
      this.url_foto_mobil});

  factory Assetmobil.fromJson(Map<String, dynamic> json) {
    return Assetmobil(
        merk: json['merk'],
        model: json['model'],
        tipe: json['tipe'],
        bahan_bakar: json['bahan_bakar'],
        transmisi: json['transmisi'],
        deskripsi: json['deskripsi'],
        url_foto_mobil: json['url_foto_mobil']);
  }
}

///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

class Scan extends StatefulWidget {
  const Scan({Key key}) : super(key: key);

  @override
  _ScanState createState() => _ScanState();
}

Widget button(String text, Color color) {
  return Padding(
    padding: EdgeInsets.all(12.5),
    child: Container(
      width: 200,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(const Radius.circular(25.0)),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    ),
  );
}

///////////////////////////////////////////////////////////////////////////
//// MAIN API URL & FETCH DATA ////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

class _ScanState extends State<Scan> {
  final String apiURL =
      'https://api.par-mobile.com/sewaja/readAssetMobilJson-2.php';

  Future<List<Assetmobil>> fetchAssets() async {
    var response = await http.get(apiURL);

    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();

      List<Assetmobil> assetList = items.map<Assetmobil>((json) {
        return Assetmobil.fromJson(json);
      }).toList();

      return assetList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }

  navigateToNextActivity(BuildContext context, String dataHolder) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SecondScreenState(dataHolder.toString())));
  }

///////////////////////////////////////////////////////////////////////////
///// MAIN PAGE WIDGET ////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {


    return FutureBuilder<List<Assetmobil>>(
      future: fetchAssets(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return Scaffold(
          body:



          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Container(

              child: Column(
                children: [
                  Container(
                    height: 120,
                    color: Colors.blueAccent,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18.0, 10.0, 0.0, 0.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Hot Offers", style: GoogleFonts.roboto(fontSize: 25, fontWeight: FontWeight.bold),)),
                  ),

/////////////////////////////////////////////////////////////////////////////////////////////
//////  Card ////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////


                  Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
                    child: SizedBox(
                      height: 500,
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 8.0 / 9.0,

                        children: snapshot.data
                            .map((data) => Container(
                          child: Column(
                            children: <Widget>[
                              GestureDetector(
                                  onTap: () {
                                    navigateToNextActivity(
                                        context, data.merk);
                                  },
                                  child:

                                  Card(
                                    clipBehavior: Clip.antiAlias,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        AspectRatio(
                                          aspectRatio: 18.0 / 11.0,
                                          child: Image.network(
                                              data.url_foto_mobil),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(10.0, 12.0, 10.0, 8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(data.merk),
                                              SizedBox(height: 8.0),
                                              Text(data.model),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                              ),
                              Divider(color: Colors.black),
                            ],
                          ),
                        ))
                            .toList(),
                      ),
                    ),
                  ),



                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

///////////////////////////////////////////////////////////////////////////
///// Second Page Route ///////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

class SecondScreenState extends StatefulWidget {
  final String merk;

  SecondScreenState(this.merk);

  @override
  State<StatefulWidget> createState() {
    return SecondScreen(this.merk);
  }
}

class SecondScreen extends State<SecondScreenState> {
  final String merk;

  SecondScreen(this.merk);

///////////////////////////////////////////////////////////////////////////
//// second page API URL & FETCH DATA /////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

  String _platformVersion = 'Unknown';

  var url = 'https://api.par-mobile.com/sewaja/getAssetMobilJson-2.php';

  Future<List<Assetmobil>> fetchAssets() async {
    var data = {'merk': merk};

    var response = await http.post(url, body: json.encode(data));

    if (response.statusCode == 200) {
      print(response.statusCode);

      final items = json.decode(response.body).cast<Map<String, dynamic>>();

      List<Assetmobil> assetList = items.map<Assetmobil>((json) {
        return Assetmobil.fromJson(json);
      }).toList();

      return assetList;
    } else {
      throw Exception('Failed to load data from Server.');
    }
  }


  _launch(url) async {
    if(await canLaunch(url)) {
      await launch(url);
    }else {
      print("not suppported");
    }
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterOpenWhatsapp.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

///////////////////////////////////////////////////////////////////////////
// DETAIL ITEM ////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////
// DETAIL ITEM ////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
                title: Text(
                  'Showing Selected Item Details',
                  style: GoogleFonts.roboto(fontSize: 20),
                ),
                automaticallyImplyLeading: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context, false),
                )),
            body:
            Container(
              child: Stack(
                children: [
                  ClipPath(
                    clipper: MyClipper(),
                    child: Container(
                      height: 100.0,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                      ),
                    ),

                  ),

            FutureBuilder<List<Assetmobil>>(
                    future: fetchAssets(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Center(child: CircularProgressIndicator());


                      return Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 70.0, 10.0, 0.0),
                        child: Card(
                          child: ListView(
                            children: snapshot.data
                                .map((data) => Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                  ),
                              child: Column(
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              print(data.merk);
                                            },
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
/////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////// No STNK ////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////

                                                  Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 0, 5),
                                                      child: Center(
                                                        child: Container(
                                                          child: Align(
                                                            alignment:
                                                                Alignment.center,
                                                            child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5.0),
                                                                child:
                                                                    Image.network(
                                                                  data.url_foto_mobil,
                                                                  width: 400,
                                                                  height: 250,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )),
                                                          ),
                                                        ),
                                                      )),

/////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////// No STNK ////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////

                                                  Container(
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                130, 0, 0, 5),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                children: [
                                                                  ListTile(
                                                                    title: Text(
                                                                        data.merk,
                                                                        style: GoogleFonts.roboto(
                                                                            fontSize:
                                                                                17,
                                                                            fontStyle:
                                                                                FontStyle.normal)),
                                                                    subtitle: Text(
                                                                        data.model,
                                                                        style: GoogleFonts
                                                                            .roboto(
                                                                          fontSize:
                                                                              22,
                                                                          textStyle:
                                                                              TextStyle(
                                                                                  color: Colors.black),
                                                                        )),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                  ),


/////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////// No Rangka //////////////////////
/////////////////////////////////////////////////////////////////////////////////////////

                                                  Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 0, 5),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              children: [
                                                                ListTile(
                                                                  title: Text(
                                                                      'Tipe ' + data.tipe,
                                                                      style: GoogleFonts.roboto(
                                                                          fontSize:
                                                                              22)),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      )),

/////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////// No Mesin ///////////////////////
/////////////////////////////////////////////////////////////////////////////////////////

                                                  Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 0, 5),
                                                      child: Row(
                                                        children: [

                                                          Expanded(
                                                            child: Column(
                                                              children: [
                                                                ListTile(
                                                                  title: Text(
                                                                      'Bahan Bakar',
                                                                      style: GoogleFonts.roboto(
                                                                          fontSize:
                                                                              17)),
                                                                  subtitle: Text(
                                                                      data
                                                                          .bahan_bakar,
                                                                      style: GoogleFonts.roboto(
                                                                          fontSize:
                                                                              22,
                                                                          textStyle:
                                                                              TextStyle(color: Colors.black))),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      )),

/////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////// No Mesin ///////////////////////
/////////////////////////////////////////////////////////////////////////////////////////

                                                  Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 0, 5),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              children: [
                                                                ListTile(
                                                                  title: Text(
                                                                      'Transmisi',
                                                                      style: GoogleFonts.roboto(
                                                                          fontSize:
                                                                              17)),
                                                                  subtitle: Text(
                                                                      data
                                                                          .transmisi,
                                                                      style: GoogleFonts.roboto(
                                                                          fontSize:
                                                                              22,
                                                                          textStyle:
                                                                              TextStyle(color: Colors.black))),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                  /////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////// No Mesin ///////////////////////
/////////////////////////////////////////////////////////////////////////////////////////

                                                  Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 0, 5),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              children: [
                                                                ListTile(
                                                                  title: Text(
                                                                      'Deskripsi',
                                                                      style: GoogleFonts.roboto(
                                                                          fontSize:
                                                                              17)),
                                                                  subtitle: Text(
                                                                      data
                                                                          .deskripsi,
                                                                      style: GoogleFonts.roboto(
                                                                          fontSize:
                                                                              22,
                                                                          textStyle:
                                                                              TextStyle(color: Colors.black))),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      )),

/////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////// refNumberQrCode //////////////////
/////////////////////////////////////////////////////////////////////////////////////////

                                                  Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 0, 5),
                                                      child: Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    20.0,
                                                                    10.0,
                                                                    0.0,
                                                                    0.0),
                                                            child: Container(
                                                              width: 350,
                                                              height: 50,
                                                              child:
                                                                  MaterialButton(
                                                                onPressed: (){
                                                                  FlutterOpenWhatsapp.sendSingleMessage("6283879204749", "Hello");
                                                                },
                                                                child: Text(
                                                                  "Pesan Mobil",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color: Colors
                                                                    .blueAccent,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      )),

/////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////// refNumberQrCode //////////////////
/////////////////////////////////////////////////////////////////////////////////////////
                                                ]),
                                          )
                                        ],
                                      ),
                                ))
                                .toList(),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )));
  }
}
