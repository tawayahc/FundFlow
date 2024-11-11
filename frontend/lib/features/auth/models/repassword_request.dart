class RepasswordRequest {
  final String email;
  final String newPassword;

  RepasswordRequest({required this.email, required this.newPassword});

  Map<String, dynamic> toJson() {
    return {'email': email, 'new_password': newPassword};
  }
}
