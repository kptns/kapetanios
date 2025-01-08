import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kapetanioswebapp_front/presentation/screens/formulario.dart';
import 'package:kapetanioswebapp_front/presentation/screens/menu.dart';
import 'package:kapetanioswebapp_front/presentation/screens/monitor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: RegistroNuevoMonitor(),
    );
  }
}
