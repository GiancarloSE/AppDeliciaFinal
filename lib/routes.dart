import 'package:flutter/material.dart';
import 'ui/screens/splash_screen.dart';
import 'ui/screens/auth_screen.dart';
import 'ui/screens/main_screen.dart';
import 'ui/screens/catalog_screen.dart';
import 'ui/screens/product_detail_screen.dart';
import 'ui/screens/cart_screen.dart';
import 'ui/screens/profile_screen.dart';
import 'ui/screens/checkout_screen.dart';  // ← AGREGAR ESTA LÍNEA

class Routes {
  static const splash = '/';
  static const auth = '/auth';
  static const main = '/main';
  static const catalog = '/catalog';
  static const product = '/product';
  static const cart = '/cart';
  static const checkout = '/checkout';  // ← AGREGAR ESTA LÍNEA
  static const profile = '/profile';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (_) => const SplashScreen(),
      auth: (_) => const AuthScreen(),
      main: (_) => const MainScreen(),
      catalog: (_) => const CatalogScreen(),
      product: (_) => const ProductDetailScreen(),
      cart: (_) => const CartScreen(),
      checkout: (_) => const CheckoutScreen(),  // ← AGREGAR ESTA LÍNEA
      profile: (_) => const ProfileScreen(),
    };
  }
}