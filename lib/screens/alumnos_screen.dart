import 'package:flutter/cupertino.dart';

import '../data/alumnos_data.dart';
import '../models/alumno.dart';
import '../theme/app_theme.dart';
import '../widgets/ios_components.dart';

class AlumnosScreen extends StatefulWidget {
  const AlumnosScreen({super.key});
  @override
  State<AlumnosScreen> createState() => _AlumnosScreenState();
}

class _AlumnosScreenState extends State<AlumnosScreen> {
  String _query = '';
  Future<void> _register() async {
    await Navigator.pushNamed(context, '/registro');
    if (mounted) {
      setState(() {});
    }
  }

  void _details(Alumno alumno) => showNotice(
    context,
    'Detalle del alumno',
    '${alumno.nombreCompleto}\nNota: ${alumno.nota.toString().padLeft(2, '0')} / 20\nEstado: ${alumno.aprobado ? 'Aprobado' : 'Desaprobado'}',
  );
  @override
  Widget build(BuildContext context) {
    final students = alumnosDemo
        .where(
          (a) => a.nombreCompleto.toLowerCase().contains(
            _query.trim().toLowerCase(),
          ),
        )
        .toList();
    return IosPage(
      title: 'Alumnos',
      scroll: false,
      trailing: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: _register,
        child: const Icon(
          CupertinoIcons.add,
          semanticLabel: 'Registrar alumno',
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Mi aula', style: AppTheme.heading),
                const SizedBox(height: 6),
                Text(
                  '${alumnosDemo.length} estudiantes · Aprobación desde 11',
                  style: AppTheme.caption,
                ),
                const SizedBox(height: 16),
                CupertinoSearchTextField(
                  placeholder: 'Buscar por nombre o apellido',
                  onChanged: (value) => setState(() => _query = value),
                ),
              ],
            ),
          ),
          Expanded(
            child: students.isEmpty
                ? SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const AcademicIcon(
                          icon: CupertinoIcons.search,
                          large: true,
                        ),
                        const Intro(
                          'Sin resultados',
                          'Prueba con otro nombre o apellido.',
                        ),
                        CupertinoButton.filled(
                          onPressed: _register,
                          child: const Text('Registrar alumno'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final alumno = students[index];
                      // Cada grupo blanco es el equivalente Cupertino de una tarjeta.
                      return CupertinoListSection.insetGrouped(
                        margin: const EdgeInsets.only(bottom: 10),
                        children: [
                          CupertinoListTile.notched(
                            leading: const AcademicIcon(),
                            leadingSize: 44,
                            title: Text(
                              alumno.nombreCompleto,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: [
                                  Text(
                                    'Nota: ${alumno.nota.toString().padLeft(2, '0')} / 20',
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: alumno.aprobado
                                          ? AppTheme.successSoft
                                          : AppTheme.dangerSoft,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      alumno.aprobado
                                          ? 'Aprobado'
                                          : 'Desaprobado',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: alumno.aprobado
                                            ? AppTheme.success
                                            : AppTheme.danger,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            trailing: const CupertinoListTileChevron(),
                            onTap: () => _details(alumno),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
