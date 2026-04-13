import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/auth_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'IMGO Customer Portal',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color(0xFF0F172A),
          scaffoldBackgroundColor: const Color(0xFF0F172A),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF0F172A),
            secondary: Color(0xFFD4AF37),
            surface: Color(0xFF1E293B),
            background: Color(0xFF0F172A),
            error: Colors.red,
            onPrimary: Color(0xFFF8FAFC),
            onSecondary: Color(0xFF0F172A),
            onSurface: Color(0xFFF8FAFC),
            onBackground: Color(0xFFF8FAFC),
          ),
          fontFamily: GoogleFonts.poppins().fontFamily,
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
