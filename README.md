# Laboratorio S11–S12: Gestión de Alumnos con Cupertino

Aplicación académica Flutter que conserva las cinco pantallas y los flujos del laboratorio S07–S08. La migración reemplaza la presentación Material por una interfaz iOS con identidad morada, formularios agrupados, superficies blancas y contenido centrado de ancho limitado para móviles y escritorio.

## Tecnologías

Flutter, Dart, Cupertino y `cupertino_icons`. Pruebas con `flutter_test` y análisis con `flutter_lints`. Sin backend ni dependencias de gestión de estado externas.

## Estructura

```text
lib/
  main.dart                  # CupertinoApp, tema y mapa de rutas
  data/                      # Alumnos iniciales y perfil en memoria
  models/alumno.dart         # Modelo, mapas y regla de aprobación
  screens/                   # Login, menú, alumnos, registro y perfil
  theme/app_theme.dart       # Paleta y CupertinoThemeData
  utils/validators.dart      # Reglas compartidas de validación
  widgets/ios_components.dart # Página responsive, icono, encabezado y aviso
test/widget_test.dart        # Pruebas de datos e interacciones
```

## Pantallas y funcionalidades

| Pantalla | Implementación |
|---|---|
| Login | Correo válido, contraseña de seis caracteres como mínimo, mostrar/ocultar, recuperación informativa e ingreso simulado. |
| Menú | Registrar Alumnos, Listar Alumnos, Perfil y Logout con confirmación. El cierre elimina el historial de navegación. |
| Alumnos | Cuatro estudiantes iniciales, búsqueda por nombre/apellido sin distinguir mayúsculas, limpieza, estado vacío, nota, estado académico, detalles y acceso a registro. |
| Registro | Nombre y apellido de al menos dos caracteres sin números; nota entera de 0 a 20; identificador incremental único, confirmación y actualización del listado al regresar. |
| Perfil | María González, correo, teléfono y rol Docente. Edición validada de nombre, correo y teléfono de nueve dígitos; cancelación y confirmación de guardado. |

Las notas desde 11 indican **Aprobado**. Alumnos y perfil se conservan en memoria al navegar durante la ejecución de la app.

## Widgets y migración

- `CupertinoApp` y `CupertinoThemeData`: aplicación, rutas con transiciones iOS y tema global.
- `CupertinoPageScaffold`, `CupertinoNavigationBar`, `SafeArea` y límites de ancho: estructura adaptable.
- `CupertinoFormSection` y `CupertinoTextFormFieldRow`: formularios de login, registro y edición del perfil.
- `CupertinoListSection` y `CupertinoListTile`: menú, registros y datos del perfil.
- `CupertinoSearchTextField`: búsqueda y limpieza en el listado.
- `CupertinoButton`, `CupertinoAlertDialog` y `CupertinoDialogAction`: acciones, detalles y confirmaciones.
- `CupertinoIcons`: iconografía académica y de navegación.

Material utiliza `MaterialApp`, `ThemeData`, `Scaffold`, `ListTile` y `Card`. Esta versión usa sus componentes y patrones Cupertino. Las secciones blancas redondeadas son el equivalente visual de las tarjetas, sin necesitar `Card` de Material. Se mantienen `ListView.builder` para la lista dinámica, listas y mapas para los datos, rutas y un tema global, cubriendo los conceptos de la rúbrica.

## Instalación y ejecución manual

Desde la carpeta del proyecto, con Flutter SDK y Google Chrome instalados:

```bash
flutter pub get
flutter run -d chrome
```

La ejecución visual y las capturas quedan a cargo de la autora.

## Verificaciones técnicas

Ejecutadas durante la migración:

```bash
dart format lib test
flutter analyze
flutter test
flutter build web
```

Análisis sin incidencias, siete pruebas aprobadas y compilación web correcta en `build/web`. Las pruebas cubren validaciones, mapas, umbral de aprobación, login, recuperación, búsqueda, detalles, registro, edición/cancelación del perfil, persistencia al navegar, logout y un caso de pantalla de 320 píxeles con teclado. No se realizó ejecución visual en Chrome ni simuladores.

## Limitaciones reales

El login valida formato y longitud; no autentica usuarios. La recuperación es informativa. Los cambios no se guardan en disco y se pierden al reiniciar o recargar la aplicación; Logout solo modifica la navegación. No se incluye edición/eliminación de alumnos, API ni base de datos. La apariencia final requiere la revisión visual manual de la autora.

## Repositorio

[lab-alumnos-cupertino-s11-s12](https://github.com/naomisanchez-coder/lab-alumnos-cupertino-s11-s12)
