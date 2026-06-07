import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'screens/splash_screen.dart';

// Global ValueNotifier untuk mengontrol Locale yang sedang aktif secara real-time
final ValueNotifier<Locale> appLocaleNotifier = ValueNotifier<Locale>(const Locale('en'));

// Global ValueNotifier untuk menyimpan data foto profil (bytes) agar real-time di seluruh screen
final ValueNotifier<Uint8List?> userProfileImageNotifier = ValueNotifier<Uint8List?>(null);

void main() {
  runApp(const BarberKlikApp());
}

class BarberKlikApp extends StatelessWidget {
  const BarberKlikApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: appLocaleNotifier,
      builder: (context, currentLocale, child) {
        return MaterialApp(
          title: 'BARBERKLIK',
          debugShowCheckedModeBanner: false,
          locale: currentLocale,
          // Registrasi Delegates untuk Flutter Localization
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          // Bahasa yang didukung oleh aplikasi BARBERKLIK
          supportedLocales: const [
            Locale('en'), // Inggris
            Locale('id'), // Indonesia
          ],
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.black,
            colorScheme: const ColorScheme.dark(
              primary: Colors.black,
              secondary: Color(0xFFD4AF37), // Metallic Gold
              surface: Color(0xFF121212), // Slightly lighter black for surfaces/cards
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.black,
              foregroundColor: Color(0xFFD4AF37),
              elevation: 0,
            ),
            textTheme: GoogleFonts.montserratTextTheme(
              ThemeData.dark().textTheme,
            ).apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}
