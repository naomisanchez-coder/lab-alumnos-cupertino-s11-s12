import 'package:flutter/cupertino.dart';

import '../widgets/ios_components.dart';
import '../theme/app_theme.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});
  Future<void> _logout(BuildContext context) async {
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Deseas salir de tu sesión?'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
    }
  }

  Widget _option(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    String route,
  ) => CupertinoListTile.notched(
    leading: AcademicIcon(icon: icon),
    leadingSize: 44,
    title: Text(title),
    subtitle: Text(subtitle),
    trailing: const CupertinoListTileChevron(),
    onTap: () => Navigator.pushNamed(context, route),
  );
  @override
  Widget build(BuildContext context) => IosPage(
    title: 'Menú',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Intro(
          'Tu espacio docente',
          'Organiza tu aula y acompaña el progreso de cada estudiante.',
        ),
        // Las secciones agrupadas sustituyen las tarjetas Material.
        CupertinoListSection.insetGrouped(
          margin: EdgeInsets.zero,
          header: const Text('GESTIÓN ACADÉMICA'),
          children: [
            _option(
              context,
              'Registrar Alumnos',
              'Agrega un nuevo estudiante',
              CupertinoIcons.person_badge_plus,
              '/registro',
            ),
            _option(
              context,
              'Listar Alumnos',
              'Consulta notas y estados',
              CupertinoIcons.list_bullet,
              '/alumnos',
            ),
          ],
        ),
        const SizedBox(height: 24),
        CupertinoListSection.insetGrouped(
          margin: EdgeInsets.zero,
          header: const Text('CUENTA'),
          children: [
            _option(
              context,
              'Perfil',
              'Tu información personal',
              CupertinoIcons.person_crop_circle,
              '/perfil',
            ),
            CupertinoListTile.notched(
              leading: const Icon(
                CupertinoIcons.square_arrow_right,
                color: AppTheme.danger,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(color: AppTheme.danger),
              ),
              trailing: const CupertinoListTileChevron(),
              onTap: () => _logout(context),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Sesión de demostración · Datos locales',
          textAlign: TextAlign.center,
          style: AppTheme.caption,
        ),
      ],
    ),
  );
}
