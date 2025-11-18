# 🧁 AppDelicia - Aplicación Móvil de Pastelería

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=for-the-badge&logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**AppDelicia** es una aplicación móvil de e-commerce para una pastelería, desarrollada en Flutter con Firebase como backend. Permite a los usuarios explorar productos, realizar pedidos, gestionar entregas y realizar pagos de forma segura.

---

## 📱 Descripción del Proyecto

AppDelicia es una solución completa de comercio electrónico móvil diseñada específicamente para el sector de repostería y pastelería. La aplicación ofrece una experiencia de compra fluida, desde la exploración del catálogo hasta la entrega del pedido, con funcionalidades tanto para clientes como para administradores.

### 🎯 Objetivos del Proyecto

- Digitalizar el proceso de venta de una pastelería
- Ofrecer una experiencia de usuario intuitiva y atractiva
- Facilitar la gestión de pedidos en tiempo real
- Proporcionar herramientas de análisis para decisiones de negocio
- Garantizar la seguridad en las transacciones

---

## ✨ Características Principales

### Para Clientes 👥

- **🏪 Catálogo de Productos**
  - Exploración visual de productos con imágenes
  - Búsqueda y filtrado de productos
  - Información detallada de cada producto (descripción, precio, ingredientes)
  - Visualización de promociones activas

- **🛒 Carrito de Compras**
  - Agregar/eliminar productos
  - Ajustar cantidades
  - Visualización de total en tiempo real
  - Persistencia del carrito

- **💳 Proceso de Checkout Completo**
  - 4 pasos claros: Dirección → Entrega → Pago → Confirmación
  - Opción de delivery o recojo en tienda
  - Múltiples métodos de pago (Efectivo, Tarjeta, Yape, Plin)
  - Validación de datos de entrega

- **📄 Factura Electrónica**
  - Generación automática de PDF
  - Descarga directa desde la app
  - Información completa del pedido

- **📋 Historial de Pedidos**
  - Seguimiento de estado en tiempo real
  - Visualización de pedidos anteriores
  - Detalles completos de cada orden
  - Estados: Pendiente, Preparando, Enviado, Entregado, Cancelado

- **👤 Perfil de Usuario**
  - Gestión de datos personales
  - Favoritos (productos marcados)
  - Direcciones guardadas
  - Métodos de pago disponibles
  - Preferencias de notificaciones
  - Ayuda y soporte

### Para Administradores 🔐

- **📊 Panel de Administración**
  - Dashboard con métricas clave
  - Acceso restringido por email

- **🍰 Gestión de Productos**
  - Crear, editar y eliminar productos
  - Subir imágenes
  - Gestionar stock e inventario
  - Categorización de productos

- **🎁 Gestión de Promociones**
  - Crear descuentos y ofertas
  - Códigos promocionales
  - Configurar fechas de vigencia
  - Aplicación automática de descuentos

- **📦 Gestión de Pedidos**
  - Visualización de todos los pedidos
  - Actualización de estados
  - Filtrado por estado
  - Información completa del cliente

- **📈 Analítica de Ventas**
  - KPIs principales (ingresos, pedidos, ticket promedio)
  - Top 5 productos más vendidos
  - Análisis por período (7 días, 30 días, 1 año)
  - Distribución de estados de pedidos
  - Análisis de métodos de pago
  - Tendencias de ventas diarias

---

## 🛠️ Tecnologías Utilizadas

### Frontend
- **Flutter 3.0+** - Framework de desarrollo móvil
- **Dart** - Lenguaje de programación
- **Provider** - Gestión de estado
- **Material Design 3** - Sistema de diseño

### Backend & Servicios
- **Firebase Authentication** - Autenticación de usuarios
- **Cloud Firestore** - Base de datos en tiempo real
- **Firebase Storage** (preparado para imágenes)

### Librerías Principales
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.5              # Gestión de estado
  firebase_core: ^3.6.0         # Firebase Core
  cloud_firestore: ^5.4.4       # Firestore Database
  firebase_auth: ^5.3.1         # Autenticación
  intl: ^0.19.0                 # Internacionalización y formato
  pdf: ^3.10.4                  # Generación de PDFs
  printing: ^5.11.0             # Impresión y guardado de PDFs
  path_provider: ^2.1.1         # Acceso al sistema de archivos
  cached_network_image: ^3.2.4  # Caché de imágenes
```

---

## 📋 Requisitos del Sistema

### Requisitos de Desarrollo
- Flutter SDK 3.0 o superior
- Dart SDK 3.0 o superior
- Android Studio / VS Code
- Git

### Requisitos del Dispositivo
- **Android:** 5.0 (API level 21) o superior
- **iOS:** iOS 12.0 o superior
- Conexión a Internet
- 100 MB de espacio disponible

---

## 🚀 Instalación y Configuración

### 1. Clonar el Repositorio

```bash
git clone https://github.com/tu-usuario/appdelicia-flutter.git
cd appdelicia-flutter
```

### 2. Instalar Dependencias

```bash
flutter pub get
```

### 3. Configurar Firebase

1. Crear un proyecto en [Firebase Console](https://console.firebase.google.com/)
2. Agregar una app Android/iOS
3. Descargar `google-services.json` (Android) y `GoogleService-Info.plist` (iOS)
4. Colocar los archivos en las ubicaciones correspondientes:
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`

5. Habilitar servicios en Firebase Console:
   - Authentication (Email/Password)
   - Cloud Firestore
   - (Opcional) Firebase Storage

### 4. Configurar Firestore

Estructura de base de datos requerida:

```
firestore/
├── products/          # Colección de productos
│   └── {productId}
│       ├── name: string
│       ├── description: string
│       ├── price: number
│       ├── image: string
│       ├── stock: number
│       └── category: string
│
├── orders/           # Colección de pedidos
│   └── {orderId}
│       ├── userId: string
│       ├── items: array
│       ├── total: number
│       ├── estado: string
│       ├── metodoPago: string
│       ├── metodoEntrega: string
│       ├── direccion: map
│       └── createdAt: timestamp
│
├── promotions/       # Colección de promociones
│   └── {promotionId}
│       ├── nombre: string
│       ├── descripcion: string
│       ├── descuento: number
│       ├── codigo: string
│       ├── fechaInicio: timestamp
│       └── fechaFin: timestamp
│
├── favorites/        # Colección de favoritos
│   └── {userId}
│       └── productIds: array
│
└── user_preferences/ # Preferencias de usuario
    └── {userId}
        ├── orderUpdates: boolean
        ├── promotions: boolean
        └── newsletter: boolean
```

### 5. Ejecutar la Aplicación

```bash
# Modo desarrollo
flutter run

# Modo release
flutter run --release
```

---

## 👥 Usuarios de Prueba

### Cuenta de Administrador
- **Email:** `admin@appdelicia.com`
- **Contraseña:** `admin123`
- **Permisos:** Acceso completo al panel de administración

### Cuenta de Cliente
- **Email:** `cliente@test.com`
- **Contraseña:** `cliente123`
- **Permisos:** Funciones de cliente estándar

**Nota:** Para agregar más administradores, editar el array `adminEmails` en:
- `lib/ui/screens/admin_dashboard_screen.dart`
- Otros archivos admin: `admin_products_screen.dart`, `admin_promotions_screen.dart`, etc.

---

## 📁 Estructura del Proyecto

```
lib/
├── main.dart                    # Punto de entrada
├── routes.dart                  # Definición de rutas
│
├── models/                      # Modelos de datos
│   ├── product.dart
│   ├── cart_item.dart
│   └── order.dart
│
├── providers/                   # Gestión de estado
│   └── cart_model.dart
│
├── services/                    # Servicios y lógica de negocio
│   ├── auth_service.dart
│   └── pdf_service.dart
│
└── ui/                         # Interfaz de usuario
    ├── screens/                # Pantallas principales
    │   ├── auth/
    │   │   ├── auth_screen.dart
    │   │   ├── login_screen.dart
    │   │   └── register_screen.dart
    │   │
    │   ├── catalog/
    │   │   ├── catalog_screen.dart
    │   │   └── product_detail_screen.dart
    │   │
    │   ├── cart/
    │   │   ├── cart_screen.dart
    │   │   └── checkout_screen.dart
    │   │
    │   ├── orders/
    │   │   ├── orders_screen.dart
    │   │   └── order_detail_screen.dart
    │   │
    │   ├── profile/
    │   │   ├── profile_screen.dart
    │   │   ├── favorites_screen.dart
    │   │   ├── addresses_screen.dart
    │   │   ├── payment_methods_screen.dart
    │   │   ├── notifications_screen.dart
    │   │   └── help_support_screen.dart
    │   │
    │   ├── admin/
    │   │   ├── admin_dashboard_screen.dart
    │   │   ├── admin_products_screen.dart
    │   │   ├── admin_promotions_screen.dart
    │   │   ├── admin_orders_screen.dart
    │   │   └── analytics_screen.dart
    │   │
    │   └── main_navigation.dart
    │
    └── widgets/                # Componentes reutilizables
        ├── product_card.dart
        └── custom_button.dart

assets/
└── images/                     # Imágenes de productos
    ├── cake1.jpg
    ├── cake2.jpg
    └── app_icon.png
```

---

## 🧪 Pruebas y Testing

### Casos de Prueba Principales

#### Módulo de Autenticación
- [ ] Registro de nuevo usuario
- [ ] Inicio de sesión exitoso
- [ ] Inicio de sesión fallido (credenciales incorrectas)
- [ ] Cierre de sesión
- [ ] Validación de campos vacíos

#### Módulo de Catálogo
- [ ] Visualización de productos
- [ ] Búsqueda de productos
- [ ] Filtrado por categoría
- [ ] Ver detalle de producto

#### Módulo de Carrito
- [ ] Agregar producto al carrito
- [ ] Eliminar producto del carrito
- [ ] Modificar cantidad
- [ ] Calcular total correctamente
- [ ] Persistencia del carrito

#### Módulo de Checkout
- [ ] Completar proceso de 4 pasos
- [ ] Validación de dirección de entrega
- [ ] Selección de método de entrega
- [ ] Selección de método de pago
- [ ] Creación exitosa de pedido

#### Módulo de Pedidos
- [ ] Visualizar historial de pedidos
- [ ] Ver detalle de pedido
- [ ] Generar factura PDF
- [ ] Descargar factura
- [ ] Actualización en tiempo real del estado

#### Módulo de Administración
- [ ] Acceso restringido (solo admins)
- [ ] CRUD de productos
- [ ] CRUD de promociones
- [ ] Actualización de estado de pedidos
- [ ] Visualización de analítica

### Ejecutar Pruebas

```bash
# Pruebas unitarias
flutter test

# Pruebas de integración
flutter test integration_test
```

---

## 🎨 Guía de Estilo

### Colores Principales
```dart
Primary: #E91E63 (Rosa vibrante)
Secondary: #F48FB1 (Rosa claro)
Accent: #FFC107 (Amarillo)
Background: #FFFFFF (Blanco)
Text: #333333 (Gris oscuro)
```

### Tipografía
- **Fuente:** System Default (San Francisco para iOS, Roboto para Android)
- **Tamaños:**
  - Títulos: 24-28sp
  - Subtítulos: 18-20sp
  - Cuerpo: 14-16sp
  - Pequeño: 12sp

---

## 📊 Historias de Usuario Implementadas

### HU-01: Explorar Catálogo de Productos ✅
**Como** cliente  
**Quiero** ver todos los productos disponibles con imágenes, precios y descripciones  
**Para** decidir qué comprar

**Criterios de Aceptación:**
- ✅ Visualización en grid de productos
- ✅ Imagen, nombre y precio visible
- ✅ Búsqueda por nombre
- ✅ Detalle al hacer clic

---

### HU-02: Carrito de Compras ✅
**Como** cliente  
**Quiero** agregar productos a un carrito  
**Para** comprar múltiples items en una sola transacción

**Criterios de Aceptación:**
- ✅ Botón "Agregar al carrito"
- ✅ Ajustar cantidades
- ✅ Eliminar productos
- ✅ Ver total actualizado

---

### HU-03: Proceso de Checkout ✅
**Como** cliente  
**Quiero** completar mi compra ingresando datos de entrega y pago  
**Para** recibir mis productos

**Criterios de Aceptación:**
- ✅ 4 pasos: Dirección, Entrega, Pago, Confirmación
- ✅ Validación de campos
- ✅ Selección de método de entrega
- ✅ Selección de método de pago
- ✅ Resumen antes de confirmar

---

### HU-04: Múltiples Métodos de Pago ✅
**Como** cliente  
**Quiero** elegir entre varios métodos de pago  
**Para** pagar de la forma que prefiera

**Criterios de Aceptación:**
- ✅ Efectivo
- ✅ Tarjeta de crédito/débito
- ✅ Yape
- ✅ Plin

---

### HU-05: Factura Electrónica ✅
**Como** cliente  
**Quiero** recibir una factura en PDF  
**Para** tener comprobante de mi compra

**Criterios de Aceptación:**
- ✅ Generación automática de PDF
- ✅ Información completa del pedido
- ✅ Descarga desde la app
- ✅ Formato profesional

---

### HU-06: Notificaciones de Pedido ⚠️ (Parcial)
**Como** cliente  
**Quiero** recibir notificaciones del estado de mi pedido  
**Para** saber cuándo llegará

**Criterios de Aceptación:**
- ✅ Preferencias de notificaciones (toggle)
- ✅ Guardado en Firestore
- ⚠️ Push notifications (pendiente)

---

### HU-07: Administrar Catálogo ✅
**Como** gerente  
**Quiero** agregar, editar y eliminar productos  
**Para** mantener el catálogo actualizado

**Criterios de Aceptación:**
- ✅ CRUD completo de productos
- ✅ Campos: nombre, descripción, precio, imagen, stock
- ✅ Interfaz intuitiva
- ✅ Confirmación antes de eliminar

---

### HU-08: Gestionar Pedidos ✅
**Como** gerente  
**Quiero** ver y actualizar el estado de los pedidos  
**Para** gestionar la operación

**Criterios de Aceptación:**
- ✅ Lista de todos los pedidos
- ✅ Filtrado por estado
- ✅ Actualizar estado
- ✅ Ver detalles completos

---

### HU-09: Analítica de Ventas ✅
**Como** gerente  
**Quiero** ver reportes de ventas y productos más vendidos  
**Para** tomar decisiones informadas

**Criterios de Aceptación:**
- ✅ KPIs: Ingresos, Pedidos, Ticket Promedio, Productos Vendidos
- ✅ Top 5 productos más vendidos
- ✅ Análisis por período (7 días, 30 días, 1 año)
- ✅ Distribución de estados
- ✅ Análisis de métodos de pago
- ✅ Tendencias diarias

---

## 🐛 Problemas Conocidos y Soluciones

### Error de CSRF Token
**Problema:** Token CSRF inválido en peticiones  
**Solución:** Configurar correctamente las cookies y headers en las peticiones HTTP

### Error de Autenticación Firebase
**Problema:** Usuario no puede iniciar sesión  
**Solución:** Verificar que Authentication esté habilitado en Firebase Console

### Imágenes no cargan
**Problema:** Las imágenes de productos no se muestran  
**Solución:** Verificar que las imágenes existan en `assets/images/` y estén declaradas en `pubspec.yaml`

---

## 🔄 Roadmap y Mejoras Futuras

### Versión 2.0
- [ ] Notificaciones push en tiempo real
- [ ] Chat de soporte en vivo
- [ ] Sistema de calificaciones y reseñas
- [ ] Programa de puntos y recompensas
- [ ] Integración con pasarelas de pago reales (Niubiz, Culqi)
- [ ] Personalización de productos
- [ ] Pedidos recurrentes/suscripciones

### Versión 2.1
- [ ] Modo oscuro
- [ ] Soporte multiidioma
- [ ] Historial de búsquedas
- [ ] Recomendaciones personalizadas con ML
- [ ] Compartir productos en redes sociales
- [ ] Escaneo de código QR para promociones

---

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

---

## 👨‍💻 Autor

**Giancarlo Soto**
- Universidad: Universidad Continental
- Curso: Desarrollo de Software / Aplicaciones Móviles
- Email: soto@gmail.com
- GitHub: [@tu-usuario](https://github.com/tu-usuario)

---

## 🙏 Agradecimientos

- Universidad Continental por el apoyo académico
- Profesores del curso por la guía y feedback
- Firebase por la infraestructura backend
- Comunidad de Flutter por los recursos y documentación

---

## 📞 Soporte y Contacto

Para reportar bugs, sugerencias o preguntas:
- 📧 Email: contacto@appdelicia.com
- 🐛 Issues: [GitHub Issues](https://github.com/tu-usuario/appdelicia-flutter/issues)
- 📱 WhatsApp: +51 987 654 321

---

## 📸 Screenshots

### Pantallas de Cliente
![Catálogo](screenshots/catalog.png)
![Carrito](screenshots/cart.png)
![Checkout](screenshots/checkout.png)
![Pedidos](screenshots/orders.png)

### Pantallas de Administrador
![Dashboard Admin](screenshots/admin_dashboard.png)
![Gestión de Productos](screenshots/admin_products.png)
![Analítica](screenshots/analytics.png)

---

<div align="center">

**⭐ Si te gusta este proyecto, dale una estrella en GitHub ⭐**

Hecho con ❤️ y ☕ por Giancarlo Soto

</div>
