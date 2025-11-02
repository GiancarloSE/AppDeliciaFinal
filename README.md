# 🍔 AppDelicia Flutter

Aplicación móvil desarrollada con **Flutter**, migrada desde el proyecto original en **Android Studio (Java)**.  
Su propósito es mostrar un catálogo de productos de comida (hamburguesas, bebidas, combos, etc.) con una interfaz amigable y funcional.

---

## 🚀 Descripción General

**AppDelicia_flutter** es una migración completa del proyecto original **AppDelicia** (Android nativo) al entorno de desarrollo **Flutter**, manteniendo su comportamiento original:

- Los datos y las imágenes son **locales** (sin conexión a Firebase o API externa).
- La navegación se realiza mediante rutas internas (`routers.dart`).
- La gestión del carrito y el detalle de productos funcionan de forma local.
- Interfaz construida con **Material Design** de Flutter.

---

## 🧩 Estructura del Proyecto

```
AppDelicia_flutter/
│
├── assets/
│   └── images/              # Imágenes locales de los productos
│
├── lib/
│   ├── models/              # Modelos de datos (Producto, Carrito, etc.)
│   ├── ui/
│   │   ├── screens/         # Pantallas principales
│   │   │   ├── catalog/     # Catálogo de productos
│   │   │   ├── cart/        # Carrito de compras
│   │   │   ├── profile/     # Perfil del usuario
│   │   │   └── product_detail_screen.dart
│   │   ├── widgets/         # Widgets reutilizables
│   ├── routes.dart          # Definición de rutas de navegación
│   └── main.dart            # Punto de entrada principal
│
├── pubspec.yaml             # Dependencias y configuración del proyecto
└── README.md                # Este archivo
```

---

## ⚙️ Requisitos Previos

Antes de ejecutar el proyecto asegúrate de tener:

- **Flutter SDK** (versión estable recomendada)
- **Visual Studio Code** con las extensiones:
  - Flutter
  - Dart
- **Git** instalado para control de versiones

---

## 📦 Instalación y Ejecución

1. Clona el repositorio:

   ```bash
   git clone https://github.com/tu-usuario/AppDelicia_flutter.git
   cd AppDelicia_flutter
   ```

2. Instala las dependencias:

   ```bash
   flutter pub get
   ```

3. Verifica posibles advertencias (opcional):

   ```bash
   flutter analyze
   ```

4. Ejecuta la aplicación:

   ```bash
   flutter run
   ```

   > Puedes probarla en un emulador Android o en un dispositivo físico.

---

## 📁 Recursos Locales

Las imágenes y la información de los productos están almacenadas **localmente** dentro de la carpeta `assets/images/`.

Asegúrate de tener correctamente declaradas las imágenes en tu archivo `pubspec.yaml`, por ejemplo:

```yaml
flutter:
  assets:
    - assets/images/
```

---

## 🧠 Estado del Proyecto

✅ Migración desde Android Studio (Java) completada  
⚙️ Proyecto funcional en entorno Flutter (Visual Studio Code)  
⏳ Próximas mejoras:
- Integración con Firebase
- Backend dinámico
- Autenticación y persistencia de carrito

---

## 👨‍💻 Autor

**Giancarlo Soto** (Proyecto inicial en Android)  
**Migración a Flutter:** *Antony Munive*  

📅 **Versión actual:** 1.0.0  
📍 **Estado:** Estable y en desarrollo activo

---

## 📝 Licencia

Este proyecto se distribuye bajo la licencia **MIT**.  
Puedes usarlo, modificarlo y distribuirlo libremente, siempre citando la fuente.

---

## 💡 Notas

- No requiere conexión a internet.  
- Todas las imágenes y datos son locales.  
- Para futuras versiones se planea integrar un backend y servicios en la nube.

---