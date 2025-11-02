import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/cart_model.dart';
import 'services/firebase_service.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // ⚠️ SUBIR PRODUCTOS - EJECUTAR SOLO UNA VEZ
  // Después de ejecutar, COMENTA las siguientes 3 líneas
  print('🔥 Subiendo productos iniciales...');
  await FirebaseService().uploadInitialProducts();
  print('✅ Productos subidos exitosamente');
  
  runApp(const AppDeliciaApp());
}

class AppDeliciaApp extends StatelessWidget {
  const AppDeliciaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartModel(),
      child: MaterialApp(
        title: 'AppDelicia',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.pink,
          primaryColor: const Color(0xFFE91E63),
          scaffoldBackgroundColor: const Color(0xFFFFF8F0),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFE91E63),
            secondary: const Color(0xFFFFAB91),
          ),
          useMaterial3: true,
          cardTheme: const CardThemeData(
            elevation: 4,
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Color(0xFFE91E63),
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE91E63),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFFE91E63),
            foregroundColor: Colors.white,
          ),
        ),
        initialRoute: Routes.splash,
        routes: Routes.getRoutes(),
      ),
    );
  }
}