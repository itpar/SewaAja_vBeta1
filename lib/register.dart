import 'dart:io';

import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';


class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String username, fname, sname, cardno, email, password, profilepic;
  Future<File> imagePic;
  File picture;
  final _keys = new GlobalKey<FormState>();
  BuildContext rtx;

  TextEditingController us = new TextEditingController();
  TextEditingController fn = new TextEditingController();
  TextEditingController sn = new TextEditingController();
  TextEditingController car = new TextEditingController();
  TextEditingController em = new TextEditingController();
  TextEditingController pass = new TextEditingController();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final forms = _keys.currentState;
    if (forms.validate()) {
      forms.save();
      save();
    }
  }
// =============================================================================
  pickImage(ImageSource source) {
    setState(() {
      imagePic = ImagePicker.pickImage(source: source);
    });
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: imagePic,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          profilepic = base64Encode(snapshot.data.readAsBytesSync());
          return SizedBox (
            width: 82,
            height: 82,
            child: Image.file(
              snapshot.data,
            ),
          );
        } else if (snapshot.error != null) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return SizedBox (
            width: 82,
            height: 82,
            child: CircleAvatar(
              radius: 55,
              backgroundColor: Color(0xffFDCF09),
              child: CircleAvatar(
                radius: 50,
                child: Image.asset('assets/images/avatar.png',
                ),
              ),
            ),
          );
        }
      },
    );
  }

// =============================================================================
  Future<List> save() async {
    final response = await http
        .post("http://api.par-mobile.com/sewaja/register.php", body: {
      "username": username,
      "fname": fname,
      "sname": sname,
      "cardno": cardno,
      "email": email,
      "password": password,
      "profilepic": profilepic,
    });

    String message = response.body;

    if (response.body == 'account created') {
      print(message);
      registerToast(message);

      Navigator.pop(rtx);
      registerToast("now Log in please");
      Navigator.of(rtx).pushReplacementNamed("/login");

    } else {
      print(message);
      registerToast(message);
    }
  }


  registerToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: const Color(0xFF1280C4).withOpacity(0.8),
        textColor: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    rtx = context;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.all(15.0),
          children: <Widget>[
            Center(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.white,
                child: Form(
                  key: _keys,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                        child: Text(
                          "Create Account",
                          style: TextStyle(color: const Color(0xFF1280C4).withOpacity(0.8), fontSize: 35.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Card(
                        elevation: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            showImage(),
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0)),
                              child: Text("add profile picture"),
                              textColor: const Color(0xFF1280C4).withOpacity(0.8),
                              color: Colors.white,
                              onPressed: () {
                                pickImage(ImageSource.gallery);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),

                      // Card showing auto- generated username
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          controller: us,
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Username Empty";
                            }
                          },
                          onSaved: (e) => username = e,
                          style: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.all_inclusive, color: const Color(0xFF1280C4).withOpacity(0.8)),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Username"),
                        ),
                      ),

                      //card for First name TextFormField
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          controller: fn,
                          validator: (e) {
                            if (e.isEmpty) {
                              return "First Name Empty";
                            }
                          },
                          onSaved: (e) => fname = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.blur_on, color: const Color(0xFF1280C4).withOpacity(0.8)),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "First Name"),
                        ),
                      ),

                      //card for surname TextFormField
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          controller: sn,
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Last Name Empty";
                            }
                          },
                          onSaved: (e) => sname = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 20, right: 15),
                              child: Icon(Icons.blur_on, color: const Color(0xFF1280C4).withOpacity(0.8)),
                            ),
                            contentPadding: EdgeInsets.all(18),
                            labelText: "Last Name",
                          ),
                        ),
                      ),

                      //card for card number TextFormField
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          controller: car,
                          validator: (e) {
                            if (e.isEmpty) {
                              return "NIK Empty";
                            }
                          },
                          onSaved: (e) => cardno = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(left: 20, right: 15),
                              child: Icon(Icons.view_week, color: const Color(0xFF1280C4).withOpacity(0.8)),
                            ),
                            contentPadding: EdgeInsets.all(18),
                            labelText: "NIK",
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),

                      //card for Email TextFormField
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          controller: em,
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Email Address Empty";
                            }
                          },
                          onSaved: (e) => email = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.email, color: const Color(0xFF1280C4).withOpacity(0.8)),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "E-Mail"),
                        ),
                      ),

                      //card for Password TextFormField
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          controller: pass,
                          obscureText: _secureText,
                          onSaved: (e) => password = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: showHide,
                                icon: Icon(_secureText
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              ),
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.vpn_key,
                                    color: const Color(0xFF1280C4).withOpacity(0.8)),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Password"),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(12.0),
                      ),

                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                            height: 44.0,
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Text(
                                  "Create Account",
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                textColor: Colors.white,
                                color: const Color(0xFF1280C4).withOpacity(0.8),
                                onPressed: () {
                                  check();
                                }),
                          ),
                          SizedBox(
                            height: 44.0,
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Text(
                                  "Login",
                                  style: TextStyle(fontSize: 18.0),
                                ),
                                textColor: const Color(0xFF1280C4).withOpacity(0.8),
                                color: Colors.white,
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}