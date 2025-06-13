import 'package:fitria/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:fitria/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'utils/constants.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(AppConstants.primaryColorValue);
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Fitria',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: primaryColor, // Usar el color del logo
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              secondary: const Color(0xFF009688),
              surface: Colors.white,
              background: const Color(0xFFF5F5F5),
              onPrimary: Colors.white,
            ),
            fontFamily: 'Montserrat',
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              ),
            ),
            cardTheme: CardTheme(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: primaryColor,
            colorScheme: ColorScheme.dark(
              primary: primaryColor,
              secondary: const Color(0xFF00796B),
              surface: const Color(0xFF121212),
              background: const Color(0xFF121212),
              onPrimary: Colors.white,
            ),
            fontFamily: 'Montserrat',
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              ),
            ),
            cardTheme: CardTheme(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
          ),
          themeMode: mode,
          home: const SplashScreen(),
        );
      },
    );
  }
}