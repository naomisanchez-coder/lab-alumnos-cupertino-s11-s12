import 'package:flutter/cupertino.dart';

import '../widgets/ios_components.dart';
import '../theme/app_theme.dart';
import '../utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _hidden = true;
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _login() {
    FocusScope.of(context).unfocus();
    if (_form.currentState!.validate()) {
      Navigator.pushReplacementNamed(context, '/menu');
    }
  }

  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
    child: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Center(child: AcademicIcon(large: true)),
                  const SizedBox(height: 24),
                  const Text(
                    'Iniciar Sesión',
                    textAlign: TextAlign.center,
                    style: AppTheme.heading,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Tu aula, en un solo lugar.\nIngresa para gestionar a tus alumnos.',
                    textAlign: TextAlign.center,
                    style: AppTheme.caption,
                  ),
                  const SizedBox(height: 24),
                  // La sección agrupa campos y separadores con apariencia nativa iOS.
                  CupertinoFormSection.insetGrouped(
                    margin: EdgeInsets.zero,
                    children: [
                      CupertinoTextFormFieldRow(
                        controller: _email,
                        placeholder: 'Correo electrónico',
                        prefix: const Icon(
                          CupertinoIcons.mail,
                          color: AppTheme.primaryColor,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autocorrect: false,
                        validator: Validators.email,
                      ),
                      CupertinoTextFormFieldRow(
                        controller: _password,
                        placeholder: 'Contraseña',
                        prefix: CupertinoButton(
                          padding: const EdgeInsets.all(8),
                          onPressed: () => setState(() => _hidden = !_hidden),
                          child: Semantics(
                            label: _hidden
                                ? 'Mostrar contraseña'
                                : 'Ocultar contraseña',
                            child: Icon(
                              _hidden
                                  ? CupertinoIcons.eye
                                  : CupertinoIcons.eye_slash,
                              size: 22,
                            ),
                          ),
                        ),
                        obscureText: _hidden,
                        autocorrect: false,
                        enableSuggestions: false,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _login(),
                        validator: Validators.password,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  CupertinoButton.filled(
                    onPressed: _login,
                    child: const Text('Iniciar sesión'),
                  ),
                  CupertinoButton(
                    onPressed: () => showNotice(
                      context,
                      'Recuperar contraseña',
                      'La recuperación no está disponible en esta demostración. El inicio de sesión es simulado.',
                    ),
                    child: const Text('¿Olvidaste tu contraseña?'),
                  ),
                  const Text(
                    'GESTIÓN DE ALUMNOS',
                    textAlign: TextAlign.center,
                    style: AppTheme.caption,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
