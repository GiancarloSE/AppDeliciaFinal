import 'dart:async';
import 'package:flutter/material.dart';
import '../../routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    
    _animationController.forward();
    
    // Navegar al login después de 2.5 segundos
    Timer(const Duration(milliseconds: 2500), () {
      Navigator.pushReplacementNamed(context, Routes.auth);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE91E63),
              Color(0xFFF48FB1),
              Color(0xFFFFAB91),
            ],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Opacity(
                opacity: _opacityAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/logo_delicia.png',
                          width: 100,
                          height: 100,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.cake,
                            size: 100,
                            color: Color(0xFFE91E63),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // Nombre de la app
                      const Text(
                        'AppDelicia',
                        style: TextStyle(
                          fontSize: 42,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 2),
                              blurRadius: 8,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Subtítulo
                      const Text(
                        '🧁 Dulces momentos para ti 🧁',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 4,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 60),
                      
                      // Indicador de carga
                      const SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}