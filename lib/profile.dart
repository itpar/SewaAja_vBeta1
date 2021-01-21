//import 'dart:html';

import 'package:alco_safe/scan.dart';
import 'package:alco_safe/ui/background.dart';

//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:spring_button/spring_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:alco_safe/ui/myseparator.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

enum LoginStatus { signedOut, signedIn }

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    getPref();
    super.initState();
  }

  BuildContext ptx;
  bool tes = true;

  var value;
  String name;
  LoginStatus _loginStatus = LoginStatus.signedIn;

  String username = "", email = "", fname = "", sname = "", cardno = "";
  String link = "";

  Widget background(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return new DiagonallyCutColoredImage(
      new Image.asset(
        'assets/images/pattern.png',
        width: screenWidth,
        height: 280.0,
        fit: BoxFit.cover,
      ),
      color: const Color(0xFF1280C4),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 90,
      backgroundColor: Colors.white,
      child: new CircleAvatar(
        backgroundImage: new NetworkImage(
            "http://api.par-mobile.com/cekaja/users/" + username + ".jpg"),
        radius: 80.0,
      ),
    );
  }

  getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      value = prefs.getInt("value");
      name = prefs.getString("name");

      _loginStatus = value == 1 ? LoginStatus.signedIn : LoginStatus.signedOut;
    });
  }

  Future<bool> getInfo() async {
    final res =
        await http.post("http://api.par-mobile.com/cekaja/profile.php", body: {
      "name": name,
    });

    var lis = json.decode(res.body);
    username = lis['username'];
    fname = lis['fname'];
    sname = lis['sname'];
    cardno = lis['cardno'];
    email = lis['email'];

    link = "http://api.par-mobile.com/cekaja/users/" + username + ".jpg";

    // only for debug
    print(username);
    print(fname);
    print(sname);
    print(cardno);
    print(email);
    print(link);

    return tes;
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.setString("name", null);
      preferences.commit();
      preferences.clear();

      _loginStatus = LoginStatus.signedOut;
      Navigator.of(ptx).pushReplacementNamed("/login");
    });
  }

  Widget run() {
    return FutureBuilder(
      future: getInfo(),
      // ignore: missing_return
      builder: (BuildContext context, snapshot) {
        if (snapshot.data.toString() == "true") {
          return


            Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  background(context),
                  Center(
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 00.0)),
                        Column(
                          children: [
                            Padding(padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 20.0)),
                            Text(
                              fname + " " + sname,
                              style: GoogleFonts.roboto(
                                  fontSize:
                                  29,
                                fontWeight: FontWeight.bold,
                                  textStyle:
                                  TextStyle(color: Colors.white)),
                            ),
                            Padding(padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0)),
                            _buildAvatar(),
                            SizedBox(
                              width: 1,
                              height: 15,
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 1,
                height: 10,
              ),
              Card(
                child: Column(
                  children: [
                    Flex(direction: Axis.vertical,
                      children: [
                        const MySeparator(color: Colors.grey),
                        ListTile(
                          title: Text("E-Mail Adress",
                              style: GoogleFonts.roboto(
                                  fontSize:
                                  17)),
                          subtitle: Text(email,
                              style: GoogleFonts.roboto(
                              fontSize:
                              22,
                              textStyle:
                              TextStyle(color: Colors.black))),
                        ),
                        const MySeparator(color: Colors.grey),
                        ListTile(
                          title: Text("NIK",
                              style: GoogleFonts.roboto(
                                  fontSize:
                                  17)),
                          subtitle: Text(cardno,
                              style: GoogleFonts.roboto(
                                  fontSize:
                                  22,
                                  textStyle:
                                  TextStyle(color: Colors.black))),
                        ),
                        const MySeparator(color: Colors.grey),
                        ListTile(
                          title: Text("Username",
                              style: GoogleFonts.roboto(
                                  fontSize:
                                  17)),
                          subtitle: Text(username,
                              style: GoogleFonts.roboto(
                                  fontSize:
                                  22,
                                  textStyle:
                                  TextStyle(color: Colors.black))),
                        ),
                        const MySeparator(color: Colors.grey),
                        //ListTile(
                          //title: Text("Username",
                            //  style: GoogleFonts.roboto(
                              //    fontSize:
                                //  17)),
                       //   subtitle: Text(username,
                         //     style: GoogleFonts.roboto(
                           //       fontSize:
                             //     22,
                               //   textStyle:
                                 // TextStyle(color: Colors.black))),
                       // ),
                      ],),

                  ],
                ),
              ),
            ],
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 1,
                height: 10,
              ),
              Text(
                username,
                style: new TextStyle(
                    fontSize: 27.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
            ],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ptx = context;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text("User Profile"),
        elevation: 0,
        backgroundColor: const Color(0xFF1280C4).withOpacity(0.8),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: <Widget>[
            run(),
            SpringButton(
              SpringButtonType.OnlyScale,
              button(
                "Sign out",
                Color(0xFF1280C4).withOpacity(0.8),
              ),
              onTapDown: (_) => signOut(),
            ),
          ],
        )),
      ),
    );
  }
}
