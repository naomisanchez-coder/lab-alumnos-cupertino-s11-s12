import 'package:flutter/cupertino.dart';

import '../data/alumnos_data.dart';
import '../models/alumno.dart';
import '../utils/validators.dart';
import '../widgets/ios_components.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});
  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _surname = TextEditingController();
  final _grade = TextEditingController();
  bool _saving = false;
  @override
  void dispose() {
    _name.dispose();
    _surname.dispose();
    _grade.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) {
      return;
    }
    FocusScope.of(context).unfocus();
    if (!_form.currentState!.validate()) {
      return;
    }
    setState(() => _saving = true);
    final id =
        alumnosDemo.fold<int>(0, (max, a) => a.id > max ? a.id : max) + 1;
    final alumno = Alumno(
      id: id,
      nombre: _name.text.trim(),
      apellido: _surname.text.trim(),
      nota: int.parse(_grade.text.trim()),
    );
    alumnosDemo.add(alumno);
    await showNotice(
      context,
      'Registro exitoso',
      '${alumno.nombreCompleto} fue registrado correctamente.\nNota: ${alumno.nota} / 20\n${alumno.aprobado ? 'Aprobado' : 'Desaprobado'}',
    );
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) => IosPage(
    title: 'Registrar Alumno',
    child: Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: AcademicIcon(icon: CupertinoIcons.person_badge_plus),
          ),
          const Intro(
            'Un nuevo comienzo',
            'Completa los datos del estudiante. Su estado académico se calcula automáticamente.',
          ),
          CupertinoFormSection.insetGrouped(
            margin: EdgeInsets.zero,
            header: const Text('DATOS DEL ALUMNO'),
            children: [
              CupertinoTextFormFieldRow(
                controller: _name,
                placeholder: 'Nombre',
                validator: Validators.name,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
              ),
              CupertinoTextFormFieldRow(
                controller: _surname,
                placeholder: 'Apellido',
                validator: Validators.name,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
              ),
              CupertinoTextFormFieldRow(
                controller: _grade,
                placeholder: 'Nota (0 a 20)',
                validator: Validators.grade,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _save(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          CupertinoButton.filled(
            onPressed: _saving ? null : _save,
            child: const Text('GUARDAR'),
          ),
        ],
      ),
    ),
  );
}
