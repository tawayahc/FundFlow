String validatePassword(String password) {
  if (password.length < 8) {
    return 'Password must be at least 8 characters long.';
  }

  return ''; // Return an empty string if the password is valid
}

bool isValidEmail(String email) {
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  return emailRegex.hasMatch(email);
}
