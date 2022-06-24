import 'package:flutter/material.dart';
import 'package:fotochop/exp/photoexperiment.dart';

import 'home_screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fotochop',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const HomeScreen(),
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        CommonUseCasesExamples.routeName: (context) =>
            const CommonUseCasesExamples(),
      },
    );
  }
}
