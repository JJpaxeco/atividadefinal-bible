String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Por favor, insira uma senha.';
  }
  if (value.length < 8) {
    return 'A senha deve ter pelo menos 8 caracteres.';
  }
  if (!value.contains(RegExp(r'[A-Z]'))) {
    return 'A senha deve conter pelo menos uma letra maiúscula.';
  }
  if (!value.contains(RegExp(r'[a-z]'))) {
    return 'A senha deve conter pelo menos uma letra minúscula.';
  }
  if (!value.contains(RegExp(r'[0-9]'))) {
    return 'A senha deve conter pelo menos um número.';
  }
  if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
    return 'A senha deve conter pelo menos um caractere especial.';
  }
  return null;
}
