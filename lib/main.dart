import 'package:flutter/cupertino.dart';

import 'screens/login_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/alumnos_screen.dart';
import 'screens/registro_screen.dart';
import 'screens/perfil_screen.dart';

// Necesario para reconocer AppTheme.lightTheme.
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

/// Widget principal de Gestión de Alumnos.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Gestión de Alumnos',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      // Ruta inicial de la aplicación.
      initialRoute: '/',

      // Rutas utilizadas para navegar entre las pantallas.
      routes: {
        '/': (context) => const LoginScreen(),
        '/menu': (context) => const MenuScreen(),
        '/registro': (context) => const RegistroScreen(),
        '/alumnos': (context) => const AlumnosScreen(),
        '/perfil': (context) => const PerfilScreen(),
      },
    );
  }
}
