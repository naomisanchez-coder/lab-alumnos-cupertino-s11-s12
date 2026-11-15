abstract final class Validators {
  static String? name(String? value) {
    final text = value?.trim() ?? '';
    if (text.length < 2) return 'Ingresa al menos 2 caracteres';
    if (!RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ]+(?:[ '\-][a-zA-ZáéíóúÁÉÍÓÚñÑüÜ]+)*$")
        .hasMatch(text)) {
      return 'Usa solo letras y separadores de nombres';
    }
    return null;
  }

  static String? email(String? value) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value?.trim() ?? '')
      ? null
      : 'Ingresa un correo válido';
  static String? password(String? value) =>
      (value?.length ?? 0) >= 6 ? null : 'Debe tener al menos 6 caracteres';
  static String? grade(String? value) {
    final text = value?.trim() ?? '';
    final grade = int.tryParse(text);
    return !RegExp(r'^\d{1,2}$').hasMatch(text) || grade == null || grade > 20
        ? 'Ingresa una nota entera entre 0 y 20'
        : null;
  }

  static String? phone(String? value) =>
      RegExp(r'^\d{9}$').hasMatch(value?.trim() ?? '')
      ? null
      : 'Ingresa un teléfono de 9 dígitos';
}
