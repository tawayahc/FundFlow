class User {
  final String email;
  final String username;
  final String? profileImageUrl; // New optional field for avatar

  User({
    required this.email,
    required this.username,
    this.profileImageUrl,
  });

  // Factory method to create a User from JSON data
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] as String? ?? '', // Provide a default if null
      username: json['username'] as String? ?? '', // Provide a default if null
      profileImageUrl: json['user_profile_pic'] as String?, // Parse avatar URL
    );
  }

  // Method to convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      if (profileImageUrl != null)
        'user_profile_pic': profileImageUrl, // Include if available
    };
  }

  // Optional: copyWith method for easier state updates
  User copyWith({
    String? email,
    String? username,
    String? profileImageUrl,
  }) {
    return User(
      email: email ?? this.email,
      username: username ?? this.username,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
