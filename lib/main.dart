import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'views/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Mengatur warna status bar agar menyatu dengan desain (Transparan)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Newsly',
      theme: ThemeData(
        useMaterial3: true, // Mengaktifkan desain Material 3 yang modern
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E5BFF), // Warna aksen biru profesional
          primary: const Color(0xFF2E5BFF),
          surface: const Color(
            0xFFF8F9FA,
          ), // Background sedikit abu untuk kontras
        ),
        // Menggunakan font Inter atau Poppins yang sangat populer untuk aplikasi modern
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: false,
        ),
      ),
      home: const HomePage(),
    );
  }
}
