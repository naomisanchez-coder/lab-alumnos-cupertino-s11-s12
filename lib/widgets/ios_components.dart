import 'package:flutter/cupertino.dart';

import '../theme/app_theme.dart';

/// Limita el ancho en escritorio y conserva desplazamiento con el teclado.
class IosPage extends StatelessWidget {
  const IosPage({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
    this.scroll = true,
  });
  final String title;
  final Widget child;
  final Widget? trailing;
  final bool scroll;
  @override
  Widget build(BuildContext context) => CupertinoPageScaffold(
    navigationBar: CupertinoNavigationBar(
      middle: Text(title),
      trailing: trailing,
      previousPageTitle: 'Volver',
    ),
    child: SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: scroll
              ? SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.all(20),
                  child: child,
                )
              : child,
        ),
      ),
    ),
  );
}

class AcademicIcon extends StatelessWidget {
  const AcademicIcon({
    super.key,
    this.icon = CupertinoIcons.book_fill,
    this.large = false,
  });
  final IconData icon;
  final bool large;
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(large ? 24 : 10),
    decoration: BoxDecoration(
      color: AppTheme.lightPurple,
      borderRadius: BorderRadius.circular(large ? 28 : 14),
    ),
    child: Icon(icon, size: large ? 48 : 24, color: AppTheme.primaryColor),
  );
}

class Intro extends StatelessWidget {
  const Intro(this.title, this.subtitle, {super.key});
  final String title, subtitle;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTheme.heading),
        const SizedBox(height: 8),
        Text(subtitle, style: AppTheme.caption),
      ],
    ),
  );
}

Future<void> showNotice(BuildContext context, String title, String message) =>
    showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
