import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  FirebaseAuth get _auth => FirebaseAuth.instance;

  // ========== PRODUCTOS ==========
  
  CollectionReference get _productsCollection => _firestore.collection('products');

  // Obtener productos en tiempo real
  Stream<List<Product>> getProducts() {
    return _productsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // Agregar producto
  Future<String?> addProduct(Product product) async {
    try {
      DocumentReference docRef = await _productsCollection.add(product.toFirestore());
      print('✅ Producto agregado: ${product.name}');
      return docRef.id;
    } catch (e) {
      print('❌ Error al agregar producto: $e');
      return null;
    }
  }

  // Subir productos iniciales (EJECUTAR UNA VEZ)
  Future<void> uploadInitialProducts() async {
    final initialProducts = [
      Product(id: '', name: 'PASTEL DE CHOCOLATE', description: 'Delicioso pastel de chocolate con fudge de relleno superior', price: 9.99, image: 'assets/images/cake_chocolate.png'),
      Product(id: '', name: 'PASTEL DE VAINILLA', description: 'Esponjoso pastel con sabor a vainilla y banana', price: 12.50, image: 'assets/images/cake_vainilla.png'),
      Product(id: '', name: 'CUPCAKE DE FRESA', description: 'Bocadito perfecto para ocasiones especiales con fresa fresca', price: 4.20, image: 'assets/images/cupcake_fresa.png'),
      Product(id: '', name: 'PIE DE LIMÓN', description: 'Pie clásico con sabor a limón y merengue suave', price: 6.00, image: 'assets/images/tarta_limon.png'),
      Product(id: '', name: 'TARTA DE FRESA', description: 'Tarta decorada con fresas frescas y crema batida', price: 15.99, image: 'assets/images/tarta_fresa.png'),
      Product(id: '', name: 'BROWNIE DE CHOCOLATE', description: 'Brownie húmedo con doble chocolate y nueces', price: 5.50, image: 'assets/images/brownie_chocolate.png'),
      Product(id: '', name: 'CHEESECAKE CLÁSICO', description: 'Cheesecake cremoso con base de galleta y frutos rojos', price: 18.00, image: 'assets/images/cheesecake.png'),
      Product(id: '', name: 'CUPCAKE DE CHOCOLATE', description: 'Cupcake de chocolate con frosting de crema y chispas', price: 4.50, image: 'assets/images/cupcake_chocolate.png'),
      Product(id: '', name: 'TARTA DE MANZANA', description: 'Tarta tradicional de manzana con canela y azúcar', price: 13.50, image: 'assets/images/tarta_manzana.png'),
      Product(id: '', name: 'PASTEL RED VELVET', description: 'Pastel red velvet con frosting de queso crema', price: 16.99, image: 'assets/images/cake_redvelvet.png'),
    ];

    for (var product in initialProducts) {
      await addProduct(product);
    }
    print('✅ Todos los productos subidos a Firebase');
  }

  // ========== USUARIOS ==========

  Future<User?> registerUser({required String email, required String password, required String name, String? phone}) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await _firestore.collection('users').doc(userCredential.user!.uid).set({'email': email, 'name': name, 'phone': phone, 'createdAt': FieldValue.serverTimestamp()});
      print('✅ Usuario registrado: $email');
      return userCredential.user;
    } catch (e) {
      print('❌ Error: $e');
      return null;
    }
  }

  Future<User?> loginUser({required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      print('✅ Login: $email');
      return userCredential.user;
    } catch (e) {
      print('❌ Error: $e');
      return null;
    }
  }

  Future<void> logout() async => await _auth.signOut();
  User? get currentUser => _auth.currentUser;
  Stream<User?> get userChanges => _auth.authStateChanges();

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    } catch (e) {
      return null;
    }
  }

  // ========== ÓRDENES ==========

  Future<String?> createOrder({required String userId, required List<Map<String, dynamic>> items, required double total}) async {
    try {
      DocumentReference docRef = await _firestore.collection('orders').add({'userId': userId, 'items': items, 'total': total, 'createdAt': FieldValue.serverTimestamp(), 'status': 'completed'});
      print('✅ Orden: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      return null;
    }
  }

  Stream<List<Map<String, dynamic>>> getUserOrders(String userId) {
    return _firestore.collection('orders').where('userId', isEqualTo: userId).orderBy('createdAt', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }
}