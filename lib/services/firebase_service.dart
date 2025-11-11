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

  // Subir productos iniciales (EJECUTAR UNA VEZ) - AHORA CON 50 PRODUCTOS
  Future<void> uploadInitialProducts() async {
    final initialProducts = [
      // Productos originales (10)
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
      
      // Nuevos productos (40 adicionales)
      Product(id: '', name: 'CROISSANT DE ALMENDRA', description: 'Croissant francés relleno con crema de almendra', price: 3.50, image: 'assets/images/croissant_almendra.png'),
      Product(id: '', name: 'DONUT GLASEADO', description: 'Donut esponjoso con glaseado de chocolate', price: 2.80, image: 'assets/images/donut_glaseado.png'),
      Product(id: '', name: 'MACARONS VARIADOS', description: 'Set de 6 macarons franceses de sabores variados', price: 8.50, image: 'assets/images/macarons.png'),
      Product(id: '', name: 'ECLAIR DE VAINILLA', description: 'Eclair relleno de crema pastelera de vainilla', price: 4.80, image: 'assets/images/eclair_vainilla.png'),
      Product(id: '', name: 'TIRAMISÚ CLÁSICO', description: 'Postre italiano con café, mascarpone y cacao', price: 14.50, image: 'assets/images/tiramisu.png'),
      Product(id: '', name: 'ALFAJOR DE CHOCOLATE', description: 'Alfajor artesanal bañado en chocolate', price: 3.20, image: 'assets/images/alfajor_chocolate.png'),
      Product(id: '', name: 'TORTA TRES LECHES', description: 'Torta empapada en mezcla de tres leches', price: 11.99, image: 'assets/images/torta_tres_leches.png'),
      Product(id: '', name: 'PROFITEROLES', description: 'Profiteroles rellenos de crema y bañados en chocolate', price: 9.50, image: 'assets/images/profiteroles.png'),
      Product(id: '', name: 'PASTEL DE ZANAHORIA', description: 'Pastel de zanahoria con frosting de queso crema', price: 10.50, image: 'assets/images/cake_zanahoria.png'),
      Product(id: '', name: 'CHURROS CON CHOCOLATE', description: 'Churros crujientes servidos con chocolate caliente', price: 6.50, image: 'assets/images/churros.png'),
      Product(id: '', name: 'MOUSSE DE CHOCOLATE', description: 'Mousse aireado de chocolate belga premium', price: 7.80, image: 'assets/images/mousse_chocolate.png'),
      Product(id: '', name: 'TARTA DE PECANAS', description: 'Tarta americana con pecanas caramelizadas', price: 13.00, image: 'assets/images/tarta_pecanas.png'),
      Product(id: '', name: 'CUPCAKE DE VAINILLA', description: 'Cupcake de vainilla con buttercream de colores', price: 4.30, image: 'assets/images/cupcake_vainilla.png'),
      Product(id: '', name: 'PANETTONE TRADICIONAL', description: 'Panettone italiano con frutas confitadas', price: 19.99, image: 'assets/images/panettone.png'),
      Product(id: '', name: 'SUSPIRO LIMEÑO', description: 'Postre peruano de manjar blanco y merengue', price: 5.80, image: 'assets/images/suspiro_limeno.png'),
      Product(id: '', name: 'TARTA DE QUESO Y ARÁNDANOS', description: 'Cheesecake con topping de arándanos frescos', price: 17.50, image: 'assets/images/tarta_arandanos.png'),
      Product(id: '', name: 'BROWNIE CON HELADO', description: 'Brownie tibio servido con helado de vainilla', price: 8.20, image: 'assets/images/brownie_helado.png'),
      Product(id: '', name: 'ROLLO DE CANELA', description: 'Rollo suave con canela y glaseado de queso crema', price: 4.00, image: 'assets/images/rollo_canela.png'),
      Product(id: '', name: 'TARTA DE DURAZNO', description: 'Tarta con duraznos frescos y crema pastelera', price: 14.80, image: 'assets/images/tarta_durazno.png'),
      Product(id: '', name: 'COOKIE DE CHISPAS', description: 'Galleta grande con chispas de chocolate', price: 2.50, image: 'assets/images/cookie_chispas.png'),
      Product(id: '', name: 'PASTEL DE COCO', description: 'Pastel tropical con coco rallado y crema', price: 11.50, image: 'assets/images/cake_coco.png'),
      Product(id: '', name: 'FLAN DE CARAMELO', description: 'Flan casero con caramelo líquido', price: 5.00, image: 'assets/images/flan_caramelo.png'),
      Product(id: '', name: 'CUPCAKE RED VELVET', description: 'Cupcake red velvet con frosting de queso', price: 4.80, image: 'assets/images/cupcake_redvelvet.png'),
      Product(id: '', name: 'BERLINA DE CREMA', description: 'Berlina alemana rellena de crema pastelera', price: 3.80, image: 'assets/images/berlina_crema.png'),
      Product(id: '', name: 'TARTA DE CHOCOLATE BLANCO', description: 'Tarta con mousse de chocolate blanco y frambuesas', price: 16.50, image: 'assets/images/tarta_chocolate_blanco.png'),
      Product(id: '', name: 'STRUDEL DE MANZANA', description: 'Strudel austriaco con manzanas y pasas', price: 7.50, image: 'assets/images/strudel_manzana.png'),
      Product(id: '', name: 'CUPCAKE DE LIMÓN', description: 'Cupcake de limón con buttercream cítrico', price: 4.40, image: 'assets/images/cupcake_limon.png'),
      Product(id: '', name: 'PASTEL DE CAFÉ', description: 'Pastel con sabor a café y frosting de moka', price: 13.99, image: 'assets/images/cake_cafe.png'),
      Product(id: '', name: 'TORTA SELVA NEGRA', description: 'Torta alemana de chocolate con cerezas', price: 15.50, image: 'assets/images/torta_selva_negra.png'),
      Product(id: '', name: 'GALLETA DE AVENA Y PASAS', description: 'Galleta saludable de avena con pasas', price: 2.30, image: 'assets/images/galleta_avena.png'),
      Product(id: '', name: 'PASTEL DE PISTACHE', description: 'Pastel exótico con crema de pistache', price: 18.50, image: 'assets/images/cake_pistache.png'),
      Product(id: '', name: 'MAGDALENAS TRADICIONALES', description: 'Set de 6 magdalenas esponjosas', price: 5.50, image: 'assets/images/magdalenas.png'),
      Product(id: '', name: 'TARTA DE PERA', description: 'Tarta elegante con peras caramelizadas', price: 14.00, image: 'assets/images/tarta_pera.png'),
      Product(id: '', name: 'BROWNIE DE NUTELLA', description: 'Brownie con Nutella derretida en el centro', price: 6.80, image: 'assets/images/brownie_nutella.png'),
      Product(id: '', name: 'PASTEL DE NARANJA', description: 'Pastel cítrico con glaseado de naranja', price: 10.99, image: 'assets/images/cake_naranja.png'),
      Product(id: '', name: 'CANNOLI SICILIANO', description: 'Cannoli relleno de ricotta y chispas de chocolate', price: 5.20, image: 'assets/images/cannoli.png'),
      Product(id: '', name: 'TARTA DE CEREZAS', description: 'Tarta con cerezas frescas y almendras', price: 15.80, image: 'assets/images/tarta_cerezas.png'),
      Product(id: '', name: 'CUPCAKE DE OREO', description: 'Cupcake con trozos de Oreo y frosting de cookies', price: 4.90, image: 'assets/images/cupcake_oreo.png'),
      Product(id: '', name: 'PASTEL DE MATCHA', description: 'Pastel japonés con té matcha y crema', price: 17.99, image: 'assets/images/cake_matcha.png'),
      Product(id: '', name: 'TARTA OPERA', description: 'Tarta francesa con capas de café, chocolate y almendra', price: 19.50, image: 'assets/images/tarta_opera.png'),
    ];

    print('🔥 Iniciando carga de ${initialProducts.length} productos...');
    
    for (int i = 0; i < initialProducts.length; i++) {
      await addProduct(initialProducts[i]);
      print('📦 Progreso: ${i + 1}/${initialProducts.length}');
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