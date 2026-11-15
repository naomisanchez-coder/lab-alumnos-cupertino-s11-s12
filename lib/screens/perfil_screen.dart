import 'package:flutter/cupertino.dart';

import '../data/perfil_data.dart';
import '../theme/app_theme.dart';
import '../utils/validators.dart';
import '../widgets/ios_components.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});
  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  Future<void> _edit() async {
    final saved = await Navigator.of(context)
        .push<bool>(CupertinoPageRoute(builder: (_) => const _EditarPerfil()));
    if (!mounted || saved != true) {
      return;
    }
    setState(() {});
    await showNotice(
      context,
      'Perfil actualizado',
      'Tus cambios se guardaron correctamente.',
    );
  }

  Widget _row(IconData icon, String label, String value) =>
      CupertinoListTile.notched(
        leading: Icon(icon, color: AppTheme.primaryColor),
        title: Text(label),
        subtitle: Text(value, maxLines: 3),
      );
  @override
  Widget build(BuildContext context) => IosPage(
    title: 'Perfil',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        const Center(
          child: AcademicIcon(
            icon: CupertinoIcons.person_crop_circle_fill,
            large: true,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          perfilDemo.nombre,
          textAlign: TextAlign.center,
          style: AppTheme.heading,
        ),
        const SizedBox(height: 8),
        Text(
          perfilDemo.email,
          textAlign: TextAlign.center,
          style: AppTheme.caption,
        ),
        const SizedBox(height: 28),
        CupertinoListSection.insetGrouped(
          margin: EdgeInsets.zero,
          header: const Text('INFORMACIÓN PERSONAL'),
          children: [
            _row(CupertinoIcons.person, 'Nombre', perfilDemo.nombre),
            _row(CupertinoIcons.mail, 'Correo electrónico', perfilDemo.email),
            _row(CupertinoIcons.phone, 'Teléfono', perfilDemo.telefono),
            _row(CupertinoIcons.briefcase, 'Rol', perfilDemo.rol),
          ],
        ),
        const SizedBox(height: 24),
        CupertinoButton.filled(
          onPressed: _edit,
          child: const Text('EDITAR PERFIL'),
        ),
      ],
    ),
  );
}

/// Ruta Cupertino independiente: permite desplazarse con el teclado abierto.
class _EditarPerfil extends StatefulWidget {
  const _EditarPerfil();
  @override
  State<_EditarPerfil> createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<_EditarPerfil> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController(text: perfilDemo.nombre);
  final _email = TextEditingController(text: perfilDemo.email);
  final _phone = TextEditingController(text: perfilDemo.telefono);
  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _save() {
    FocusScope.of(context).unfocus();
    if (!_form.currentState!.validate()) {
      return;
    }
    perfilDemo.nombre = _name.text.trim();
    perfilDemo.email = _email.text.trim();
    perfilDemo.telefono = _phone.text.trim();
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) => IosPage(
    title: 'Editar Perfil',
    child: Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Intro('Tus datos', 'Actualiza tu información de contacto.'),
          CupertinoFormSection.insetGrouped(
            margin: EdgeInsets.zero,
            children: [
              CupertinoTextFormFieldRow(
                controller: _name,
                placeholder: 'Nombre completo',
                validator: Validators.name,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
              ),
              CupertinoTextFormFieldRow(
                controller: _email,
                placeholder: 'Correo electrónico',
                validator: Validators.email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autocorrect: false,
              ),
              CupertinoTextFormFieldRow(
                controller: _phone,
                placeholder: 'Teléfono',
                validator: Validators.phone,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _save(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          CupertinoButton.filled(
            onPressed: _save,
            child: const Text('GUARDAR CAMBIOS'),
          ),
          CupertinoButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    ),
  );
}
