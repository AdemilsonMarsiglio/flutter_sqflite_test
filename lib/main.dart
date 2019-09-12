
import 'package:flutter/material.dart';
import 'package:test_floor/model/client.dart';
import 'package:test_floor/view/people/people.home.dart';
import 'package:load/load.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoadingProvider(child: PeopleHomeWidget()) ,
    );
  }
}


