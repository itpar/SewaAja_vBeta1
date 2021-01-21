import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:alco_safe/ui/myclip.dart';

///////////////////////////////////////////////////////////////////////////
///// MODELS //////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

class Assetmobil {
  int mobilid;
  String mobilnoPolisi;
  int mobilnoSAP;
  String mobilnoRangka;
  String mobilnoMesin;
  String mobilketerangan;
  String mobilstatus;
  String mobilrefNumberQrCode;

  Assetmobil({
    this.mobilid,
    this.mobilnoPolisi,
    this.mobilnoSAP,
    this.mobilnoRangka,
    this.mobilnoMesin,
    this.mobilketerangan,
    this.mobilstatus,
    this.mobilrefNumberQrCode
  });

  factory Assetmobil.fromJson(Map<String, dynamic> json) {
    return Assetmobil(
        mobilid: json['id'],
        mobilnoPolisi: json['noPolisi'],
        mobilnoRangka: json['noRangka'],
        mobilnoMesin: json['noMesin'],
        mobilketerangan: json['keterangan'],
        mobilstatus: json['status'],
        mobilrefNumberQrCode: json['refNumberQrCode'],
        mobilnoSAP: json['noSAP']);
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
      'https://api.par-mobile.com/cekaja/readAssetMobilJson-2.php';
  bool _ready = false;

//  List<dynamic> _lstDataSiswa = [];
//  String _statusText = "";
  TextEditingController _txtSearch = TextEditingController();
  bool _flagAllowSearch = true;

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
          appBar: AppBar(
            title: Text("CekAja"),
            backgroundColor: Colors.blueAccent,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                      height: 50,
                      child: TextField(
                        controller: _txtSearch,
                        onChanged: (filterText) {
                          //. supaya efektif pencarianya, pakai timeout bukan per karakter
                          if (_flagAllowSearch == true) {
                            _flagAllowSearch = false;

                            Future.delayed(Duration(milliseconds: 500), () {
                              _flagAllowSearch = true;
                              setState(() {
                                _ready = false;
                              });
                              //                        _loadData(_txtSearch.text).then((d) {
                              //                          setState(() {
                              //                            _ready = true;
                              //                          });
                              //                        });
                            });
                          }
                          //                      _scanner();
                        },
                        style: TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                          prefixIcon: Icon(Icons.search),
                          prefixStyle: TextStyle(color: Colors.blue),
                          hintText: "Cari Kendaraan ..",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.red.withOpacity(0.2),
                                width: 32.0),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0)),
                          ),
                        ),

                        //focusedBorder: OutlineInputBorder(
                        //  borderSide: BorderSide(
                        //    color: Colors.red.withOpacity(0.2), width: 32.0),
                        //borderRadius: BorderRadius.circular(0.0)
                        // ),
                      )),
                  SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        children: snapshot.data
                            .map((data) => Container(
                                  child: Column(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          navigateToNextActivity(
                                              context, data.mobilnoPolisi);
                                        },
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      20, 5, 0, 5),
                                                  child: Text(data.mobilnoPolisi,
                                                      style: GoogleFonts.roboto(
                                                          fontSize: 20),
                                                      textAlign: TextAlign.left))
                                            ]),
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
  final String noPolisi;

  SecondScreenState(this.noPolisi);

  @override
  State<StatefulWidget> createState() {
    return SecondScreen(this.noPolisi);
  }
}

class SecondScreen extends State<SecondScreenState> {
  final String noPolisi;

  SecondScreen(this.noPolisi);

///////////////////////////////////////////////////////////////////////////
//// second page API URL & FETCH DATA /////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

  var url = 'https://api.par-mobile.com/cekaja/getAssetMobilJson-2.php';

  Future<List<Assetmobil>> fetchAssets() async {
    var data = {'noPolisi': noPolisi};

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
            body: Container(
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
                                .map((data) => Column(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            print(data.mobilnoPolisi);
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
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Icon(
                                                            Icons
                                                                .receipt_outlined,
                                                            size: 50.0, color: Colors.blueAccent,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              ListTile(
                                                                title: Text(
                                                                    'No. Polisi',
                                                                    style: GoogleFonts.roboto(
                                                                        fontSize:
                                                                            17,
                                                                        fontStyle:
                                                                            FontStyle.normal)),
                                                                subtitle: Text(
                                                                    data
                                                                        .mobilnoPolisi,
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

/////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////// No Rangka //////////////////////
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
                                                              .all(8.0),
                                                          child: Icon(
                                                            Icons
                                                                .my_library_books,
                                                            size: 50.0, color: Colors.blueAccent,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              ListTile(
                                                                title: Text(
                                                                    'No. SAP',
                                                                    style: GoogleFonts.roboto(
                                                                        fontSize:
                                                                        17)),
                                                                subtitle: Text(
                                                                    data.mobilnoSAP.toString(),
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
//////////////////////////////////////////////////////// No Rangka //////////////////////
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
                                                                  .all(8.0),
                                                          child: Icon(
                                                            Icons
                                                                .time_to_leave_outlined,
                                                            size: 50.0, color: Colors.blueAccent
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              ListTile(
                                                                title: Text(
                                                                    'No. Rangka',
                                                                    style: GoogleFonts.roboto(
                                                                        fontSize:
                                                                            17)),
                                                                subtitle: Text(
                                                                    data
                                                                        .mobilnoRangka,
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
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Icon(
                                                            Icons.time_to_leave,
                                                            size: 50.0, color: Colors.blueAccent,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              ListTile(
                                                                title: Text(
                                                                    'No. Mesin',
                                                                    style: GoogleFonts.roboto(
                                                                        fontSize:
                                                                            17)),
                                                                subtitle: Text(
                                                                    data
                                                                        .mobilnoMesin,
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
//////////////////////////////////////////////////////// Keterangan /////////////////////
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
                                                                  .all(8.0),
                                                          child: Icon(
                                                            Icons
                                                                .dehaze_rounded,
                                                            size: 50.0, color: Colors.blueAccent,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              ListTile(
                                                                title: Text(
                                                                    'Keterangan',
                                                                    style: GoogleFonts.roboto(
                                                                        fontSize:
                                                                            17)),
                                                                subtitle: Text(
                                                                    data
                                                                        .mobilketerangan,
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
//////////////////////////////////////////////////////// Status /////////////////////////
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
                                                                  .all(8.0),
                                                          child: Icon(
                                                            Icons.padding,
                                                            size: 50.0, color: Colors.blueAccent,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              ListTile(
                                                                title: Text(
                                                                    'Status',
                                                                    style: GoogleFonts.roboto(
                                                                        fontSize:
                                                                            17)),
                                                                subtitle: Text(
                                                                    data
                                                                        .mobilstatus,
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
                                                                  .all(8.0),
                                                          child: Icon(
                                                            Icons.qr_code_sharp,
                                                            size: 50.0, color: Colors.blueAccent,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            children: [
                                                              ListTile(
                                                                title: Text(
                                                                    'QR Ref',
                                                                    style: GoogleFonts.roboto(
                                                                        fontSize:
                                                                            17)),
                                                                subtitle: Text(
                                                                    data
                                                                        .mobilrefNumberQrCode,
                                                                    style: GoogleFonts.roboto(
                                                                        fontSize:
                                                                            25,
                                                                        textStyle:
                                                                            TextStyle(color: Colors.black))),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                              ]),
                                        )
                                      ],
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
