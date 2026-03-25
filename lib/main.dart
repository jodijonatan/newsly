import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/news_model.dart';
import 'providers/news_provider.dart';
import 'views/home_page.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(ArticleAdapter());
  await Hive.openBox<Article>(NewsProvider.bookmarkBoxName);

  // Mengatur warna status bar agar menyatu dengan desain (Transparan)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Newsly',
      themeMode: newsProvider.isDarkMode ? ThemeMode.dark : ThemeMode.dark, // Default to dark
      theme: AppTheme.darkTheme, // Futuristic look
      darkTheme: AppTheme.darkTheme,
      home: const HomePage(),
    );
  }
}
