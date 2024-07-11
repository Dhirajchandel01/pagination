import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data_controller.dart';
import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataController()),
      ],
      child: MaterialApp(
        title: 'Flutter MVC Example',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:  DataView(),
      ),
    );
  }
}
