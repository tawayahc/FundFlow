class UserProfile {
  final String email;
  final String? username;
  final String? profileImageUrl;

  UserProfile({
    required this.email,
    this.username,
    this.profileImageUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      email: json['email'],
      username: json['username'],
      profileImageUrl: json['user_profile_pic'],
    );
  }
}
