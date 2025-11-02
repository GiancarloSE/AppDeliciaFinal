import 'package:flutter/material.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;
  CartItem({required this.product, this.quantity = 1});
}

class CartModel extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  // Getter público para la lista de items (ya había uno)
  List<CartItem> get items => _items.values.toList();

  int get totalItems => _items.values.fold(0, (s, i) => s + i.quantity);

  double get totalPrice =>
      _items.values.fold(0.0, (s, i) => s + i.product.price * i.quantity);

  void addProduct(Product p) {
    if (_items.containsKey(p.id)) {
      _items[p.id]!.quantity += 1;
    } else {
      _items[p.id] = CartItem(product: p, quantity: 1);
    }
    notifyListeners();
  }

  void removeProduct(String productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId]!.quantity > 1) {
      _items[productId]!.quantity -= 1;
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void removeCompletely(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  // -------------------------
  // Métodos públicos añadidos
  // -------------------------

  /// Devuelve la cantidad del producto en el carrito (0 si no existe)
  int quantityOf(String productId) {
    return _items[productId]?.quantity ?? 0;
  }

  /// Devuelve el CartItem para un productId (o null si no existe)
  CartItem? itemOf(String productId) {
    return _items[productId];
  }
}
