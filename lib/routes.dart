import 'package:flutter/material.dart';
import 'ui/screens/splash_screen.dart';
import 'ui/screens/auth_screen.dart';
import 'ui/screens/catalog_screen.dart';
import 'ui/screens/product_detail_screen.dart';
import 'ui/screens/cart_screen.dart';
import 'ui/screens/profile_screen.dart';

class Routes {
  static const splash = '/';
  static const auth = '/auth';
  static const catalog = '/catalog';
  static const product = '/product';
  static const cart = '/cart';
  static const profile = '/profile';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (_) => const SplashScreen(),
      auth: (_) => const AuthScreen(),
      catalog: (_) => const CatalogScreen(),
      product: (_) => const ProductDetailScreen(),
      cart: (_) => const CartScreen(),
      profile: (_) => const ProfileScreen(),
    };
  }
}
