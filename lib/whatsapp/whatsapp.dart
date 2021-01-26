import 'package:flutter_launch/flutter_launch.dart';
import 'package:flutter/material.dart';

class LaunchFlutter extends StatefulWidget {
  @override
  _LaunchFlutterState createState() => _LaunchFlutterState();
}

class _LaunchFlutterState extends State<LaunchFlutter> {

  @override
  initState() {
    super.initState();
  }

  void whatsAppOpen() async {
    bool whatsapp = await FlutterLaunch.hasApp(name: "whatsapp");

    if (whatsapp) {
      await FlutterLaunch.launchWathsApp(phone: "6283879204749", message: "Hello, flutter_launch");
    } else {
      print("Whatsapp não instalado");
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Plugin example app'),
        ),
        body: Center(
            child: FlatButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Whatsapp",)
                ],
              ),
              onPressed: () {
                whatsAppOpen();
              },
            )
        ),
      ),
    );
  }
}