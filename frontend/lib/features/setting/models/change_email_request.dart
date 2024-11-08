class ChangeEmailRequest {
  final String newEmail;

  ChangeEmailRequest({required this.newEmail});

  Map<String, dynamic> toJson() => {
        'new_email': newEmail,
      };
}
