import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kapetanioswebapp_front/presentation/screens/formulario.dart';
import 'package:kapetanioswebapp_front/presentation/screens/menu.dart';
import 'package:kapetanioswebapp_front/presentation/screens/monitor.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDxktVxK9DlCDcnL0xi9LkbO0mQ8fACCQw", 
      appId: "1:869882757598:web:af297ae151b5b80f8fdd4f", 
      messagingSenderId: "869882757598", 
      projectId: "kapetianosweb"
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kapetanios',
      theme: ThemeData(
        textTheme: GoogleFonts.openSansTextTheme(Theme.of(context).textTheme),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Menu(),
    );
  }
}
