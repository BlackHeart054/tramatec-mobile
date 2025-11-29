bool isValidEmail(String email) {
  final RegExp emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  return emailRegex.hasMatch(email);
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) return 'A senha é obrigatória.';

  if (value.length < 6) return 'Mínimo de 6 caracteres.';
  if (!value.contains(RegExp(r'[A-Z]'))) {
    return 'Precisa de uma letra maiúscula.';
  }
  if (!value.contains(RegExp(r'[a-z]'))) {
    return 'Precisa de uma letra minúscula.';
  }
  if (!value.contains(RegExp(r'[0-9]'))) return 'Precisa de um número.';
  if (!value.contains(RegExp(r'[!@#\$&*~^%_]'))) {
    return 'Precisa de um símbolo (!@#\$&*~).';
  }

  return null;
}

String? validateRequired(String? value, String fieldName) {
  if (value == null || value.trim().isEmpty) {
    return '$fieldName é obrigatório.';
  }
  return null;
}
