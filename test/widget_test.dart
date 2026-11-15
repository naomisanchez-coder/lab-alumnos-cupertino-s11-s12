import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab_alumnos/main.dart';
import 'package:lab_alumnos/data/alumnos_data.dart';
import 'package:lab_alumnos/data/perfil_data.dart';
import 'package:lab_alumnos/models/alumno.dart';
import 'package:lab_alumnos/utils/validators.dart';

Finder field(String placeholder) => find.byWidgetPredicate(
  (w) => w is CupertinoTextField && w.placeholder == placeholder,
);
Future<void> tapText(WidgetTester tester, String text) async {
  final target = find.text(text).last;
  await tester.ensureVisible(target);
  await tester.tap(target);
  await tester.pumpAndSettle();
}

Future<void> login(WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  await tester.enterText(field('Correo electrónico'), 'docente@correo.com');
  await tester.enterText(field('Contraseña'), '123456');
  await tapText(tester, 'Iniciar sesión');
}

void main() {
  setUp(() {
    alumnosDemo
      ..clear()
      ..addAll(alumnosIniciales.map(Alumno.fromMap));
    perfilDemo.nombre = 'María González';
    perfilDemo.email = 'maria.gonzalez@correo.com';
    perfilDemo.telefono = '912345678';
  });
  test('Validaciones de nombres, correo, teléfono, contraseña y notas', () {
    for (final value in ['', 'A', 'Ana2', '---', '  ']) {
      expect(Validators.name(value), isNotNull);
    }
    for (final value in ['Ana María', 'García', "O'Neill", 'Pérez-Ruiz']) {
      expect(Validators.name(value), isNull);
    }
    for (final value in ['', '-1', '21', '2.5', 'abc', '1e1']) {
      expect(Validators.grade(value), isNotNull);
    }
    for (final value in ['0', '09', '11', '20']) {
      expect(Validators.grade(value), isNull);
    }
    expect(Validators.email('a@b.com'), isNull);
    expect(Validators.email('a@b'), isNotNull);
    expect(Validators.phone('912345678'), isNull);
    expect(Validators.phone('91234567a'), isNotNull);
    expect(Validators.password('12345'), isNotNull);
    expect(Validators.password('123456'), isNull);
  });
  test('Modelo, mapas y límite académico de aprobación', () {
    for (final nota in [0, 9, 10, 11, 20]) {
      final a = Alumno(id: nota, nombre: 'Ana', apellido: 'Torres', nota: nota);
      expect(a.aprobado, nota >= 11);
      expect(Alumno.fromMap(a.toMap()).nota, nota);
      expect(a.nombreCompleto, 'Ana Torres');
    }
    expect(alumnosDemo.map((a) => a.nota), [18, 12, 9, 15]);
  });
  testWidgets('Login inválido, contraseña visible y recuperación informativa', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tapText(tester, 'Iniciar sesión');
    expect(find.text('Ingresa un correo válido'), findsOneWidget);
    expect(find.text('Debe tener al menos 6 caracteres'), findsOneWidget);
    await tester.tap(find.byIcon(CupertinoIcons.eye));
    await tester.pump();
    expect(
      tester.widget<CupertinoTextField>(field('Contraseña')).obscureText,
      isFalse,
    );
    await tapText(tester, '¿Olvidaste tu contraseña?');
    expect(find.byType(CupertinoAlertDialog), findsOneWidget);
    await tapText(tester, 'Aceptar');
    expect(find.text('Iniciar Sesión'), findsOneWidget);
  });
  testWidgets('Búsqueda por nombre y apellido, limpiar, detalles y registro', (
    tester,
  ) async {
    await login(tester);
    await tapText(tester, 'Listar Alumnos');
    expect(find.text('Ana Torres'), findsOneWidget);
    final search = find.byType(CupertinoSearchTextField);
    await tester.enterText(search, 'garcía');
    await tester.pumpAndSettle();
    expect(find.text('Luis García'), findsOneWidget);
    expect(find.text('Ana Torres'), findsNothing);
    await tester.enterText(search, 'ana');
    await tester.pumpAndSettle();
    expect(find.text('Ana Torres'), findsOneWidget);
    await tester.enterText(search, 'inexistente');
    await tester.pumpAndSettle();
    expect(find.text('Sin resultados'), findsOneWidget);
    await tester.tap(find.byIcon(CupertinoIcons.xmark_circle_fill));
    await tester.pumpAndSettle();
    await tapText(tester, 'María López');
    expect(find.textContaining('Estado: Desaprobado'), findsOneWidget);
    await tapText(tester, 'Aceptar');
    await tester.tap(find.byIcon(CupertinoIcons.add));
    await tester.pumpAndSettle();
    await tapText(tester, 'GUARDAR');
    expect(alumnosDemo.length, 4);
    expect(find.text('Ingresa al menos 2 caracteres'), findsNWidgets(2));
    await tester.enterText(field('Nombre'), 'Lucía');
    await tester.enterText(field('Apellido'), 'Fernández');
    await tester.enterText(field('Nota (0 a 20)'), '21');
    await tapText(tester, 'GUARDAR');
    expect(alumnosDemo.length, 4);
    await tester.enterText(field('Nota (0 a 20)'), '17');
    await tapText(tester, 'GUARDAR');
    expect(find.text('Registro exitoso'), findsOneWidget);
    await tapText(tester, 'Aceptar');
    expect(find.text('Lucía Fernández'), findsOneWidget);
    expect(alumnosDemo.last.aprobado, isTrue);
    expect(alumnosDemo.map((a) => a.id).toSet().length, 5);
  });
  testWidgets('Perfil: cancelar, validar, guardar y conservar al volver', (
    tester,
  ) async {
    await login(tester);
    await tapText(tester, 'Perfil');
    await tapText(tester, 'EDITAR PERFIL');
    await tester.enterText(field('Nombre completo'), 'Otro Nombre');
    await tapText(tester, 'Cancelar');
    expect(perfilDemo.nombre, 'María González');
    await tapText(tester, 'EDITAR PERFIL');
    await tester.enterText(field('Correo electrónico'), 'incorrecto');
    await tester.enterText(field('Teléfono'), '12');
    await tapText(tester, 'GUARDAR CAMBIOS');
    expect(find.text('Ingresa un correo válido'), findsOneWidget);
    expect(find.text('Ingresa un teléfono de 9 dígitos'), findsOneWidget);
    expect(perfilDemo.email, 'maria.gonzalez@correo.com');
    await tester.enterText(field('Nombre completo'), 'Ana González');
    await tester.enterText(field('Correo electrónico'), 'ana@correo.com');
    await tester.enterText(field('Teléfono'), '987654321');
    await tapText(tester, 'GUARDAR CAMBIOS');
    await tapText(tester, 'Aceptar');
    expect(find.text('Ana González'), findsNWidgets(2));
    final context = tester.element(find.text('Perfil').first);
    Navigator.pop(context);
    await tester.pumpAndSettle();
    await tapText(tester, 'Perfil');
    expect(find.text('ana@correo.com'), findsNWidgets(2));
    expect(find.text('Docente'), findsOneWidget);
  });
  testWidgets('Registro desde menú y logout con cancelación y confirmación', (
    tester,
  ) async {
    await login(tester);
    await tapText(tester, 'Registrar Alumnos');
    expect(find.text('Registrar Alumno'), findsOneWidget);
    Navigator.pop(tester.element(find.text('Registrar Alumno')));
    await tester.pumpAndSettle();
    await tapText(tester, 'Logout');
    await tapText(tester, 'Cancelar');
    expect(find.text('Menú'), findsOneWidget);
    await tapText(tester, 'Logout');
    await tapText(tester, 'Salir');
    expect(find.text('Iniciar Sesión'), findsOneWidget);
    expect(
      Navigator.of(tester.element(find.text('Iniciar Sesión'))).canPop(),
      isFalse,
    );
  });
  testWidgets('Pantallas estrechas sin overflow y formulario con teclado', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await login(tester);
    expect(tester.takeException(), isNull);
    await tapText(tester, 'Listar Alumnos');
    expect(tester.takeException(), isNull);
    await tester.tap(find.byIcon(CupertinoIcons.add));
    await tester.pumpAndSettle();
    tester.view.viewInsets = const FakeViewPadding(bottom: 280);
    addTearDown(tester.view.resetViewInsets);
    await tester.pumpAndSettle();
    await tester.enterText(field('Nombre'), 'Ana');
    await tapText(tester, 'GUARDAR');
    expect(tester.takeException(), isNull);
  });
}
