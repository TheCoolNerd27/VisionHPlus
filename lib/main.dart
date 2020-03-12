import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:visionhplus/camera_screen.dart';
import 'package:visionhplus/Drawer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
        initialRoute: '/',
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.

          // When navigating to the "/second" route, build the SecondScreen widget.


          '/live':(context) =>CameraScreen(),

        },

      home: Scaffold(
        appBar: AppBar(
        title: Text("VisiohHPlus"),

    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
    bottom:Radius.circular(30),
    ),
    ),
    ),
    body:MyHomePage(title: 'VisionHPlus'),
        drawer: MyDrawer(),

      ));
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  Widget getData2() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('data').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot doc) {
                return new Card(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 30.0,
                          child: ListTile(

                              title: Text(
                                  "BloodPressure:${doc['bloodpressure']}",
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .title)),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        SizedBox(
                          height: 30.0,
                          child: ListTile(

                              title: Text("Heart Rate:${doc['heartrate']}",
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .title)),
                        ),
                        SizedBox(
                          height: 30.0,
                          child: ListTile(

                              title: Text("Respiration:${doc['respiration']}",
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .title)),
                        ),
                        SizedBox(
                          height: 30.0,
                          child: ListTile(

                              title: Text("Temperature:${doc['temperature']}",
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .title)),
                        ),


                      ],
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ));
              }).toList(),
            );
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: getData2(),
    );
  }
}
